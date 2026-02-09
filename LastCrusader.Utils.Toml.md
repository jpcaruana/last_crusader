# `LastCrusader.Utils.Toml`
[🔗](https://github.com/jpcaruana/last_crusader/blob/main/lib/last_crusader/utils/toml.ex#L1)

  TOML strings manipulation

# `toml`

```elixir
@type toml() :: String.t()
```

# `extract_frontmatter_and_content`

```elixir
@spec extract_frontmatter_and_content(toml()) :: {toml(), String.t()}
```

  Extracts Frontmatter and Content from a Post

# `front_matter_to_map`

```elixir
@spec front_matter_to_map(toml()) :: map()
```

# `toml_map_to_string`

```elixir
@spec toml_map_to_string(map()) :: toml()
```

  Transforms a Map representation of TOML into its String counterpart with included separators

# `update_toml`

```elixir
@spec update_toml(toml(), map()) :: toml()
```

  Updates a TOML formatted front-matter

---

*Consult [api-reference.md](api-reference.md) for complete listing*
