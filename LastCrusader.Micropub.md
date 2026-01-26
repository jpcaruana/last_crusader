# `LastCrusader.Micropub`
[🔗](https://github.com/jpcaruana/last_crusader/blob/main/lib/last_crusader/micropub/micropub.ex#L1)

Handles the _logic_ of micro-publishing.

See also:
- `LastCrusader.Micropub.Hugo`
- `LastCrusader.Micropub.Github`

# `add_keyword_to_post`
[🔗](https://github.com/jpcaruana/last_crusader/blob/main/lib/last_crusader/micropub/micropub.ex#L117)

Adds a keyword to a published post (most of the time, it will be the syndication link).

# `comment`
[🔗](https://github.com/jpcaruana/last_crusader/blob/main/lib/last_crusader/micropub/micropub.ex#L73)

Adds a comment to a post into Github repo.
It checks that the commented page exists in the Github repo (not on the real website).

To make it work in Hugo, you have to publish your content as
[Pages Bundles](https://gohugo.io/content-management/page-bundles/).
In your post template, include the following partial:

    {{ partial "comments.html" . }}

The Hugo partial ("comments.html") to display comments looks like this:

    {{ $comments := (.Resources.Match "comments/*yml") }}

    {{ range $comments }}
    <li>
      <i class="fas fa-reply"></i>
    {{ $comment := (.Content | transform.Unmarshal) }}
      <a href="{{ $comment.link }}">{{ $comment.author }}</a> le {{ substr $comment.date 0 10 }} :
      {{ $comment.comment | markdownify }}
    </li>
    {{ end }}

# `publish`
[🔗](https://github.com/jpcaruana/last_crusader/blob/main/lib/last_crusader/micropub/micropub.ex#L26)

Publishes as Hugo post to Github repo:

- checks auth code and scope
- discovers post type
- transforms it as a Hugo post
- commits to Github repo
- schedules sending webmentions if needed

---

*Consult [api-reference.md](api-reference.md) for complete listing*
