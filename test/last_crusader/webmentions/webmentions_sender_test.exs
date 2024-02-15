defmodule LastCrusader.Webmentions.WebmentionsSenderTest do
  @moduledoc false
  use ExUnit.Case, async: true
  import Tesla.Mock

  alias LastCrusader.Webmentions.Sender

  describe "send_webmentions/3" do
    test "check twitter webmention is OK" do
      # setup for webmentions is a bit tricky, I hope these variables will help
      source = "https://some-origin.com"
      webmention_target = "https://brid.gy/publish/twitter"
      webmention_endpoint = "https://brid.gy/publish/webmention"

      mock(fn
        # source page for webmention
        %{method: :get, url: ^source} ->
          {:ok,
           %Tesla.Env{
             status: 200,
             body: "<html class=\"h-entry\"><a href=\"#{webmention_target}\"></a>"
           }}

        # page target for webmention: links to webmention endpoint
        %{method: :get, url: ^webmention_target} ->
          {:ok,
           %Tesla.Env{
             status: 200,
             body: "<html class=\"h-entry\"><a href=\"#{webmention_target}\">Publish</a>",
             headers: [{"Link", "<#{webmention_endpoint}>; rel=\"webmention\""}]
           }}

        # webmention endpoint
        %{method: :post, url: ^webmention_endpoint} ->
          {:ok,
           %Tesla.Env{
             status: 201,
             body:
               bridgy_success_response_body(
                 "https://twitter.com/jpcaruana/status/1409912935766544386"
               ),
             headers: [
               {"Status", "201 Created"},
               {"Content-Type", "application/json; charset=utf-8"}
             ]
           }}
      end)

      {:ok, _pid, responses} = Sender.send_webmentions(source)

      expected = [
        %Webmentions.Response{
          status: :ok,
          target: webmention_target,
          endpoint: webmention_endpoint,
          message: "sent",
          body:
            bridgy_success_response_body(
              "https://twitter.com/jpcaruana/status/1409912935766544386"
            )
        }
      ]

      assert responses == expected
    end

    test "check several webmentions are OK" do
      # setup for webmentions is a bit tricky, I hope these variables will help
      source = "https://some-origin.com"

      webmention_target_1 = "https://target1.com/"
      webmention_endpoint_1 = "https://endpoint1.com/"

      webmention_target_2 = "https://target2.com/"
      webmention_endpoint_2 = "https://endpoint2.com/"

      mock(fn
        # setup for webmentions is a bit tricky, I hope these variables will help
        %{method: :get, url: ^source} ->
          {:ok,
           %Tesla.Env{
             status: 200,
             body:
               "<html class=\"h-entry\"><a href=\"#{webmention_target_1}\"></a><a href=\"#{webmention_target_2}\"></a>"
           }}

        # page target for webmention: links to webmention endpoint
        %{method: :get, url: ^webmention_target_1} ->
          {:ok,
           %Tesla.Env{
             status: 200,
             body: "<html class=\"h-entry\"><a href=\"#{webmention_target_1}\">Publish</a>",
             headers: [{"Link", "<#{webmention_endpoint_1}>; rel=\"webmention\""}]
           }}

        %{method: :get, url: ^webmention_target_2} ->
          {:ok,
           %Tesla.Env{
             status: 200,
             body: "<html class=\"h-entry\"><a href=\"#{webmention_target_2}\">Publish</a>",
             headers: [{"Link", "<#{webmention_endpoint_2}>; rel=\"webmention\""}]
           }}

        # webmention endpoint
        %{method: :post, url: ^webmention_endpoint_1} ->
          {:ok,
           %Tesla.Env{
             status: 201,
             body:
               bridgy_success_response_body(
                 "https://twitter.com/jpcaruana/status/1409912935766544386"
               ),
             headers: [
               {"Status", "201 Created"},
               {"Content-Type", "application/json; charset=utf-8"}
             ]
           }}

        %{method: :post, url: ^webmention_endpoint_2} ->
          {:ok,
           %Tesla.Env{
             status: 201,
             body:
               bridgy_success_response_body(
                 "https://indieweb.social/@tchambers/109309801099794571"
               ),
             headers: [
               {"Status", "201 Created"},
               {"Content-Type", "application/json; charset=utf-8"}
             ]
           }}
      end)

      {:ok, _pid, responses} = Sender.send_webmentions(source)

      expected = [
        %Webmentions.Response{
          status: :ok,
          target: webmention_target_1,
          endpoint: webmention_endpoint_1,
          message: "sent",
          body:
            bridgy_success_response_body(
              "https://twitter.com/jpcaruana/status/1409912935766544386"
            )
        },
        %Webmentions.Response{
          status: :ok,
          target: webmention_target_2,
          endpoint: webmention_endpoint_2,
          message: "sent",
          body:
            bridgy_success_response_body("https://indieweb.social/@tchambers/109309801099794571")
        }
      ]

      assert responses == expected
    end
  end

  describe "find_syndication_links/2" do
    test "find twitter, mastodon and bluesky links in brid.gy response" do
      webmention_target_twitter = "https://brid.gy/publish/twitter"
      webmention_target_mastodon = "https://brid.gy/publish/mastodon"
      webmention_target_bluesky = "https://brid.gy/publish/bluesky"
      webmention_endpoint = "https://brid.gy/publish/webmention"

      reponse = [
        %Webmentions.Response{
          status: :ok,
          target: webmention_target_twitter,
          endpoint: webmention_endpoint,
          message: "sent",
          body:
            bridgy_success_response_body(
              "https://twitter.com/jpcaruana/status/1409912935766544386"
            )
        },
        %Webmentions.Response{
          status: :ok,
          target: webmention_target_mastodon,
          endpoint: webmention_endpoint,
          message: "sent",
          body:
            bridgy_success_response_body("https://indieweb.social/@tchambers/109309801099794571")
        },
        %Webmentions.Response{
          status: :ok,
          target: webmention_target_bluesky,
          endpoint: webmention_endpoint,
          message: "sent",
          body:
            bridgy_success_response_body(
              "https://bsky.app/profile/jpcaruana.bsky.social/post/3klh6khcztl2g"
            )
        }
      ]

      syndication_links = Sender.find_syndication_links(reponse)

      assert syndication_links == [
               {"https://twitter.com/jpcaruana/status/1409912935766544386", "twitter"},
               {"https://indieweb.social/@tchambers/109309801099794571", "mastodon"},
               {"https://bsky.app/profile/jpcaruana.bsky.social/post/3klh6khcztl2g", "bluesky"}
             ]
    end
  end

  defp bridgy_success_response_body(syndication_link) do
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
            "url": "#{syndication_link}",
            "expanded_url": "#{syndication_link}",
            "display_url": "#{syndication_link}",
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
      "url": "#{syndication_link}"
    }
    """
  end
end
