# `LastCrusader.Micropub.GitHub`
[🔗](https://github.com/jpcaruana/last_crusader/blob/main/lib/last_crusader/micropub/github.ex#L1)

  Posts content to github

# `get_file`
[🔗](https://github.com/jpcaruana/last_crusader/blob/main/lib/last_crusader/micropub/github.ex#L89)

```elixir
@spec get_file(String.t()) :: {:ko, atom()} | {:ok, any()}
```

shortcut for `get_file/5`

Uses `Application.get_env/2` for default parameters.

# `get_file`
[🔗](https://github.com/jpcaruana/last_crusader/blob/main/lib/last_crusader/micropub/github.ex#L104)

```elixir
@spec get_file(map(), String.t(), String.t(), String.t(), String.t()) ::
  {:ko, atom()} | {:ok, any()}
```

Gets file content from GitHub

# `new_file`
[🔗](https://github.com/jpcaruana/last_crusader/blob/main/lib/last_crusader/micropub/github.ex#L13)

```elixir
@spec new_file(String.t(), String.t()) :: {:ko, atom()} | {:ok, any()}
```

shortcut for `new_file/6`

Uses `Application.get_env/2` for default parameters.

# `new_file`
[🔗](https://github.com/jpcaruana/last_crusader/blob/main/lib/last_crusader/micropub/github.ex#L29)

```elixir
@spec new_file(map(), String.t(), String.t(), String.t(), String.t(), String.t()) ::
  {:ko, atom()} | {:ok, any()}
```

Creates a commit with the filecontent to GitHub

# `update_file`
[🔗](https://github.com/jpcaruana/last_crusader/blob/main/lib/last_crusader/micropub/github.ex#L54)

```elixir
@spec update_file(String.t(), String.t()) :: {:ko, atom()} | {:ok, any()}
```

shortcut for `update_file/6`

Uses `Application.get_env/2` for default parameters.

# `update_file`
[🔗](https://github.com/jpcaruana/last_crusader/blob/main/lib/last_crusader/micropub/github.ex#L70)

```elixir
@spec update_file(map(), String.t(), String.t(), String.t(), String.t(), String.t()) ::
  {:ko, atom()} | {:ok, any()}
```

Updates a file on GitHub

---

*Consult [api-reference.md](api-reference.md) for complete listing*
