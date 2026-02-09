# `LastCrusader.Webmentions.Sender`
[🔗](https://github.com/jpcaruana/last_crusader/blob/main/lib/last_crusader/webmentions/webmentions_sender.ex#L1)

Schedules webmentions to be send

It first checks of the origin exists before sending webmentions. It will retry this check every minute until it reaches the configured number of tries.

# `url`

```elixir
@type url() :: String.t()
```

# `find_syndication_links`

  Finds syndication links (from bridy to twitter) in a list of Webmentions responses

# `schedule_webmentions`

```elixir
@spec schedule_webmentions(url(), pos_integer()) :: {:ok, non_neg_integer()}
```

  Schedules webmentions to be send with 1 minute wait between every try (default is 15 times)

# `send_webmentions`

  Sends Webmentions to every link

---

*Consult [api-reference.md](api-reference.md) for complete listing*
