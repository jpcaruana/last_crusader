# `LastCrusader.Utils.Randomizer`
[🔗](https://github.com/jpcaruana/last_crusader/blob/main/lib/last_crusader/utils/randomizer.ex#L1)

Random string generator module.

Imported from https://gist.github.com/ahmadshah/8d978bbc550128cca12dd917a09ddfb7

# `option`
[🔗](https://github.com/jpcaruana/last_crusader/blob/main/lib/last_crusader/utils/randomizer.ex#L7)

```elixir
@type option() :: :all | :alpha | :numeric | :upcase | :downcase
```

# `randomizer`
[🔗](https://github.com/jpcaruana/last_crusader/blob/main/lib/last_crusader/utils/randomizer.ex#L23)

```elixir
@spec randomizer(pos_integer(), option()) :: String.t()
```

Generate random string based on the given length. It is also possible to generate certain type of randomise string
using the options below:

* :all - generate alphanumeric random string
* :alpha - generate nom-numeric random string
* :numeric - generate numeric random string
* :upcase - generate upper case non-numeric random string
* :downcase - generate lower case non-numeric random string

## Example
    iex> Iurban.String.randomizer(20) //"Je5QaLj982f0Meb0ZBSK"

---

*Consult [api-reference.md](api-reference.md) for complete listing*
