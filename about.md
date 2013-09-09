---
layout: single
---

# Об Elixir

Elixir – функциональный язык с поддержкой мета-программирования, построенный поверх виртуальной машины Erlang, известной так-же как BeamVM. Это динамический язык с гибким синтаксисом и поддержкой макросов, который дополняет возможности Erlang для создания многопоточных, распределённых и отказоустойчивых систем с возможностью "горячего" обновления кода.

Elixir поддерживает [функции первого класса](http://ru.wikipedia.org/wiki/%D0%A4%D1%83%D0%BD%D0%BA%D1%86%D0%B8%D0%B8_%D0%BF%D0%B5%D1%80%D0%B2%D0%BE%D0%B3%D0%BE_%D0%BA%D0%BB%D0%B0%D1%81%D1%81%D0%B0) (first-class functions), [сопоставление с образцом](http://ru.wikipedia.org/wiki/%D0%A1%D0%BE%D0%BF%D0%BE%D1%81%D1%82%D0%B0%D0%B2%D0%BB%D0%B5%D0%BD%D0%B8%D0%B5_%D1%81_%D0%BE%D0%B1%D1%80%D0%B0%D0%B7%D1%86%D0%BE%D0%BC) (pattern matching), полиморфизм через протоколы (как у Clojure), алиасы и ассоциативные структуры данных (известные в других языках как словари и хеши).

Наконец, у Elixir и Erlang один и тот же байткод и типы данных. Это означает, что вы можете вызывать код на Erlang из Elixir (и наоборот) без какой бы то ни было конверсии и потери в скорости. Это позволяет разработчику комбинировать выразительность Elixir с мощью и производительностью Erlang.


---

# Основные моменты

---

## Все является выражением

```elixir
defmodule Hello do
  IO.puts "Defining the function world"

  def world do
    IO.puts "Hello World"
  end

  IO.puts "Function world defined"
end

Hello.world
```

Программа выше выведет на экран следующее:

```
Defining the function world
Function world defined
Hello World
```

Это дает возможность определять модули с использованием произвольных выражений, программируемых разработчиком, это основа метапрограммирования. Примерно тоже самое предлагает Джо Армстронг в его проекте - [erl2](https://github.com/joearms/erl2).

---

## Метапрограммирование и DSL

Используя выражения и метапрограммирование, разработчики могут создавать [DSL](http://ru.wikipedia.org/wiki/%D0%9F%D1%80%D0%B5%D0%B4%D0%BC%D0%B5%D1%82%D0%BD%D0%BE-%D0%BE%D1%80%D0%B8%D0%B5%D0%BD%D1%82%D0%B8%D1%80%D0%BE%D0%B2%D0%B0%D0%BD%D0%BD%D1%8B%D0%B9_%D1%8F%D0%B7%D1%8B%D0%BA_%D0%BF%D1%80%D0%BE%D0%B3%D1%80%D0%B0%D0%BC%D0%BC%D0%B8%D1%80%D0%BE%D0%B2%D0%B0%D0%BD%D0%B8%D1%8F):

```elixir
defmodule MathTest do
  use ExUnit.Case

  test "can add two numbers" do
    assert 1 + 1 == 2
  end
end
```

DSL помогает разработчику создавать абстракции для предметной области, например для избавления от часто повторяющегося кода.

---

## Полиморфизм через протоколы

Протоколы позволяют разработчикам обеспечивать специфичную для определенного типа функциональность, например модуль `Enum`, который обычно используется для перебора коллекций:

```elixir
Enum.map([1,2,3], fn(x) -> x * 2 end) #=> [2, 4, 6]
```

Так как модуль `Enum` построен на протоколах, он не ограничен типами данных, которые определены в Elixir. Разработчик может использовать `Enum` со своими коллекциями, если реализует их поддержку в протоколе `Enumerable`. Например, программист может пользоваться всеми удобствами модуля `Enum` для легкой манипуляции с файлами:

```elixir
file  = File.stream!("README.md")
lines = Enum.map(file, fn(line) -> Regex.replace(%r/"/, line, "'") end)
File.write("README.md", lines)
```

---

## Документация как объект первого класса

Документация поддерживается на уровне языка в форме докстрингов (docstrings). Markdown является стандартом де-факто при выборе языка разметки в документации:

```elixir
defmodule MyModule do
  @moduledoc """
  Documentation for my module. With **formatting**.
  """

  @doc "Hello"
  def world do
    "World"
  end
end
```

Различные инструменты имеют доступ к вашей документации. IEx (интерактивная оболочка Elixir) может вывести документацию любого модуля или функции с помощью функции `h`:

```
iex> h MyModule
# MyModule

Documentation for my module. With **formatting**.
```

Еще есть генератор документации &mdash; [ExDoc](https://github.com/elixir-lang/ex_doc), который может сгенерировать статичный сайт используя докстринги из исходного кода.

---

## Cопоставление с образцом

Cопоставление с образцом (pattern matching) позволяет разработчику легко деструктурировать данные и получить доступ к их содержимому:

```elixir
{ User, name, age } = User.get("John Doe")
```

Вместе с [охраняющими выражениями](http://ru.wikipedia.org/wiki/%D0%9E%D1%85%D1%80%D0%B0%D0%BD%D0%B0_%28%D0%BF%D1%80%D0%BE%D0%B3%D1%80%D0%B0%D0%BC%D0%BC%D0%B8%D1%80%D0%BE%D0%B2%D0%B0%D0%BD%D0%B8%D0%B5%29) (guards), сопоставление с образцом позволяет нам легко выразить свои намерения:

```elixir
def serve_drinks({ User, name, age }) when age < 21 do
  raise "No way #{name}!"
end

def serve_drinks({ User, name, age }) do
  # Код, который подает напитки!
end

serve_drinks User.get("John")
#=> Вызовет "No way John!" если возраст Джона меньше 21 года
```

---

## Erlang all the way down

После всего этого, Elixir остается Erlang'ом. Программист на Elixir может вызывать любые функции Erlang без потерей в производительности:

```elixir
:application.start(:crypto)
:crypto.md5("Using crypto from Erlang OTP")
#=> <<192,223,75,115,...>>
```

Так как Elixir компилируется в тотже байт-код, он полностью совместим с [OTP](http://learnyousomeerlang.com/what-is-otp) и беспрепятственно работает со всеми проверенными в бою методами, которыми Erlang/OTP известен. Типы, спецификации, поведения и аттрибуты моделей Erlang'а полностью поддерживаются.

Чтобы установить Elixir или узнать о нем больше &mdash; прочтите [руководство для начинающих](/getting_started/index.html). Также есть [онлайн документация](http://elixir-lang.org/docs) и [интенсивный курс для Erlang программистов](http://elixir-lang.org/crash-course.html).
