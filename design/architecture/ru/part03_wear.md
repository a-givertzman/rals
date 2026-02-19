# Износ оборудования (MVP)

---

# 1. Общая логика

Строится на событийной архитектуре.

Источники:

* operating events (режим работы)
* sensor events (сигналы диагностики)

Расчётные сервисы подписаны на события и формируют проекции состояния.

В БД хранятся только проекции (calculated state).

---

# 2. Описание модели

## I. Operating Parameters (Параметры режима)

Измеряемые эксплуатационные величины, поступающие из событий.

Примеры:

* rpm
* torque
* load
* temperature
* starts_count
* duty_cycle

Роль:

* участвуют в формуле расчёта износа
* не хранятся как поток в MVP
* используются в момент расчёта

В будущем:

* возможна запись агрегированного snapshot режима

---

## II. Wear Factors (Факторы износа)

Параметры режима, участвующие в формуле расчёта износа.

Критерий:

Если величина участвует в формуле расчёта ресурса — это wear factor.

В MVP:

* значения не хранятся
* хранятся только типы факторов (для конфигурации модели)

---

### Таблица: wear_factor_type

```
- id
- code
- name
- unit
- description
- is_active
```

Назначение:

* конфигурация формулы расчёта ресурса
* возможность расширения модели

---

## III. Condition Indicators (Диагностические индикаторы)

Вычисляемые показатели, отражающие техническое состояние оборудования.

Например:

* RMS vibration
* BPFO amplitude
* imbalance index
* lubrication degradation index
* overheating_frequency

---

### Таблица: condition_indicator

* описание диагностического индикатора
* конфигурация порогов

```
- id
- code
- name
- unit
- threshold_warning
- threshold_critical
- description
- is_active
```

---

### Таблица: condition_indicator_value

Текущее значение конкретного индикатора

```
- equipment_id
- indicator_id
- value
- severity        (normal / warning / critical)
- calculated_at
```

---

## IV. Resource State (Текущее состояние Ресурса)

Расчётный остаточный ресурс оборудования.

---

### Таблица: equipment_resource_state

```
- equipment_id
- used_resource
- remaining_resource
- wear_rate
- acceleration_factor (nullable)
- calculated_at
```

---

## V. Health State (Агрегированное состояние)

Интегральная оценка состояния оборудования.

Формируется на основе:

* remaining_resource
* condition_indicator_value

---

### Таблица: equipment_health_state

* отображение пользователю
* быстрый агрегированный статус

```
- equipment_id
- health_score    (0–100)
- severity
- calculated_at
```

---

## VI. Operating Snapshot (опционально для MVP)

Усреднённый режим.

---

### Таблица: equipment_operating_snapshot

* объясняет причины неисправностей
* ретроаналитика

```
- equipment_id
- period_start
- period_end
- avg_rpm
- max_load
- temperature_avg
- duty_cycle
- starts_count
- created_at
```

# 3. Итоговая структура хранения

* wear_factor_type
* condition_indicator
* condition_indicator_value
* equipment_resource_state
* equipment_health_state
* equipment_operating_snapshot (опционально)
* equipment_operating_history (в будущих версиях)
