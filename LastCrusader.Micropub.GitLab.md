# `LastCrusader.Micropub.GitLab`
[🔗](https://github.com/jpcaruana/last_crusader/blob/main/lib/last_crusader/micropub/gitlab.ex#L1)

  Posts content to GitLab

# `get_file`

```elixir
@spec get_file(String.t(), String.t(), String.t(), String.t(), String.t()) ::
  {:ko, atom(), any()} | {:ok, String.t()}
```

Gets file content from GitLab

# `new_file`

```elixir
@spec new_file(String.t(), String.t(), String.t(), String.t(), String.t(), String.t()) ::
  {:ko, atom(), any()} | {:ok, :content_created}
```

Creates a commit with the filecontent to GitLab

# `update_file`

```elixir
@spec update_file(
  String.t(),
  String.t(),
  String.t(),
  String.t(),
  String.t(),
  String.t()
) ::
  {:ko, atom(), any()} | {:ok, :content_updated}
```

Updates a file on GitLab

---

*Consult [api-reference.md](api-reference.md) for complete listing*
