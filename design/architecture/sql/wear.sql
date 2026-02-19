-- Степень состояния оборудования
-- Используется для индикаторов и агрегированного состояния.

CREATE TYPE severity_level AS ENUM (
    'normal',     -- состояние в пределах нормы
    'early',      -- ранние признаки отклонений
    'warning',    -- требуется внимание / планирование обслуживания
    'critical'    -- высокая вероятность отказа
);

-- Справочник диагностических индикаторов.
-- Таблица статическая.
-- Хранит описание типов индикаторов (не значения).
CREATE TABLE condition_indicator (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    -- Машинный код индикатора (например rms_vibration, bearing_temp)
    code                TEXT NOT NULL UNIQUE,
    -- Отображаемое имя для UI
    name                TEXT NOT NULL,
    -- Единица измерения (mm/s, °C, %, etc.)
    unit                TEXT,
    -- Пороговые значения данного типа индикатора
    threshold_warning   DOUBLE PRECISION,
    threshold_critical  DOUBLE PRECISION,
    -- Индикатор может быть временно отключён
    is_active           BOOLEAN NOT NULL DEFAULT TRUE
);
-- Индекс для выборки code
CREATE INDEX idx_condition_indicator_code
    ON condition_indicator (code);
-- Индекс для выборки активных индикаторов
CREATE INDEX idx_condition_indicator_active
    ON condition_indicator (is_active);

-- История значений индикаторов (insert-only).
-- Каждая запись — это состояние конкретного индикатора на момент времени.
CREATE TABLE condition_indicator_value (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    -- Оборудование
    equipment_id    BIGINT NOT NULL
        REFERENCES equipment(id) ON DELETE CASCADE,
    -- Тип индикатора
    indicator_id    BIGINT NOT NULL
        REFERENCES condition_indicator(id) ON DELETE CASCADE,
    -- Измеренное или рассчитанное значение
    value           DOUBLE PRECISION NOT NULL,
    -- Классификация состояния на момент измерения
    severity        severity_level NOT NULL,
    -- Временная метка значения
    created         TIMESTAMPTZ NOT NULL
);
-- Для получения последних значений
CREATE INDEX idx_civ_equipment_indicator_time
    ON condition_indicator_value (equipment_id, indicator_id, created DESC);
-- Для операций очистки и retention
CREATE INDEX idx_civ_created
    ON condition_indicator_value (created);

-- История изменения ресурсного состояния оборудования.
-- Хранит агрегированный результат расчёта износа.
-- Каждая запись — это состояние ресурса на момент времени.
CREATE TABLE equipment_resource_state (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    -- Оборудование
    equipment_id        BIGINT NOT NULL
        REFERENCES equipment(id) ON DELETE CASCADE,
    -- Накопленный израсходованный ресурс
    used_resource       DOUBLE PRECISION NOT NULL
        CHECK (used_resource >= 0),
    -- Оставшийся ресурс
    remaining_resource  DOUBLE PRECISION NOT NULL
        CHECK (remaining_resource >= 0),
    -- Текущая скорость износа
    wear_rate           DOUBLE PRECISION NOT NULL
        CHECK (wear_rate >= 0),
    -- Степень износа
    severity            severity_level NOT NULL,
    -- Время расчёта состояния
    created             TIMESTAMPTZ NOT NULL
);
-- Для выборки последнего состояния
CREATE INDEX idx_ers_equipment_time
    ON equipment_resource_state (equipment_id, created DESC);
-- Для чистки и retention
CREATE INDEX idx_ers_calculated_at
    ON equipment_resource_state (created);

-- История усреднённых режимов эксплуатации.
-- Каждая запись описывает агрегированный режим за период.
-- Для анализа износа и аномалий.
CREATE TABLE equipment_operating_snapshot (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    -- Оборудование
    equipment_id        BIGINT NOT NULL
        REFERENCES equipment(id) ON DELETE CASCADE,
    -- Усреднённые параметры эксплуатации
    avg_rpm             DOUBLE PRECISION,
    max_load            DOUBLE PRECISION,
    temperature_avg     DOUBLE PRECISION,
    duty_cycle          DOUBLE PRECISION,
    starts_count        INTEGER,
    -- Время фиксации snapshot в БД
    created             TIMESTAMPTZ NOT NULL DEFAULT now(),
    CHECK (period_end > period_start)
);
-- Получение последних режимов
CREATE INDEX idx_eos_equipment_period
    ON equipment_operating_snapshot (equipment_id, period_start DESC);
-- Retention / архивация
CREATE INDEX idx_eos_period_start
    ON equipment_operating_snapshot (period_start);
