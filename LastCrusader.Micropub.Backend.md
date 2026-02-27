# `LastCrusader.Micropub.Backend`
[🔗](https://github.com/jpcaruana/last_crusader/blob/main/lib/last_crusader/micropub/backend.ex#L1)

Behaviour for git backends used to persist Hugo post files.

# `get_file`

```elixir
@callback get_file(filename :: String.t()) :: {:ok, String.t()} | {:ko, atom(), any()}
```

# `new_file`

```elixir
@callback new_file(filename :: String.t(), content :: String.t()) ::
  {:ok, :content_created} | {:ko, atom(), any()}
```

# `update_file`

```elixir
@callback update_file(filename :: String.t(), content :: String.t()) ::
  {:ok, :content_updated} | {:ko, atom(), any()}
```

---

*Consult [api-reference.md](api-reference.md) for complete listing*
