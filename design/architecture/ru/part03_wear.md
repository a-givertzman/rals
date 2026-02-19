# Износ оборудования (MVP)

---

# 1. Общая логика

Подсистема построена на событийной архитектуре.

Источники:

* operating events (режим работы)
* sensor events (сигналы диагностики)

Расчётные сервисы:

* подписаны на события через YAML-конфигурацию
* получают параметры модели из конфигурации и equipment.attributes
* формируют проекции состояния

В БД хранятся только проекции состояния (calculated state).

Поток operating parameters не сохраняется.

## 1.1. Структура БД

### Проекции состояния

* equipment_resource_state
* condition_indicator_value
* equipment_health_state

### Справочник

* condition_indicator

### Исторические агрегаты

* equipment_operating_snapshot

### Конфигурация

* YAML-конфиг сервиса
* equipment.attributes

### Связи

* equipment 1 : 1 equipment_resource_state
* equipment 1 : 1 equipment_health_state
* equipment 1 : N condition_indicator_value
* equipment 1 : N equipment_operating_snapshot
* condition_indicator 1 : N condition_indicator_value

---

# 2. Описание модели

---

## I. Operating Parameters (Параметры режима)

Измеряемые эксплуатационные величины, поступающие из событий.

* Используются в алгоритмах расчёта износа
* Определяются подпиской расчётного сервиса на события
* Не сохраняются как поток в MVP.

Факторы износа (если хотим показать пользователю) определяются подписками в конфигурации алгоритмов расчёта износа.

Примеры:

* rpm
* torque
* load
* temperature
* starts_count
* duty_cycle

---

## II. Конфигурация расчётной модели

Параметры алгоритма расчёта:

* базовая скорость износа
* коэффициенты нагрузки
* температурные коэффициенты
* поправочные множители
* версия модели

Хранятся:

* в YAML-конфигурации сервиса (системные параметры)
* в equipment.attributes (пользовательские и настраиваемые параметры)

---

## III. Condition Indicators (Диагностические индикаторы)

Вычисляемые показатели, численно отражающие техническое состояние оборудования
    - текущие показатели износа
    - пороги допустимых значений

Используются для диагностики и формирования агрегированного состояния.

Примеры:

* RMS vibration
* BPFO amplitude
* imbalance index
* lubrication degradation index
* overheating_frequency

---

### Таблица: condition_indicator (Справочник)

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

Текущее значение индикатора для оборудования.

История значений в MVP не хранится.

```
- equipment_id
- indicator_id
- value
- severity        (normal / warning / critical)
- calculated_at
```

Связи:

* equipment 1 : N condition_indicator_value
* condition_indicator 1 : N condition_indicator_value

Ограничение:

* уникальность (equipment_id, indicator_id)

---

## IV. Resource State (Текущее состояние ресурса)

Расчётный остаточный ресурс оборудования.

---

### Таблица: equipment_resource_state

```
- equipment_id
- used_resource
- remaining_resource
- wear_rate
- calculated_at
```

Связь:

* equipment 1 : 1 equipment_resource_state

---

## V. Health State (Агрегированное состояние)

Интегральная оценка состояния оборудования.

Используется для отображения агрегированного статуса пользователю.

Формируется на основе:

* remaining_resource
* condition_indicator_value

---

### Таблица: equipment_health_state

```
- equipment_id
- health_score    (0–100)
- severity
- calculated_at
```

Связь:

* equipment 1 : 1 equipment_health_state

---

## VI. Operating Snapshot (опционально для MVP)

Агрегированный режим работы за период.

* объяснения скачков износа
* анализа событий перед дефектом
* ретроаналитики

---

### Таблица: equipment_operating_snapshot

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

Связь:

* equipment 1 : N equipment_operating_snapshot

---

## VII. History (опционально для MVP)

История режима работы оборудования и развития неисправностей

Реализуется записью множества записей в соответствующие таблицы вместо одной.

Ограничивается:
    - сроком ханения - пользователь
    - количеством записей - защита от переполнения диска

* Condition Indicators - Хранит подробную историю свежих изменений и прореживается до ключевых изменений по мере старения, ограничивается
* Resource State - Хранит историю изменений ресурса, ограничивается
* Operating Snapshot - Хранит историю изменений (возмущений) режима
