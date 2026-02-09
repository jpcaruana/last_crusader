# `LastCrusader.Micropub.MicropubHandler`
[🔗](https://github.com/jpcaruana/last_crusader/blob/main/lib/last_crusader/micropub/micropub_handler.ex#L1)

The Micropub protocol is used to create, update and delete posts on one's own domain using third-party clients.

Web apps and native apps (e.g., iPhone, Android) can use Micropub to post and edit articles, short notes, comments,
likes, photos, events or other kinds of posts on your own website.

cf full specification: https://micropub.spec.indieweb.org/

see also `LastCrusader.Micropub.PostTypeDiscovery`.

# `comment`

Handles comment posts from HTTP

Parameters:
- `author` (mandatory): Name of the comment author (just one field, so we allow aliases)
- `comment` (mandatory): Content of the comment. Can be in markdown format
- `original_page` (mandatory): URL of the page to comment to
- `link` (optional): Link to the personal page of the author

# `options_comment`

# `publish`

Handles micropublish demands from HTTP

See micropublish specification: https://micropub.spec.indieweb.org/#create

# `query`

Handles query requests

See micropub query specification: https://micropub.spec.indieweb.org/#querying

Note: we just reply to the `config`, `syndicate-to` and `category` requests

---

*Consult [api-reference.md](api-reference.md) for complete listing*
