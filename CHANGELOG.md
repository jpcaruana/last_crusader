# Changelog

## Unreleased yet
- drop support for Elixir < 1.11
- better handling of proxied HTTPS requests (see [Plug.RewriteOn](https://hexdocs.pm/plug/Plug.RewriteOn.html))
- CI: 
    - added doctor to check
    - added credo to check
- added as much Typespecs as possible
- update dependancies:
    - #6/#9: [bump ex_doc from 0.23.0 to 0.24.1](https://github.com/jpcaruana/last_crusader/pull/9)
    - #10: [bump webmentions from 0.5.2 to 0.5.3](https://github.com/jpcaruana/last_crusader/pull/10)
    - remove dependancy to timex: drop support to Elixir < 1.11

## 0.3.4 (2021/03/04)
- micropub/webmention: Handles my personal special case with my "indienews" Hugo shortcode

## 0.3.3 (2021/03/02)
- micropub: fix Github integration
- #5: dependancies: [bump timex from 3.6.3 to 3.6.4](https://github.com/jpcaruana/last_crusader/pull/5)

## 0.3.2 (2021/02/25)
- micropub: 
    - fix encoding issues from another weird long dash (see also release 0.2.2)
    - extract links from bookmark posts for webmention
- dependancies: remove unnecessary dependancy to Tentacat

## 0.3.1 (2021/02/24)
- added /status route for remote monitoring
- better logging configuration

## 0.3.0 (2021/02/24)
- micropub: send webmentions to mentionned URL in published content (waits for a publishing delay from Github/Netlify)
- #4: dependancies: [bump excoveralls from 0.13.4 to 0.14.0](https://github.com/jpcaruana/last_crusader/pull/4)

## 0.2.2 (2021/02/11)
- micropub: fix encoding issues from weird long dash
- update dependancies:
    - #3: [bump plug_cowboy from 2.3.0 to 2.4.1](https://github.com/jpcaruana/last_crusader/pull/3)
    - #1: [bump excoveralls from 0.12.3 to 0.13.4](https://github.com/jpcaruana/last_crusader/pull/1)

## 0.2.1 (2021/01/28)
- micropub: fix encoding issues from emojis

## 0.2.0 (2020/11/18)
- First "production" release

## 0.1.0
- Draft 
