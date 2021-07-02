searchNodes=[{"doc":"IndieAuth authorization endpoint An authorization endpoint is an HTTP endpoint that micropub and IndieAuth clients can use to identify a user or obtain an authorization code (which is then later exchanged for an access token) to be able to post to their website. see https://indieweb.org/authorization-endpoint","ref":"LastCrusader.Auth.AuthHandler.html","title":"LastCrusader.Auth.AuthHandler","type":"module"},{"doc":"authorization-endpoint. To start the sign-in flow, the user's browser will be redirected to their authorization endpoint, with additional parameters in the query string. Parameters: me: Full URI of the user's homepage client_id: Full URI of the application's/website's home page. Used to identify the application. An authorization endpoint may show the application's icon and title to the user during the auth process. redirect_uri: Full URI to redirect back to when the login process is finished state: A random value the app makes up, unique per request. The authorization server just passes it back to the app. Optional. Auth endpoints MUST support them, though. response_type: id (identification only) or code (identification + authorization) Optional. Defaults to id. scope: Not used and omitted in identification mode (response_type=id) For authorization, the scope contains a space-separated list of scopes that the web application requests permission for, e.g. &quot;create&quot;. Multiple values are supported, e.g. create delete","ref":"LastCrusader.Auth.AuthHandler.html#auth_endpoint/1","title":"LastCrusader.Auth.AuthHandler.auth_endpoint/1","type":"function"},{"doc":"Auth code verification For the sign-in flow, the web application will query the authorization endpoint to verify the auth code it received. The client makes a POST request to the authorization server with the following values: POST https :/ / auth . example . org / auth Content - type : application / x - www - form - urlencoded code = xxxxxxxx &amp; redirect_uri = https :/ / webapp . example . org / auth / callback &amp; client_id = https :/ / webapp . example . org / After the authorization server verifies that redirect_uri, client_id match the code given, the response will include the &quot;me&quot; value indicating the URL of the user who signed in. The response content-type should be either application/x-www-form-urlencoded or application/json depending on the value of the HTTP Accept header. Parameters: me: Full URI of the user's homepage This may be different from the me parameter that the user originally entered, but MUST be on the same domain.","ref":"LastCrusader.Auth.AuthHandler.html#code_verification/1","title":"LastCrusader.Auth.AuthHandler.code_verification/1","type":"function"},{"doc":"Simple ETS-based cache. https://gist.github.com/raorao/a4bb34726af2e3fa071adfa504505e1d","ref":"LastCrusader.Cache.MemoryTokenStore.html","title":"LastCrusader.Cache.MemoryTokenStore","type":"module"},{"doc":"Asynchronous call to cache a value at the provided key. Any key that can be used with ETS can be used, and will be evaluated using == .","ref":"LastCrusader.Cache.MemoryTokenStore.html#cache/2","title":"LastCrusader.Cache.MemoryTokenStore.cache/2","type":"function"},{"doc":"Returns a specification to start this module under a supervisor. See Supervisor .","ref":"LastCrusader.Cache.MemoryTokenStore.html#child_spec/1","title":"LastCrusader.Cache.MemoryTokenStore.child_spec/1","type":"function"},{"doc":"Asynchronous clears all values in the cache.","ref":"LastCrusader.Cache.MemoryTokenStore.html#clear/0","title":"LastCrusader.Cache.MemoryTokenStore.clear/0","type":"function"},{"doc":"Callback implementation for GenServer.init/1 .","ref":"LastCrusader.Cache.MemoryTokenStore.html#init/1","title":"LastCrusader.Cache.MemoryTokenStore.init/1","type":"function"},{"doc":"Sychronously reads the cache for the provided key. If no value is found, returns :not_found .","ref":"LastCrusader.Cache.MemoryTokenStore.html#read/1","title":"LastCrusader.Cache.MemoryTokenStore.read/1","type":"function"},{"doc":"Sychronously reads the cache for the provided key. If no value is found, invokes default_fn and caches the result. Note: in order to prevent congestion of the RequestCache process, default_fn is invoked in the context of the caller process.","ref":"LastCrusader.Cache.MemoryTokenStore.html#read_or_cache_default/2","title":"LastCrusader.Cache.MemoryTokenStore.read_or_cache_default/2","type":"function"},{"doc":"Starts a RequestCache process linked to the current process. See GenServer.start_link/2 for details. By default, every item in the cache lives for 6 hours.","ref":"LastCrusader.Cache.MemoryTokenStore.html#start_link/1","title":"LastCrusader.Cache.MemoryTokenStore.start_link/1","type":"function"},{"doc":"","ref":"LastCrusader.Cache.MemoryTokenStore.html#t:cache_key/0","title":"LastCrusader.Cache.MemoryTokenStore.cache_key/0","type":"type"},{"doc":"","ref":"LastCrusader.Cache.MemoryTokenStore.html#t:cache_value/0","title":"LastCrusader.Cache.MemoryTokenStore.cache_value/0","type":"type"},{"doc":"","ref":"LastCrusader.Cache.MemoryTokenStore.html#t:t/0","title":"LastCrusader.Cache.MemoryTokenStore.t/0","type":"type"},{"doc":"Handles the logic of micro-publishing. Does not worry about HTTP","ref":"LastCrusader.Micropub.html","title":"LastCrusader.Micropub","type":"module"},{"doc":"Publishes as Hugo post to Github repo: checks auth code and scope discovers post type transforms it as a Hugo post commits to Github repo schedules sending webmentions if needed","ref":"LastCrusader.Micropub.html#publish/2","title":"LastCrusader.Micropub.publish/2","type":"function"},{"doc":"Posts content to github","ref":"LastCrusader.Micropub.GitHub.html","title":"LastCrusader.Micropub.GitHub","type":"module"},{"doc":"Creates a commit with the filecontent to GitHub","ref":"LastCrusader.Micropub.GitHub.html#new_file/6","title":"LastCrusader.Micropub.GitHub.new_file/6","type":"function"},{"doc":"Updates a file on GitHub","ref":"LastCrusader.Micropub.GitHub.html#update_file/6","title":"LastCrusader.Micropub.GitHub.update_file/6","type":"function"},{"doc":"Generates Hugo compatible data, file content, file name","ref":"LastCrusader.Micropub.Hugo.html","title":"LastCrusader.Micropub.Hugo","type":"module"},{"doc":"Extracts links from a Hugo post Parameters: toml_content: the file's content (with TOML frontmatter) Some help from http://scottradcliff.com/parsing-hyperlinks-in-markdown.html Yes, using a Regex is weak... Handles my personal special case with my &quot;indienews&quot; shortcode","ref":"LastCrusader.Micropub.Hugo.html#extract_links/1","title":"LastCrusader.Micropub.Hugo.extract_links/1","type":"function"},{"doc":"Generates TOML formatted fron-matter","ref":"LastCrusader.Micropub.Hugo.html#generate_front_matter/3","title":"LastCrusader.Micropub.Hugo.generate_front_matter/3","type":"function"},{"doc":"Generates the complete filename (with path) for a Hugo website Parameters: type: can be :note :post :bookmark in_reply_to name: for the file name date","ref":"LastCrusader.Micropub.Hugo.html#generate_path/3","title":"LastCrusader.Micropub.Hugo.generate_path/3","type":"function"},{"doc":"Create a new Hugo document","ref":"LastCrusader.Micropub.Hugo.html#new/3","title":"LastCrusader.Micropub.Hugo.new/3","type":"function"},{"doc":"","ref":"LastCrusader.Micropub.Hugo.html#t:path/0","title":"LastCrusader.Micropub.Hugo.path/0","type":"type"},{"doc":"","ref":"LastCrusader.Micropub.Hugo.html#t:toml/0","title":"LastCrusader.Micropub.Hugo.toml/0","type":"type"},{"doc":"","ref":"LastCrusader.Micropub.Hugo.html#t:url/0","title":"LastCrusader.Micropub.Hugo.url/0","type":"type"},{"doc":"The Micropub protocol is used to create, update and delete posts on one's own domain using third-party clients. Web apps and native apps (e.g., iPhone, Android) can use Micropub to post and edit articles, short notes, comments, likes, photos, events or other kinds of posts on your own website. cf full specification: https://micropub.spec.indieweb.org/ see also LastCrusader.Micropub.PostTypeDiscovery .","ref":"LastCrusader.Micropub.MicropubHandler.html","title":"LastCrusader.Micropub.MicropubHandler","type":"module"},{"doc":"Handles micropublish demands from HTTP","ref":"LastCrusader.Micropub.MicropubHandler.html#publish/1","title":"LastCrusader.Micropub.MicropubHandler.publish/1","type":"function"},{"doc":"Handles query requests Note: we just reply to the &quot;config&quot; request","ref":"LastCrusader.Micropub.MicropubHandler.html#query/1","title":"LastCrusader.Micropub.MicropubHandler.query/1","type":"function"},{"doc":"Indieweb Post Type discovery implementation see https://indieweb.org/post-type-discovery Post Type Discovery specifies an algorithm for consuming code to determine the type of a post by its content properties and their values rather than an explicit “post type” property, thus better matched to modern post creation UIs that allow combining text, media, etc in a variety of ways without burdening users with any notion of what kind of post they are creating. The Post Type Discovery algorithm (&quot;the algorithm&quot;) discovers the type of a post given a data structure representing a post with a flat set of properties (e.g. Activity Streams (1.0 or 2.0) JSON, or JSON output from parsing [microformats2]), each with one or more values, by following these steps until reaching the first &quot;it is a(n) ... post&quot; statement at which point the &quot;...&quot; is the discovered post type. 1 . If the post has an &quot;rsvp&quot; property with a valid value , Then it is an RSVP post . 2 . If the post has an &quot;in-reply-to&quot; property with a valid URL , Then it is a reply post . 3 . If the post has a &quot;repost-of&quot; property with a valid URL , Then it is a repost ( AKA &quot;share&quot; ) post . 4 . If the post has a &quot;like-of&quot; property with a valid URL , Then it is a like ( AKA &quot;favorite&quot; ) post . 5 . If the post has a &quot;video&quot; property with a valid URL , Then it is a video post . 6 . If the post has a &quot;photo&quot; property with a valid URL , Then it is a photo post . 7 . If the post has a &quot;content&quot; property with a non - empty value , Then use its first non - empty value as the content 8 . Else if the post has a &quot;summary&quot; property with a non - empty value , Then use its first non - empty value as the content 9 . Else it is a note post . 10 . If the post has no &quot;name&quot; property or has a &quot;name&quot; property with an empty string value ( or no value ) Then it is a note post . 11 . Take the first non - empty value of the &quot;name&quot; property 12 . Trim all leading / trailing whitespace 13 . Collapse all sequences of internal whitespace to a single space ( 0x20 ) character each 14 . Do the same with the content 15 . If this processed &quot;name&quot; property value is NOT a prefix of the processed content , Then it is an article post . 16 . It is a note post . Quoted property names in the algorithm are defined in h-entry.","ref":"LastCrusader.Micropub.PostTypeDiscovery.html","title":"LastCrusader.Micropub.PostTypeDiscovery","type":"module"},{"doc":"Discover the post type according to the official algorithm. Can be: :note :article :bookmark :rvsp :in_reply_to :like_of :video :photo","ref":"LastCrusader.Micropub.PostTypeDiscovery.html#discover/1","title":"LastCrusader.Micropub.PostTypeDiscovery.discover/1","type":"function"},{"doc":"Determine whether the name property represents an explicit title. see one python implementation because the official algo explanation is not clear at all (to me). I took documentation (and unit tests) from it: Typically when parsing an h-entry, we check whether p-name == e-content (value) . If they are non-equal, then p-name likely represents a title. However, occasionally we come across an h-entry that does not provide an explicit p-name. In this case, the name is automatically generated by converting the entire h-entry content to plain text. This definitely does not represent a title, and looks very bad when displayed as such. To handle this case, we broaden the equality check to see if content is a subset of name. We also strip out non-alphanumeric characters just to make the check a little more forgiving.","ref":"LastCrusader.Micropub.PostTypeDiscovery.html#is_name_a_title?/2","title":"LastCrusader.Micropub.PostTypeDiscovery.is_name_a_title?/2","type":"function"},{"doc":"","ref":"LastCrusader.Micropub.PostTypeDiscovery.html#t:post_type/0","title":"LastCrusader.Micropub.PostTypeDiscovery.post_type/0","type":"type"},{"doc":"Utils for easy HTTP manipulation","ref":"LastCrusader.Utils.Http.html","title":"LastCrusader.Utils.Http","type":"module"},{"doc":"Transforms a list of tuples into a Map","ref":"LastCrusader.Utils.Http.html#as_map/1","title":"LastCrusader.Utils.Http.as_map/1","type":"function"},{"doc":"Add key-value header(s) to HTTP response","ref":"LastCrusader.Utils.Http.html#put_headers/2","title":"LastCrusader.Utils.Http.put_headers/2","type":"function"},{"doc":"Indie Auth Identifier Validator see spec https://indieauth.spec.indieweb.org/#user-profile-url User Profile URL Users are identified by a [URL]. Profile URLs MUST have either an https or http scheme, MUST contain a path component (/ is a valid path), MUST NOT contain single-dot or double-dot path segments, MAY contain a query string component, MUST NOT contain a fragment component, MUST NOT contain a username or password component, and MUST NOT contain a port. Additionally, hostnames MUST be domain names and MUST NOT be ipv4 or ipv6 addresses. Some examples of valid profile URLs are: https :/ / example . com / https :/ / example . com / username https :/ / example . com / users? id = 100 Some examples of invalid profile URLs are: example . com - missing scheme mailto :user@example . com - invalid scheme https :/ / example . com / foo / .. / bar - contains a double - dot path segment https :/ / example . com / #me - contains a fragment https :/ / user :pass@example . com / - contains a username and password https :/ / example . com : 8443 / - contains a port https :/ / 172.28 . 92.51 / - host is an IP address","ref":"LastCrusader.Utils.IdentifierValidator.html","title":"LastCrusader.Utils.IdentifierValidator","type":"module"},{"doc":"Validates a user profile URL according to the IndieAuth spec","ref":"LastCrusader.Utils.IdentifierValidator.html#validate_user_profile_url/1","title":"LastCrusader.Utils.IdentifierValidator.validate_user_profile_url/1","type":"function"},{"doc":"Validates a user profile URL according to the IndieAuth spec Useful in a validation pipe, but really relies on validate_user_profile_url/1","ref":"LastCrusader.Utils.IdentifierValidator.html#validate_user_profile_url/2","title":"LastCrusader.Utils.IdentifierValidator.validate_user_profile_url/2","type":"function"},{"doc":"","ref":"LastCrusader.Utils.IdentifierValidator.html#t:url/0","title":"LastCrusader.Utils.IdentifierValidator.url/0","type":"type"},{"doc":"Random string generator module. Imported from https://gist.github.com/ahmadshah/8d978bbc550128cca12dd917a09ddfb7","ref":"LastCrusader.Utils.Randomizer.html","title":"LastCrusader.Utils.Randomizer","type":"module"},{"doc":"Generate random string based on the given length. It is also possible to generate certain type of randomise string using the options below: :all - generate alphanumeric random string :alpha - generate nom-numeric random string :numeric - generate numeric random string :upcase - generate upper case non-numeric random string :downcase - generate lower case non-numeric random string Example iex&gt; Iurban.String . randomizer ( 20 ) / / &quot;Je5QaLj982f0Meb0ZBSK&quot;","ref":"LastCrusader.Utils.Randomizer.html#randomizer/2","title":"LastCrusader.Utils.Randomizer.randomizer/2","type":"function"},{"doc":"","ref":"LastCrusader.Utils.Randomizer.html#t:option/0","title":"LastCrusader.Utils.Randomizer.option/0","type":"type"},{"doc":"Schedules webmentions to be send It first checks of the origin exists before sending webmentions. It will retry this check every minute until it reaches the configured number of tries.","ref":"LastCrusader.Webmentions.Sender.html","title":"LastCrusader.Webmentions.Sender","type":"module"},{"doc":"Schedules webmentions to be send with 1 minute wait between every try (default is 15 times)","ref":"LastCrusader.Webmentions.Sender.html#schedule_webmentions/3","title":"LastCrusader.Webmentions.Sender.schedule_webmentions/3","type":"function"},{"doc":"","ref":"LastCrusader.Webmentions.Sender.html#t:url/0","title":"LastCrusader.Webmentions.Sender.url/0","type":"type"},{"doc":"LastCrusader - Indieweb and the Last Crusade An Indieweb server taylored mainly for my needs, but I hope easily configurable for yours. Your content is yours You are better connected You are in control Requires at least Elixir 11.0 with OTP 22. Works fine with latest Elixir/OTP, including OTP 24.","ref":"readme.html","title":"LastCrusader - Indieweb and the Last Crusade","type":"extras"},{"doc":"[ ] IndieAuth server [x] Micropub server [ ] Webmentions : [X] send webmentions [ ] receive webmentions","ref":"readme.html#todo","title":"LastCrusader - Indieweb and the Last Crusade - Todo","type":"extras"},{"doc":"run tests: mix test run locally: iex -S mix install git hooks locally: mix git_hooks.install make a release: MIX_ENV=prod mix release or with personal secrets MIX_ENV=perso mix release make a release that targets a debian: ./debian_release.sh (uses docker)","ref":"readme.html#notes-to-self","title":"LastCrusader - Indieweb and the Last Crusade - Notes to self","type":"extras"},{"doc":"Changelog","ref":"changelog.html","title":"Changelog","type":"extras"},{"doc":"update post after automatic syndication via brid.gy : github: update a file update dependancies: #28: bump webmentions from 1.0.1 to 1.0.2 #29: bump tz from 0.16.2 to 0.17.0","ref":"changelog.html#unreleased-yet","title":"Changelog - Unreleased yet","type":"extras"},{"doc":"2021/06/22 update dependancies: #14: bump plug_cowboy from 2.4.1 to 2.5.0 #18/#20: bump webmentions from 0.5.3 to 1.0.1 (with contributions from me) #19/#21/#24: bump tz from 0.12.0 to 0.16.2 #22: bump mint from 1.2.1 to 1.3.0 #15/#16/#17: bump git_hooks from 0.5.2 to 0.6.2 #23: bump mix_test_watch from 1.0.2 to 1.0.3 #25: bump excoveralls from 0.14.0 to 0.14.1 #26: bump credo from 1.5.5 to 1.5.6 #27: bump doctor from 0.17.0 to 0.18.0 script to make a release that targets a debian: ./debian_release.sh (uses docker)","ref":"changelog.html#0-5-4","title":"Changelog - 0.5.4","type":"extras"},{"doc":"2021/04/16 micropub: Hugo: fix links extraction from Hugo posts Hugo: fix: treat mp-syndicate-to property as a syndicate-to one webmention: add automatic syndication to twitter.com (via brid.gy ) better logs","ref":"changelog.html#0-5-3","title":"Changelog - 0.5.3","type":"extras"},{"doc":"2021/04/16 micropub: Hugo: support like-of types as Notes Hugo: support repost-of types as Notes webmention: check if origin exists every minute with a HEAD HTTP request. It will prevent us from waiting too long for the content to be published","ref":"changelog.html#0-5-0","title":"Changelog - 0.5.0","type":"extras"},{"doc":"2021/04/14 micropub: Hugo: support in-reply-to types as Notes webmention: add brid.gy webmention endpoint for: twitter.com github.com update dependancies: #11: bump ex_doc from 0.24.1 to 0.24.2 #12: bump tesla from 1.4.0 to 1.4.1","ref":"changelog.html#0-4-3","title":"Changelog - 0.4.3","type":"extras"},{"doc":"2021/04/06 drop support for Elixir &lt; 1.11 better handling of proxied HTTPS requests (see Plug.RewriteOn ) CI: added doctor to check added credo to check added as much Typespecs as possible update dependancies: #6/#9: bump ex_doc from 0.23.0 to 0.24.1 #10: bump webmentions from 0.5.2 to 0.5.3 remove dependancy to timex: drop support to Elixir &lt; 1.11","ref":"changelog.html#0-4-0","title":"Changelog - 0.4.0","type":"extras"},{"doc":"2021/03/04 micropub/webmention: Handles my personal special case with my &quot;indienews&quot; Hugo shortcode","ref":"changelog.html#0-3-4","title":"Changelog - 0.3.4","type":"extras"},{"doc":"2021/03/02 micropub: fix Github integration #5: dependancies: bump timex from 3.6.3 to 3.6.4","ref":"changelog.html#0-3-3","title":"Changelog - 0.3.3","type":"extras"},{"doc":"2021/02/25 micropub: fix encoding issues from another weird long dash (see also release 0.2.2) extract links from bookmark posts for webmention dependancies: remove unnecessary dependancy to Tentacat","ref":"changelog.html#0-3-2","title":"Changelog - 0.3.2","type":"extras"},{"doc":"2021/02/24 added /status route for remote monitoring better logging configuration","ref":"changelog.html#0-3-1","title":"Changelog - 0.3.1","type":"extras"},{"doc":"2021/02/24 micropub: send webmentions to mentionned URL in published content (waits for a publishing delay from Github/Netlify) #4: dependancies: bump excoveralls from 0.13.4 to 0.14.0","ref":"changelog.html#0-3-0","title":"Changelog - 0.3.0","type":"extras"},{"doc":"2021/02/11 micropub: fix encoding issues from weird long dash update dependancies: #3: bump plug_cowboy from 2.3.0 to 2.4.1 #1: bump excoveralls from 0.12.3 to 0.13.4","ref":"changelog.html#0-2-2","title":"Changelog - 0.2.2","type":"extras"},{"doc":"2021/01/28 micropub: fix encoding issues from emojis","ref":"changelog.html#0-2-1","title":"Changelog - 0.2.1","type":"extras"},{"doc":"2020/11/18 First &quot;production&quot; release","ref":"changelog.html#0-2-0","title":"Changelog - 0.2.0","type":"extras"},{"doc":"Draft","ref":"changelog.html#0-1-0","title":"Changelog - 0.1.0","type":"extras"},{"doc":"Please submit Issues or PR :)","ref":"contributing.html","title":"CONTRIBUTING","type":"extras"},{"doc":"MIT License Copyright (c) 2020 Jean-Philippe Caruana Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the &quot;Software&quot;), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software. THE SOFTWARE IS PROVIDED &quot;AS IS&quot;, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.","ref":"license.html","title":"LICENSE","type":"extras"}]