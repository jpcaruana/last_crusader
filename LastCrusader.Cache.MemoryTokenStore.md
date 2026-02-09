# `LastCrusader.Cache.MemoryTokenStore`
[🔗](https://github.com/jpcaruana/last_crusader/blob/main/lib/last_crusader/cache/memory_token_store.ex#L1)

  Simple ETS-based cache.

  https://gist.github.com/raorao/a4bb34726af2e3fa071adfa504505e1d

# `cache_key`

```elixir
@type cache_key() :: any()
```

# `cache_value`

```elixir
@type cache_value() :: any()
```

# `t`

```elixir
@type t() :: %{ttl: integer(), invalidators: %{}}
```

# `cache`

```elixir
@spec cache(cache_key(), cache_value()) :: :ok
```

  Asynchronous call to cache a value at the provided key. Any key that can
  be used with ETS can be used, and will be evaluated using `==`.

# `child_spec`

Returns a specification to start this module under a supervisor.

See `Supervisor`.

# `clear`

```elixir
@spec clear() :: :ok
```

  Asynchronous clears all values in the cache.

# `init`

```elixir
@spec init(integer()) :: {:ok, t()}
```

# `read`

```elixir
@spec read(cache_key()) :: cache_value() | :not_found
```

  Sychronously reads the cache for the provided key. If no value is found,
  returns :not_found .

# `read_or_cache_default`

  Sychronously reads the cache for the provided key. If no value is found,
  invokes default_fn and caches the result. Note: in order to prevent congestion
  of the RequestCache process, default_fn is invoked in the context of the caller
  process.

# `start_link`

```elixir
@spec start_link(integer()) :: GenServer.on_start()
```

  Starts a RequestCache process linked to the current process. See
  `GenServer.start_link/2` for details.

  By default, every item in the cache lives for 6 hours.

---

*Consult [api-reference.md](api-reference.md) for complete listing*
