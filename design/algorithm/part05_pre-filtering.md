# Предварительная фильтрация сигнала "На лету"

Удаление шумов и помех для выделения полезной информации.

## Integrated threshold filter

Фильтр для предварительной фильтрации.

Алгоритм:


1. **Инициализация**. Начальное значение `value` устанавливается равным первому входному значению:

$$ value = input_1 $$

3. **Расчет дельты**. Вычисляется приращение `delta`:

$$ delta = delta + |value - input_i| * K_{int} $$

4. **Проверка порога**:

   Если `delta > threshold`, то:

   - Обновляется значение:

$$ value = input_i $$

   - Сбрасывается `delta`:

$$ delta = 0 $$

5. **Повторение процесса** — переход к шагу 2.
