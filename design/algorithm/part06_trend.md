## 7. Выявление тренда (метод наименьших квадратов, МНК)

Определение основной тенденции изменения сигнала.


Для аналитики характера данных, взаимосвязь и форму, необходимо ввести такие термины как корреля корреляционный анализ, регрессионный анализ, метод наименьших квадратов. 

### 7.1 Терминология:
- **Корреляционный анализ (корреляция)** – статистический метод, позволяющий с использованием коэффициентов корреляции определить, существует ли зависимость между переменными и насколько она сильна.

- **Корреляционный анализ** — это метод по изучению статистической зависимости между случайными величинами с необязательным наличием строгого функционального характера, при которой динамика одной случайной величины приводит к динамике математического ожидания другой.

(на выбор определение)

- **Регрессионный анализ (регрессия)** — это метод статистического анализа, который устанавливает зависимость одной переменной (зависимой) от одной или нескольких независимых (объясняющих) переменных. Этот инструмент позволяет количественно оценивать влияние факторов и прогнозировать значения зависимой переменной в новых условиях.

### 7.2 Задачи корреляционного и регресионного анализа

- **Задачами корреляционного анализа** являются получение данных от объекта исследования (наблюдения) и определение зависимости между показателями данных. Также данный метод выявляет факторы, которые наиболее влияют на максимально благоприятный результат и изучает параметры связи при работе для наилучшей оценки производства.

- **Задача регрессионного анализа** – выявление показателя, насколько изменение одной переменной (фактора) в среднем влияет на изменение другой переменной (результативного признака), выбор типа модели (формы связи), определение расчетных значений зависимой переменной (функции регрессии). Этот метод позволяет предсказывать значения зависимой переменной на основе значений независимых переменных. 

### 7.3 Корреляционный анализ

Корреляционный анализ основан на коэффициенте корреляции, который показывает степень связи между двумя переменными. Его значения находятся в диапазоне от `-1` до `+1`.

+ Если коэффициент близок к `+1`, переменные имеют `прямую зависимость`: при увеличении одной увеличивается и другая.
+ Если он близок к `-1`, наблюдается `обратная зависимость`: рост одной переменной сопровождается снижением другой.
+ Если значение около `0`, статистическая `связь между переменными отсутствует или крайне слабая`.

Для словесного описания величины коэффициента корреляции используются следующие градации [1, c. 257]: 

| Значение | Интерпретация




|--------- |--------------|
| `до 0.2` | Очень слабая корреляция |
| `до 0.5` | Слабая корреляция |
| `до 0.7` | Средняя корреляция |
| `до 0.9` | Высокая корреляция |
| `свыше 0.9` | Очень высокая корреляция |


![alt text](../../assets/algorithm/image.png)


В зависимости от формы, связь может быть:

+ **Прямолинейной** – когда равномерное изменение одного признака сопровождается равномерным изменением другого признака, с незначительными отклонениями.

+ **Криволинейной** – когда равномерное изменение одного признака приводит к неравномерному изменению второго признака, причем эта неравномерность подчиняется определенной закономерности. В определенный момент общая тенденция изменяет направление, образуя изгиб.


#### 7.3.1 Формулы, используемые для корреляционного анализа

`Коэффициент корреляции Пирсона`:

$$
R_{XY} =\frac{cov(x,y)}{\sigma_{x}\sigma_{y}} = \frac{\sum (x_i - \bar{x}) (y_i - \bar{y})}{\sqrt{\sum (x_i - \bar{x})^2 \sum (y_i - \bar{y})^2}}
$$

где:
- $x_i, y_i$ — значения переменных,
- $\bar{x} = \frac{1}{n}\sum x_i ; \bar{y} = \frac{1}{n}\sum y_i$ — среднее значение выборок,
- $\sigma_{x}, \sigma_{y}$ — стандартное отклонение переменных x , y.


**Стандартное отклонение (𝜎)** показывает, насколько сильно значения данных разбросаны относительно их среднего значения.

`Формула стандартного отклонения` для выборки:
$$\sigma_{x} =\sqrt{\frac{\sum (x_i - \bar{x})^2}{n - 1}}$$

$$\sigma_{y} =\sqrt{\frac{\sum (y_i - \bar{y})^2}{n - 1}}$$

`Формула расчета ковариации` двух переменных:

$$cov(x,y) = \frac{\sum (x_i - \bar{x}) (y_i - \bar{y})}{n-1}$$


`Ранговый коэффициент линейной корреляции Спирмена`:
Ранговый коэффициент корреляции Спирмена (𝜌) используется для измерения связи между двумя переменными на основе рангов, а не самих значений. Он оценивает, насколько монотонна зависимость между переменными (но не обязательно линейна).

$$𝜌 = 1 - \frac{6\sum d_{i}^2} {n(n^2-1)}$$

где: 
- $n$ — количество ранжированных пар;
- $d_{i}$ — разность между рангами по двум переменным для каждого испытуемого $d_{i} = R(x_{i}) - R(y_{i})$; 
- $\sum d_{i}^2$ — сумма квадратов разностей рангов.

Правила ранжирования 

1. Меньшему значению присваивается меньший ранг (иногда наоборот)
2. В случае, если несколько значений равны, им начиляется ранг, представляющий собой среднее значение из тех рангов, которые они получили бы, если бы не были равны 


`Коэффициент Спирмена`, может принимать значение от `+1` до `-1`, где,

- Значение p равное `+1` означает идеальную связь рангов
- Значение p равное `0` означает отсутствие связи рангов
- Значение p равное `-1` означает идеальную отрицательную связь между рангами.

### 7.4 Регрессионный анализ 

Если расчет корреляции характеризует `силу связи` между двумя перемнными. то региресионный анализ служит для определения `вида этой связи` и дает возможность  для прогнозорирвоания значения одной (зависимой) переменной отталкиваясь от значения другой (независмой) переменной.

Введем термины:

- **Зависимая переменная** — результат, который анализируют и прогнозируют.
- **Независимые переменные** — факторы, влияющие на зависимую переменную.

При рассмотрении зависимости `двух случайных величин` говорят о `парной регрессии`, зависимость `нескольких` переменных называют `множественной регрессией`.

#### 7.4.1 Линейная регрессия 

Модель зависимости переменной `x` от одной или нескольких других переменных (факторов, регрессоров, независимых переменных) с линейной функцией зависимости. 

Линейная регрессия некоторой зависимой переменной `y` на набор независимых переменных `x = (x₁, …, xᵣ)`, где r – это число предикторов (независимые  переменные, используемые в модели регрессии для прогнозирования или объяснения зависимой переменной), предполагает, что линейное отношение между `y` и `x`:

$$y = \beta_{0} + \beta_{1}x + \epsilon $$

где:
- $y-$ зависимая переменная
- $x-$ независимая переменная
- $\beta_{0}, \beta_{1}$ - коэффициенты (интерцепт и наклон)

$\beta_{0}$ — точка пересечения с осью координат $y$. Это значение, которое принимает y в том случае, если x равен нулю.

$$y = \beta_{0} + \beta_{1}0 $$
$$y = \beta_{0}  $$

![alt text](../../assets/algorithm/image-2.png)

Регрессия позволяет подобрать к этим точкам линию $у=f(x)$, которая вычисляется по методу наименьших квадратов и даёт максимальное приближение к заданным параметрам 

![alt text](../../assets/algorithm/image-3.png)

1. Линейная модель предоставляет лучшую линию, которую можно провести через данные
2. У лучшей модели минимальные residuals (разница между фактическими и предсказанными значениями модели)
3. Самая простая линейная модель предполагает, что у нас есть
всего один предиктор: $y = \beta_{0} + \beta_{1}x$

#### 7.4.2 Множественная линейная регрессия
Используется при нескольких предикторах.
$$y = \beta_{0} + \beta_{1}x_{1} + ... + \beta_{r}x_{r} + \epsilon $$

пример: 

$$ЦенаДома = \beta_{0} + \beta_{1}*площадь + ... + \beta_{r}x_{r} + \epsilon $$ 


#### 7.4.3 Нелинейная регрессия (пока не смотрим)

**Нелинейная регрессия** — это метод моделирования зависимости между переменными, когда связь между зависимой $y$ и независимыми переменными $x$ не описывается линейной функцией.

Общая форма нелинейной регрессии:
$$y = f(x,b)+\epsilon$$
где:
- $f(x,b)$ - нелинейная функция параметров $\beta$
- $\epsilon$ - случайная ошибка

Например: 

**1. Полиномиальная регрессия**
$$y = \beta_{0} + \beta_{1}x_{1} + \beta_{2}x_{2}^2 + ... + \beta_{r}x_{r}^r + \epsilon $$
Используется, если зависимость имеет изгибы (например, парабола).

**2. Экспоненциальная регрессия**
$$y = \beta_{0}e^\beta_{1}x_{1}$$
Применяется, когда данные растут или убывают экспоненциально.

**3. Логарифмическая регрессия**
$$y = \beta_{0} + \beta_{1}ln(x_{1}) + \epsilon$$
Используется, если скорость роста уменьшается со временем.

Одним из главных преимуществ нелинейной регрессии является ее способность моделировать сложные нелинейные зависимости. Линейная регрессия ограничена линейными функциями, в то время как нелинейная регрессия может аппроксимировать более сложные формы зависимости, такие как параболы, экспоненциальные функции, логарифмические функции и другие. 

### 7.5 Метод наименьших квадратов

**Метод наименьших квадратов** — такой способ проведения регрессионной линии, чтобы сумма квадратов отклонений отдельных значений зависимой переменной от неё была минимальной.

`Алгоритм расчета`

Как уже упоминалось выше формула линейной регресии следующая:

$$y = \beta_{0} + \beta_{1}x_{1}$$

так как для модели мы не знаем реального значения $y$ переименуем его в $y_{pred}$ для ясности.

$$y_{pred} = \beta_{0} + \beta_{1}x_{1}$$

1. Для каждой точки на графике мы измеряем расстояние по оси $y$ до каждой проведённой линии

$$y_{res} = y_{i} - y_{pred}$$
где:
- $y_{res}$ - residual (расстояние до линии по оси y)
- $y_{i}$ - координата точки по оси (реальные значения)

Если они равны, модель предсказала идеально. Чем больше разница, тем хуже точность предсказания.

2. Эта разница может быть как положительной (модель занизила прогноз), так и отрицательной (завысила). Простая сумма таких отклонений не подходит, так как знаки компенсируют друг друга. Поэтому возводим разницу в квадрат.

$$y_{res} = (y_{i} - (\beta_{0} + \beta_{1}x_{1}))^2$$

3. Суммируя квадраты ошибок для всех наблюдений, получаем дисперсию остатков — показатель качества модели.

$$\sum_{i=1}^{n}{y_{res}} = \sum_{i=1}^{n}{(y_{i} - (\beta_{0} + \beta_{1}x_{1}))^2}$$

где:
- $n$ - это количество наблюдений в выборке (размер выборки).

**Минимизируемая функция**

**RSS** — расшифровывается как Residual Sum of Squares (сумма квадратов остатков регрессии) 

$$RSS = \sum_{i=1}^{n}{(y_{i} - (\beta_{0} + \beta_{1}x_{1}))^2}$$
