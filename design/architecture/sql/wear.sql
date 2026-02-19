-- Степень состояния оборудования
-- Используется для индикаторов и агрегированного состояния.
CREATE TYPE severity_level AS ENUM (
    'normal',     -- состояние в пределах нормы
    'early',      -- ранние признаки отклонений
    'warning',    -- требуется внимание / планирование обслуживания
    'critical'    -- высокая вероятность отказа
);
-- Категория состояния оборудования
-- Используется для индикаторов и агрегированного состояния.
CREATE TYPE indicator_category AS ENUM (
    'condition',    -- Индикаторы сосотояния (condition_indicator_value)
    'operating'     -- Параметры режима (equipment_operating_snapshot)
);
-- Справочник диагностических индикаторов.
-- Таблица статическая.
-- Хранит описание типов индикаторов (не значения).
CREATE TABLE equipment_indicator (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    -- Категория condition, operating
    category            indicator_category NOT NULL,
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
-- Индекс для выборки активных индикаторов
CREATE INDEX idx_equipment_indicator_active_true
    ON equipment_indicator (id)
    WHERE is_active = true;

-- Индекс для выборки по категории
CREATE INDEX idx_equipment_indicator_category
    ON equipment_indicator (category);

-- История значений индикаторов (показателей) износа.
-- Каждая запись — это состояние конкретного индикатора на момент времени.
CREATE TABLE condition_indicator_value (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    -- Оборудование
    equipment_id    BIGINT NOT NULL
        REFERENCES equipment(id) ON DELETE CASCADE,
    -- Тип индикатора
    indicator_id    BIGINT NOT NULL
        REFERENCES equipment_indicator(id) ON DELETE CASCADE,
    -- Измеренное или рассчитанное значение
    value           DOUBLE PRECISION NOT NULL,
    -- Классификация состояния на момент 
    severity        severity_level NOT NULL,
    -- Временная метка значения
    created         TIMESTAMPTZ NOT NULL DEFAULT now()
);
-- Для получения последних значений
CREATE INDEX idx_civ_equipment_indicator_time
    ON condition_indicator_value (equipment_id, indicator_id, created DESC);
CREATE INDEX idx_civ_equipment_created
    ON condition_indicator_value (equipment_id, created DESC);
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
    created             TIMESTAMPTZ NOT NULL DEFAULT now()
);
-- Для выборки последнего состояния
CREATE INDEX idx_ers_equipment_time
    ON equipment_resource_state (equipment_id, created DESC);
-- Для чистки и retention
CREATE INDEX idx_ers_calculated_at
    ON equipment_resource_state (created);

-- История усреднённых режимов эксплуатации.
-- Каждая запись описывает агрегированный режим за произвольный период определяемый скоростью изменения.
-- Для анализа износа и аномалий.
CREATE TABLE equipment_operating_snapshot (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    -- Оборудование
    equipment_id    BIGINT NOT NULL
        REFERENCES equipment(id) ON DELETE CASCADE,
    -- Тип индикатора
    indicator_id    BIGINT NOT NULL
        REFERENCES equipment_indicator(id) ON DELETE CASCADE,
    -- Измеренное или рассчитанное значение
    value           DOUBLE PRECISION NOT NULL,
    -- Степень выхода из нормального режима работы
    severity        severity_level NOT NULL,
    -- Временная метка значения
    created         TIMESTAMPTZ NOT NULL DEFAULT now()
);
-- Для получения последних значений
CREATE INDEX idx_eos_operating_snapshot_time
    ON equipment_operating_snapshot (equipment_id, indicator_id, created DESC);
CREATE INDEX idx_eos_operating_snapshot_created
    ON equipment_operating_snapshot (equipment_id, created DESC);
-- Для операций очистки и retention
CREATE INDEX idx_eos_created
    ON equipment_operating_snapshot (created);
