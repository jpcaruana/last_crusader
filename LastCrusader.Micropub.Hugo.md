# `LastCrusader.Micropub.Hugo`
[🔗](https://github.com/jpcaruana/last_crusader/blob/main/lib/last_crusader/micropub/hugo.ex#L1)

  Generates Hugo compatible data, file content, file name

# `path`

```elixir
@type path() :: String.t()
```

# `url`

```elixir
@type url() :: String.t()
```

# `convert_date_to_hugo_format`

```elixir
@spec convert_date_to_hugo_format(DateTime.t()) :: BitString.t()
```

Renders the post date into Hugo's expected date format ([ISO 8601](https://en.wikipedia.org/wiki/ISO_8601))

# `generate_front_matter`

```elixir
@spec generate_front_matter(
  DateTime.t(),
  LastCrusader.Micropub.PostTypeDiscovery.post_type(),
  map()
) ::
  LastCrusader.Utils.Toml.toml()
```

  Generates TOML formatted front-matter

# `generate_path`

```elixir
@spec generate_path(
  LastCrusader.Micropub.PostTypeDiscovery.post_type(),
  String.t(),
  DateTime.t()
) ::
  path()
```

  Generates the complete filename (with path) for a Hugo website

  Parameters:
  - type: can be `:note` `:post` `:bookmark` `in_reply_to`
  - name: for the file name
  - date

# `new`

```elixir
@spec new(LastCrusader.Micropub.PostTypeDiscovery.post_type(), DateTime.t(), map()) ::
  {path(), LastCrusader.Utils.Toml.toml(), path()}
```

  Create a new Hugo document

# `reverse_url`

```elixir
@spec reverse_url(url(), url()) :: String.t()
```

  Retrieves the local file path of a post from its published public URL

# `reverse_url_root`

```elixir
@spec reverse_url_root(url(), url()) :: String.t()
```

  Retrieves the local directory path of a post from its published public URL

---

*Consult [api-reference.md](api-reference.md) for complete listing*
