defmodule LastCrusader.Webmentions.WebmentionsSenderTest do
  @moduledoc false
  use ExUnit.Case, async: true
  import Tesla.Mock

  alias LastCrusader.Webmentions.Sender

  test "check webmention is OK" do
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

  test "find twitter link in brid.gy response" do
    webmention_target = "https://brid.gy/publish/twitter"
    webmention_endpoint = "https://brid.gy/publish/webmention"

    reponse = [
      %Webmentions.Response{
        status: :ok,
        target: webmention_target,
        endpoint: webmention_endpoint,
        message: "sent",
        body: bridgy_success_response_body()
      }
    ]

    syndication_links = Sender.find_syndication_links(reponse)

    assert syndication_links == ["https://twitter.com/jpcaruana/status/1409912935766544386"]
  end

  test "parse multiple real webmentions reponse" do
    {:ok, reponse} = other_response()

    syndication_links = Sender.find_syndication_links(reponse)

    assert syndication_links == ["https://twitter.com/jpcaruana/status/1484200208590385158"]
  end

  test "multiple real webmentions reponse" do
    origin = "https://jp.caruana.fr/notes/2022/01/20/de-la-curiosite-nait-l/"

    targets = [
      "https://www.manning.com/books/data-oriented-programming",
      "https://jp.caruana.fr/notes/2021/12/06/sur-le-techblog-de-less-twittos/",
      "https://twitter.com/jpcaruana",
      "https://brid.gy/publish/twitter"
    ]

    bridgy_webmention_endpoint = "https://brid.gy/publish/webmention"
    bridgy_webmention_target = "https://brid.gy/publish/twitter"

    mock(fn
      # page target for webmentions: links to webmention enpoint (or none)
      %{method: :get, url: "https://www.manning.com/books/data-oriented-programming"} ->
        {:ok,
         %Tesla.Env{
           status: 200,
           body: "no webmention endpoint"
         }}

      %{
        method: :get,
        url: "https://jp.caruana.fr/notes/2021/12/06/sur-le-techblog-de-less-twittos/"
      } ->
        {:ok,
         %Tesla.Env{
           status: 200,
           body:
             "<html class=\"h-entry\"><a href=\"https://webmention.io/jp.caruana.fr/webmention\">Publish</a>",
           headers: [
             {"Link", "<https://webmention.io/jp.caruana.fr/webmention>; rel=\"webmention\""}
           ]
         }}

      %{method: :get, url: "https://twitter.com/jpcaruana"} ->
        {:ok,
         %Tesla.Env{
           status: 200,
           body: "no webmention endpoint"
         }}

      %{method: :get, url: "https://brid.gy/publish/twitter"} ->
        {:ok,
         %Tesla.Env{
           status: 200,
           body: "<html class=\"h-entry\"><a href=\"#{bridgy_webmention_target}\">Publish</a>",
           headers: [{"Link", "<#{bridgy_webmention_endpoint}>; rel=\"webmention\""}]
         }}

      # webmention enpoints
      %{method: :post, url: ^bridgy_webmention_endpoint} ->
        {:ok,
         %Tesla.Env{
           status: 201,
           body: bridgy_success_response_body2(),
           headers: [
             {"Status", "201 Created"},
             {"Content-Type", "application/json; charset=utf-8"}
           ]
         }}

      %{method: :post, url: "https://webmention.io/jp.caruana.fr/webmention"} ->
        {:ok,
         %Tesla.Env{
           status: 201,
           body:
             "{\"status\":\"queued\",\"summary\":\"Webmention was queued for processing\",\"location\":\"https://webmention.io/jp.caruana.fr/webmention/bArb4FMC07YG4DvFPgVx\",\"source\":\"https://jp.caruana.fr/notes/2022/01/20/de-la-curiosite-nait-l/\",\"target\":\"https://jp.caruana.fr/notes/2021/12/06/sur-le-techblog-de-less-twittos/\"}",
           headers: [
             {"Status", "201 Created"},
             {"Content-Type", "application/json; charset=utf-8"}
           ]
         }}
    end)

    {:ok, _pid, responses} = Sender.send_webmentions(origin, targets)

    {:ok, expected} = other_response()

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

  defp bridgy_success_response_body2() do
    "{\n  \"created_at\": \"Thu Jan 20 16:24:39 +0000 2022\",\n  \"id\": \"1484200208590385158\",\n  \"id_str\": \"1484200208590385158\",\n  \"text\": \"De la curiosit\\u00e9 nait l\\u2019excellence. Merci \\u00e0 @viebel d\\u2019\\u00eatre intervenu chez @DeepkiSAS pour nous parler de son livre D\\u2026 https://t.co/sk3vSoYSiA\",\n  \"truncated\": true,\n  \"entities\": {\n    \"hashtags\": [],\n    \"symbols\": [],\n    \"user_mentions\": [\n      {\n        \"screen_name\": \"viebel\",\n        \"name\": \"Yehonathan Sharvit\",\n        \"id\": 65952129,\n        \"id_str\": \"65952129\",\n        \"indices\": [\n          43,\n          50\n        ]\n      },\n      {\n        \"screen_name\": \"DeepkiSAS\",\n        \"name\": \"Deepki\",\n        \"id\": 2875090897,\n        \"id_str\": \"2875090897\",\n        \"indices\": [\n          73,\n          83\n        ]\n      }\n    ],\n    \"urls\": [\n      {\n        \"url\": \"https://t.co/sk3vSoYSiA\",\n        \"expanded_url\": \"https://twitter.com/i/web/status/1484200208590385158\",\n        \"display_url\": \"twitter.com/i/web/status/1\\u2026\",\n        \"indices\": [\n          117,\n          140\n        ]\n      }\n    ]\n  },\n  \"source\": \"<a href=\\\"https://brid.gy/\\\" rel=\\\"nofollow\\\">Bridgy</a>\",\n  \"in_reply_to_status_id\": null,\n  \"in_reply_to_status_id_str\": null,\n  \"in_reply_to_user_id\": null,\n  \"in_reply_to_user_id_str\": null,\n  \"in_reply_to_screen_name\": null,\n  \"user\": {\n    \"id\": 22757153,\n    \"id_str\": \"22757153\",\n    \"name\": \"JeanPhilippe Caruana\",\n    \"screen_name\": \"jpcaruana\",\n    \"location\": \"Paris, France\",\n    \"description\": \"CTO @ Deepki\",\n    \"url\": \"https://t.co/qfpgVZJDQ5\",\n    \"entities\": {\n      \"url\": {\n        \"urls\": [\n          {\n            \"url\": \"https://t.co/qfpgVZJDQ5\",\n            \"expanded_url\": \"https://jp.caruana.fr\",\n            \"display_url\": \"jp.caruana.fr\",\n            \"indices\": [\n              0,\n              23\n            ]\n          }\n        ]\n      },\n      \"description\": {\n        \"urls\": []\n      }\n    },\n    \"protected\": false,\n    \"followers_count\": 147,\n    \"friends_count\": 257,\n    \"listed_count\": 34,\n    \"created_at\": \"Wed Mar 04 10:59:32 +0000 2009\",\n    \"favourites_count\": 620,\n    \"utc_offset\": null,\n    \"time_zone\": null,\n    \"geo_enabled\": false,\n    \"verified\": false,\n    \"statuses_count\": 3260,\n    \"lang\": null,\n    \"contributors_enabled\": false,\n    \"is_translator\": false,\n    \"is_translation_enabled\": true,\n    \"profile_background_color\": \"EBEBEB\",\n    \"profile_background_image_url\": \"http://abs.twimg.com/images/themes/theme7/bg.gif\",\n    \"profile_background_image_url_https\": \"https://abs.twimg.com/images/themes/theme7/bg.gif\",\n    \"profile_background_tile\": false,\n    \"profile_image_url\": \"http://pbs.twimg.com/profile_images/1209467508/trans2010-112_normal.jpg\",\n    \"profile_image_url_https\": \"https://pbs.twimg.com/profile_images/1209467508/trans2010-112_normal.jpg\",\n    \"profile_banner_url\": \"https://pbs.twimg.com/profile_banners/22757153/1353327395\",\n    \"profile_link_color\": \"990000\",\n    \"profile_sidebar_border_color\": \"DFDFDF\",\n    \"profile_sidebar_fill_color\": \"F3F3F3\",\n    \"profile_text_color\": \"333333\",\n    \"profile_use_background_image\": true,\n    \"has_extended_profile\": false,\n    \"default_profile\": false,\n    \"default_profile_image\": false,\n    \"following\": false,\n    \"follow_request_sent\": false,\n    \"notifications\": false,\n    \"translator_type\": \"none\",\n    \"withheld_in_countries\": []\n  },\n  \"geo\": null,\n  \"coordinates\": null,\n  \"place\": null,\n  \"contributors\": null,\n  \"is_quote_status\": false,\n  \"retweet_count\": 0,\n  \"favorite_count\": 0,\n  \"favorited\": false,\n  \"retweeted\": false,\n  \"possibly_sensitive\": false,\n  \"lang\": \"fr\",\n  \"type\": \"post\",\n  \"url\": \"https://twitter.com/jpcaruana/status/1484200208590385158\"\n}"
  end

  defp other_response() do
    {:ok,
     [
       %Webmentions.Response{
         body: nil,
         endpoint: nil,
         http_status: nil,
         message: "no endpoint found",
         status: :no_endpoint,
         target: "https://www.manning.com/books/data-oriented-programming"
       },
       %Webmentions.Response{
         body:
           "{\"status\":\"queued\",\"summary\":\"Webmention was queued for processing\",\"location\":\"https://webmention.io/jp.caruana.fr/webmention/bArb4FMC07YG4DvFPgVx\",\"source\":\"https://jp.caruana.fr/notes/2022/01/20/de-la-curiosite-nait-l/\",\"target\":\"https://jp.caruana.fr/notes/2021/12/06/sur-le-techblog-de-less-twittos/\"}",
         endpoint: "https://webmention.io/jp.caruana.fr/webmention",
         http_status: nil,
         message: "sent",
         status: :ok,
         target: "https://jp.caruana.fr/notes/2021/12/06/sur-le-techblog-de-less-twittos/"
       },
       %Webmentions.Response{
         body: nil,
         endpoint: nil,
         http_status: nil,
         message: "no endpoint found",
         status: :no_endpoint,
         target: "https://twitter.com/jpcaruana"
       },
       %Webmentions.Response{
         body: bridgy_success_response_body2(),
         endpoint: "https://brid.gy/publish/webmention",
         http_status: nil,
         message: "sent",
         status: :ok,
         target: "https://brid.gy/publish/twitter"
       }
     ]}
  end
end
