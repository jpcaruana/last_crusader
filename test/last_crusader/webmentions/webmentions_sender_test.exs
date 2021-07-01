defmodule LastCrusader.Webmentions.WebmentionsSenderTest do
  @moduledoc false
  use ExUnit.Case, async: true
  import Tesla.Mock

  alias LastCrusader.Webmentions.Sender

  test "find twitter link in brid.gy response" do
    # setup for webmentions is a bit tricky, I hope these variables will help
    webmention_target = "https://brid.gy/publish/twitter"
    webmention_endpoint = "https://brid.gy/publish/webmention"

    mock(fn
      # page target for webmention: links to webmention enpoint
      %{method: :get, url: ^webmention_target} ->
        {:ok,
         %Tesla.Env{
           status: 200,
           body: "<html class=\"h-entry\"><a href=\"#{webmention_target}\">Publish</a>",
           headers: [{"Link", "<#{webmention_endpoint}>; rel=\"webmention\""}]
         }}

      # webmention enpoint
      %{method: :post, url: ^webmention_endpoint} ->
        {:ok,
         %Tesla.Env{
           status: 201,
           body: bridgy_success_response_body(),
           headers: [
             {"Status", "201 Created"},
             {"Content-Type", "application/json; charset=utf-8"}
           ]
         }}
    end)

    {:ok, _pid, responses} =
      Sender.send_webmentions("https://some-origin.com", [webmention_target])

    expected = [
      %Webmentions.Response{
        status: :ok,
        target: webmention_target,
        endpoint: webmention_endpoint,
        message: "sent",
        body: bridgy_success_response_body()
      }
    ]

    assert responses == expected
  end

  defp bridgy_success_response_body() do
    """
    {
      "created_at": "Tue Jun 29 16:33:33 +0000 2021",
      "id": "1409912935766544386",
      "id_str": "1409912935766544386",
      "text": "Encore une fois un d\\u00e9p\\u00f4t de recommand\\u00e9 direct dans ma boite aux lettres alors que je suis pr\\u00e9sent \\u00e0 la maison\\u2026 pas\\u2026 https://t.co/oobSu6B0lr",
      "truncated": true,
      "entities": {
        "hashtags": [],
        "symbols": [],
        "user_mentions": [],
        "urls": [
          {
            "url": "https://t.co/oobSu6B0lr",
            "expanded_url": "https://twitter.com/i/web/status/1409912935766544386",
            "display_url": "twitter.com/i/web/status/1\\u2026",
            "indices": [
              116,
              139
            ]
          }
        ]
      },
      "source": "<a href=\"https: //brid.gy/\" rel=\"nofollow\">Bridgy</a>",
      "in_reply_to_status_id": null,
      "in_reply_to_status_id_str": null,
      "in_reply_to_user_id": null,
      "in_reply_to_user_id_str": null,
      "in_reply_to_screen_name": null,
      "user": {
        "id": 22757153,
        "id_str": "22757153",
        "name": "JeanPhilippe Caruana",
        "screen_name": "jpcaruana",
        "location": "Paris, France",
        "description": "CTO @ Deepki",
        "url": "https: //t.co/qfpgVZJDQ5",
        "entities": {
          "url": {
            "urls": [
              {
                "url": "https://t.co/qfpgVZJDQ5",
                "expanded_url": "https://jp.caruana.fr",
                "display_url": "jp.caruana.fr",
                "indices": [
                  0,
                  23
                ]
              }
            ]
          },
          "description": {
            "urls": []
          }
        },
        "protected": false,
        "followers_count": 146,
        "friends_count": 239,
        "listed_count": 34,
        "created_at": "Wed Mar 04 10:59:32 +0000 2009",
        "favourites_count": 547,
        "utc_offset": null,
        "time_zone": null,
        "geo_enabled": false,
        "verified": false,
        "statuses_count": 3227,
        "lang": null,
        "contributors_enabled": false,
        "is_translator": false,
        "is_translation_enabled": true,
        "profile_background_color": "EBEBEB",
        "profile_background_image_url": "http://abs.twimg.com/images/themes/theme7/bg.gif",
        "profile_background_image_url_https": "https://abs.twimg.com/images/themes/theme7/bg.gif",
        "profile_background_tile": false,
        "profile_image_url": "http://pbs.twimg.com/profile_images/1209467508/trans2010-112_normal.jpg",
        "profile_image_url_https": "https://pbs.twimg.com/profile_images/1209467508/trans2010-112_normal.jpg",
        "profile_banner_url": "https://pbs.twimg.com/profile_banners/22757153/1353327395",
        "profile_link_color": "990000",
        "profile_sidebar_border_color": "DFDFDF",
        "profile_sidebar_fill_color": "F3F3F3",
        "profile_text_color": "333333",
        "profile_use_background_image": true,
        "has_extended_profile": false,
        "default_profile": false,
        "default_profile_image": false,
        "following": false,
        "follow_request_sent": false,
        "notifications": false,
        "translator_type": "none",
        "withheld_in_countries": []
      },
      "geo": null,
      "coordinates": null,
      "place": null,
      "contributors": null,
      "is_quote_status": false,
      "retweet_count": 0,
      "favorite_count": 0,
      "favorited": false,
      "retweeted": false,
      "possibly_sensitive": false,
      "lang": "fr",
      "type": "post",
      "url": "https://twitter.com/jpcaruana/status/1409912935766544386"
    }
    """
  end
end
