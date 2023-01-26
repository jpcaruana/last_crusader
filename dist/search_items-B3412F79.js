searchNodes=[{"doc":"IndieAuth authorization endpoint An authorization endpoint is an HTTP endpoint that micropub and IndieAuth clients can use to identify a user or obtain an authorization code (which is then later exchanged for an access token) to be able to post to their website. see https://indieweb.org/authorization-endpoint","ref":"LastCrusader.Auth.AuthHandler.html","title":"LastCrusader.Auth.AuthHandler","type":"module"},{"doc":"authorization-endpoint. To start the sign-in flow, the user's browser will be redirected to their authorization endpoint, with additional parameters in the query string. Parameters: me: Full URI of the user's homepage client_id: Full URI of the application's/website's home page. Used to identify the application. An authorization endpoint may show the application's icon and title to the user during the auth process. redirect_uri: Full URI to redirect back to when the login process is finished state: A random value the app makes up, unique per request. The authorization server just passes it back to the app. Optional. Auth endpoints MUST support them, though. response_type: id (identification only) or code (identification + authorization) Optional. Defaults to id. scope: Not used and omitted in identification mode (response_type=id) For authorization, the scope contains a space-separated list of scopes that the web application requests permission for, e.g. &quot;create&quot;. Multiple values are supported, e.g. create delete","ref":"LastCrusader.Auth.AuthHandler.html#auth_endpoint/1","title":"LastCrusader.Auth.AuthHandler.auth_endpoint/1","type":"function"},{"doc":"Auth code verification For the sign-in flow, the web application will query the authorization endpoint to verify the auth code it received. The client makes a POST request to the authorization server with the following values: POST https :// auth . example . org / auth Content - type : application / x - www - form - urlencoded code = xxxxxxxx &amp; redirect_uri = https :// webapp . example . org / auth / callback &amp; client_id = https :// webapp . example . org / After the authorization server verifies that redirect_uri, client_id match the code given, the response will include the &quot;me&quot; value indicating the URL of the user who signed in. The response content-type should be either application/x-www-form-urlencoded or application/json depending on the value of the HTTP Accept header. Parameters: me: Full URI of the user's homepage This may be different from the me parameter that the user originally entered, but MUST be on the same domain.","ref":"LastCrusader.Auth.AuthHandler.html#code_verification/1","title":"LastCrusader.Auth.AuthHandler.code_verification/1","type":"function"},{"doc":"Simple ETS-based cache. https://gist.github.com/raorao/a4bb34726af2e3fa071adfa504505e1d","ref":"LastCrusader.Cache.MemoryTokenStore.html","title":"LastCrusader.Cache.MemoryTokenStore","type":"module"},{"doc":"Asynchronous call to cache a value at the provided key. Any key that can be used with ETS can be used, and will be evaluated using == .","ref":"LastCrusader.Cache.MemoryTokenStore.html#cache/2","title":"LastCrusader.Cache.MemoryTokenStore.cache/2","type":"function"},{"doc":"Returns a specification to start this module under a supervisor. See Supervisor .","ref":"LastCrusader.Cache.MemoryTokenStore.html#child_spec/1","title":"LastCrusader.Cache.MemoryTokenStore.child_spec/1","type":"function"},{"doc":"Asynchronous clears all values in the cache.","ref":"LastCrusader.Cache.MemoryTokenStore.html#clear/0","title":"LastCrusader.Cache.MemoryTokenStore.clear/0","type":"function"},{"doc":"Callback implementation for GenServer.init/1 .","ref":"LastCrusader.Cache.MemoryTokenStore.html#init/1","title":"LastCrusader.Cache.MemoryTokenStore.init/1","type":"function"},{"doc":"Sychronously reads the cache for the provided key. If no value is found, returns :not_found .","ref":"LastCrusader.Cache.MemoryTokenStore.html#read/1","title":"LastCrusader.Cache.MemoryTokenStore.read/1","type":"function"},{"doc":"Sychronously reads the cache for the provided key. If no value is found, invokes default_fn and caches the result. Note: in order to prevent congestion of the RequestCache process, default_fn is invoked in the context of the caller process.","ref":"LastCrusader.Cache.MemoryTokenStore.html#read_or_cache_default/2","title":"LastCrusader.Cache.MemoryTokenStore.read_or_cache_default/2","type":"function"},{"doc":"Starts a RequestCache process linked to the current process. See GenServer.start_link/2 for details. By default, every item in the cache lives for 6 hours.","ref":"LastCrusader.Cache.MemoryTokenStore.html#start_link/1","title":"LastCrusader.Cache.MemoryTokenStore.start_link/1","type":"function"},{"doc":"","ref":"LastCrusader.Cache.MemoryTokenStore.html#t:cache_key/0","title":"LastCrusader.Cache.MemoryTokenStore.cache_key/0","type":"type"},{"doc":"","ref":"LastCrusader.Cache.MemoryTokenStore.html#t:cache_value/0","title":"LastCrusader.Cache.MemoryTokenStore.cache_value/0","type":"type"},{"doc":"","ref":"LastCrusader.Cache.MemoryTokenStore.html#t:t/0","title":"LastCrusader.Cache.MemoryTokenStore.t/0","type":"type"},{"doc":"Handles the logic of micro-publishing. See also: LastCrusader.Micropub.Hugo LastCrusader.Micropub.Github","ref":"LastCrusader.Micropub.html","title":"LastCrusader.Micropub","type":"module"},{"doc":"Adds a keyword to a published post (most of the time, it will be the syndication link).","ref":"LastCrusader.Micropub.html#add_keyword_to_post/2","title":"LastCrusader.Micropub.add_keyword_to_post/2","type":"function"},{"doc":"Adds a comment to a post into Github repo. It checks that the commented page exists in the Github repo (not on the real website). To make it work in Hugo, you have to publish your content as Pages Bundles . In your post template, include the following partial: { { partial &quot;comments.html&quot; . } } The Hugo partial (&quot;comments.html&quot;) to display comments looks like this: { { $ comments := ( . Resources.Match &quot;comments/*yml&quot; ) } } { { range $ comments } } &lt; li &gt; &lt; i class = &quot;fas fa-reply&quot; &gt; &lt; / i &gt; { { $ comment := ( . Content | transform . Unmarshal ) } } &lt; a href = &quot;{{ $comment.link }}&quot; &gt; { { $ comment . author } } &lt; / a &gt; le { { substr $ comment . date 0 10 } } : { { $ comment . comment | markdownify } } &lt; / li &gt; { { end } }","ref":"LastCrusader.Micropub.html#comment/2","title":"LastCrusader.Micropub.comment/2","type":"function"},{"doc":"Publishes as Hugo post to Github repo: checks auth code and scope discovers post type transforms it as a Hugo post commits to Github repo schedules sending webmentions if needed","ref":"LastCrusader.Micropub.html#publish/2","title":"LastCrusader.Micropub.publish/2","type":"function"},{"doc":"Posts content to github","ref":"LastCrusader.Micropub.GitHub.html","title":"LastCrusader.Micropub.GitHub","type":"module"},{"doc":"shortcut for get_file/5 Uses Application.get_env/2 for default parameters.","ref":"LastCrusader.Micropub.GitHub.html#get_file/1","title":"LastCrusader.Micropub.GitHub.get_file/1","type":"function"},{"doc":"Gets file content from GitHub","ref":"LastCrusader.Micropub.GitHub.html#get_file/5","title":"LastCrusader.Micropub.GitHub.get_file/5","type":"function"},{"doc":"shortcut for new_file/6 Uses Application.get_env/2 for default parameters.","ref":"LastCrusader.Micropub.GitHub.html#new_file/2","title":"LastCrusader.Micropub.GitHub.new_file/2","type":"function"},{"doc":"Creates a commit with the filecontent to GitHub","ref":"LastCrusader.Micropub.GitHub.html#new_file/6","title":"LastCrusader.Micropub.GitHub.new_file/6","type":"function"},{"doc":"shortcut for update_file/6 Uses Application.get_env/2 for default parameters.","ref":"LastCrusader.Micropub.GitHub.html#update_file/2","title":"LastCrusader.Micropub.GitHub.update_file/2","type":"function"},{"doc":"Updates a file on GitHub","ref":"LastCrusader.Micropub.GitHub.html#update_file/6","title":"LastCrusader.Micropub.GitHub.update_file/6","type":"function"},{"doc":"Generates Hugo compatible data, file content, file name","ref":"LastCrusader.Micropub.Hugo.html","title":"LastCrusader.Micropub.Hugo","type":"module"},{"doc":"Renders the post date into Hugo's expected date format ( ISO 8601 )","ref":"LastCrusader.Micropub.Hugo.html#convert_date_to_hugo_format/1","title":"LastCrusader.Micropub.Hugo.convert_date_to_hugo_format/1","type":"function"},{"doc":"Generates TOML formatted front-matter","ref":"LastCrusader.Micropub.Hugo.html#generate_front_matter/3","title":"LastCrusader.Micropub.Hugo.generate_front_matter/3","type":"function"},{"doc":"Generates the complete filename (with path) for a Hugo website Parameters: type: can be :note :post :bookmark in_reply_to name: for the file name date","ref":"LastCrusader.Micropub.Hugo.html#generate_path/3","title":"LastCrusader.Micropub.Hugo.generate_path/3","type":"function"},{"doc":"Create a new Hugo document","ref":"LastCrusader.Micropub.Hugo.html#new/3","title":"LastCrusader.Micropub.Hugo.new/3","type":"function"},{"doc":"Retrieves the local file path of a post from its published public URL","ref":"LastCrusader.Micropub.Hugo.html#reverse_url/2","title":"LastCrusader.Micropub.Hugo.reverse_url/2","type":"function"},{"doc":"Retrieves the local directory path of a post from its published public URL","ref":"LastCrusader.Micropub.Hugo.html#reverse_url_root/2","title":"LastCrusader.Micropub.Hugo.reverse_url_root/2","type":"function"},{"doc":"","ref":"LastCrusader.Micropub.Hugo.html#t:path/0","title":"LastCrusader.Micropub.Hugo.path/0","type":"type"},{"doc":"","ref":"LastCrusader.Micropub.Hugo.html#t:url/0","title":"LastCrusader.Micropub.Hugo.url/0","type":"type"},{"doc":"The Micropub protocol is used to create, update and delete posts on one's own domain using third-party clients. Web apps and native apps (e.g., iPhone, Android) can use Micropub to post and edit articles, short notes, comments, likes, photos, events or other kinds of posts on your own website. cf full specification: https://micropub.spec.indieweb.org/ see also LastCrusader.Micropub.PostTypeDiscovery .","ref":"LastCrusader.Micropub.MicropubHandler.html","title":"LastCrusader.Micropub.MicropubHandler","type":"module"},{"doc":"Handles comment posts from HTTP Parameters: author (mandatory): Name of the comment author (just one field, so we allow aliases) comment (mandatory): Content of the comment. Can be in markdown format original_page (mandatory): URL of the page to comment to link (optional): Link to the personal page of the author","ref":"LastCrusader.Micropub.MicropubHandler.html#comment/1","title":"LastCrusader.Micropub.MicropubHandler.comment/1","type":"function"},{"doc":"","ref":"LastCrusader.Micropub.MicropubHandler.html#options_comment/1","title":"LastCrusader.Micropub.MicropubHandler.options_comment/1","type":"function"},{"doc":"Handles micropublish demands from HTTP See micropublish specification: https://micropub.spec.indieweb.org/#create","ref":"LastCrusader.Micropub.MicropubHandler.html#publish/1","title":"LastCrusader.Micropub.MicropubHandler.publish/1","type":"function"},{"doc":"Handles query requests See micropub query specification: https://micropub.spec.indieweb.org/#querying Note: we just reply to the config , syndicate-to and category requests","ref":"LastCrusader.Micropub.MicropubHandler.html#query/1","title":"LastCrusader.Micropub.MicropubHandler.query/1","type":"function"},{"doc":"Indieweb Post Type discovery implementation see https://indieweb.org/post-type-discovery Post Type Discovery specifies an algorithm for consuming code to determine the type of a post by its content properties and their values rather than an explicit “post type” property, thus better matched to modern post creation UIs that allow combining text, media, etc in a variety of ways without burdening users with any notion of what kind of post they are creating. The Post Type Discovery algorithm (&quot;the algorithm&quot;) discovers the type of a post given a data structure representing a post with a flat set of properties (e.g. Activity Streams (1.0 or 2.0) JSON, or JSON output from parsing [microformats2]), each with one or more values, by following these steps until reaching the first &quot;it is a(n) ... post&quot; statement at which point the &quot;...&quot; is the discovered post type. 1 . If the post has an &quot;rsvp&quot; property with a valid value , Then it is an RSVP post . 2 . If the post has an &quot;in-reply-to&quot; property with a valid URL , Then it is a reply post . 3 . If the post has a &quot;repost-of&quot; property with a valid URL , Then it is a repost ( AKA &quot;share&quot; ) post . 4 . If the post has a &quot;like-of&quot; property with a valid URL , Then it is a like ( AKA &quot;favorite&quot; ) post . 5 . If the post has a &quot;video&quot; property with a valid URL , Then it is a video post . 6 . If the post has a &quot;photo&quot; property with a valid URL , Then it is a photo post . 7 . If the post has a &quot;content&quot; property with a non - empty value , Then use its first non - empty value as the content 8 . Else if the post has a &quot;summary&quot; property with a non - empty value , Then use its first non - empty value as the content 9 . Else it is a note post . 10 . If the post has no &quot;name&quot; property or has a &quot;name&quot; property with an empty string value ( or no value ) Then it is a note post . 11 . Take the first non - empty value of the &quot;name&quot; property 12 . Trim all leading / trailing whitespace 13 . Collapse all sequences of internal whitespace to a single space ( 0x20 ) character each 14 . Do the same with the content 15 . If this processed &quot;name&quot; property value is NOT a prefix of the processed content , Then it is an article post . 16 . It is a note post . Quoted property names in the algorithm are defined in h-entry.","ref":"LastCrusader.Micropub.PostTypeDiscovery.html","title":"LastCrusader.Micropub.PostTypeDiscovery","type":"module"},{"doc":"Discover the post type according to the official algorithm. Can be: :note :article :bookmark :rvsp :in_reply_to :like_of :video :photo","ref":"LastCrusader.Micropub.PostTypeDiscovery.html#discover/1","title":"LastCrusader.Micropub.PostTypeDiscovery.discover/1","type":"function"},{"doc":"Determine whether the name property represents an explicit title. see one python implementation because the official algo explanation is not clear at all (to me). I took documentation (and unit tests) from it: Typically when parsing an h-entry, we check whether p-name == e-content (value) . If they are non-equal, then p-name likely represents a title. However, occasionally we come across an h-entry that does not provide an explicit p-name. In this case, the name is automatically generated by converting the entire h-entry content to plain text. This definitely does not represent a title, and looks very bad when displayed as such. To handle this case, we broaden the equality check to see if content is a subset of name. We also strip out non-alphanumeric characters just to make the check a little more forgiving.","ref":"LastCrusader.Micropub.PostTypeDiscovery.html#is_name_a_title?/2","title":"LastCrusader.Micropub.PostTypeDiscovery.is_name_a_title?/2","type":"function"},{"doc":"","ref":"LastCrusader.Micropub.PostTypeDiscovery.html#t:post_type/0","title":"LastCrusader.Micropub.PostTypeDiscovery.post_type/0","type":"type"},{"doc":"Utils for easy HTTP manipulation","ref":"LastCrusader.Utils.Http.html","title":"LastCrusader.Utils.Http","type":"module"},{"doc":"Transforms a list of tuples into a Map","ref":"LastCrusader.Utils.Http.html#as_map/1","title":"LastCrusader.Utils.Http.as_map/1","type":"function"},{"doc":"Add key-value header(s) to HTTP response","ref":"LastCrusader.Utils.Http.html#put_headers/2","title":"LastCrusader.Utils.Http.put_headers/2","type":"function"},{"doc":"Indie Auth Identifier Validator see spec https://indieauth.spec.indieweb.org/#user-profile-url User Profile URL Users are identified by a [URL]. Profile URLs MUST have either an https or http scheme, MUST contain a path component (/ is a valid path), MUST NOT contain single-dot or double-dot path segments, MAY contain a query string component, MUST NOT contain a fragment component, MUST NOT contain a username or password component, and MUST NOT contain a port. Additionally, hostnames MUST be domain names and MUST NOT be ipv4 or ipv6 addresses. Some examples of valid profile URLs are: https :// example . com / https :// example . com / username https :// example . com / users? id = 100 Some examples of invalid profile URLs are: example . com - missing scheme mailto :user@example . com - invalid scheme https :// example . com / foo / .. / bar - contains a double - dot path segment https :// example . com / #me - contains a fragment https :// user :pass@example . com / - contains a username and password https :// example . com : 8443 / - contains a port https :// 172.28 . 92.51 / - host is an IP address","ref":"LastCrusader.Utils.IdentifierValidator.html","title":"LastCrusader.Utils.IdentifierValidator","type":"module"},{"doc":"Validates a user profile URL according to the IndieAuth spec","ref":"LastCrusader.Utils.IdentifierValidator.html#validate_user_profile_url/1","title":"LastCrusader.Utils.IdentifierValidator.validate_user_profile_url/1","type":"function"},{"doc":"Validates a user profile URL according to the IndieAuth spec Useful in a validation pipe, but really relies on validate_user_profile_url/1","ref":"LastCrusader.Utils.IdentifierValidator.html#validate_user_profile_url/2","title":"LastCrusader.Utils.IdentifierValidator.validate_user_profile_url/2","type":"function"},{"doc":"","ref":"LastCrusader.Utils.IdentifierValidator.html#t:url/0","title":"LastCrusader.Utils.IdentifierValidator.url/0","type":"type"},{"doc":"Random string generator module. Imported from https://gist.github.com/ahmadshah/8d978bbc550128cca12dd917a09ddfb7","ref":"LastCrusader.Utils.Randomizer.html","title":"LastCrusader.Utils.Randomizer","type":"module"},{"doc":"Generate random string based on the given length. It is also possible to generate certain type of randomise string using the options below: :all - generate alphanumeric random string :alpha - generate nom-numeric random string :numeric - generate numeric random string :upcase - generate upper case non-numeric random string :downcase - generate lower case non-numeric random string Example iex&gt; Iurban.String . randomizer ( 20 ) // &quot;Je5QaLj982f0Meb0ZBSK&quot;","ref":"LastCrusader.Utils.Randomizer.html#randomizer/2","title":"LastCrusader.Utils.Randomizer.randomizer/2","type":"function"},{"doc":"","ref":"LastCrusader.Utils.Randomizer.html#t:option/0","title":"LastCrusader.Utils.Randomizer.option/0","type":"type"},{"doc":"TOML strings manipulation","ref":"LastCrusader.Utils.Toml.html","title":"LastCrusader.Utils.Toml","type":"module"},{"doc":"Extracts Frontmatter and Content from a Post","ref":"LastCrusader.Utils.Toml.html#extract_frontmatter_and_content/1","title":"LastCrusader.Utils.Toml.extract_frontmatter_and_content/1","type":"function"},{"doc":"Transforms a Map representation of TOML into its String counterpart with included separators","ref":"LastCrusader.Utils.Toml.html#toml_map_to_string/1","title":"LastCrusader.Utils.Toml.toml_map_to_string/1","type":"function"},{"doc":"Updates a TOML formatted front-matter","ref":"LastCrusader.Utils.Toml.html#update_toml/2","title":"LastCrusader.Utils.Toml.update_toml/2","type":"function"},{"doc":"","ref":"LastCrusader.Utils.Toml.html#t:toml/0","title":"LastCrusader.Utils.Toml.toml/0","type":"type"},{"doc":"Schedules webmentions to be send It first checks of the origin exists before sending webmentions. It will retry this check every minute until it reaches the configured number of tries.","ref":"LastCrusader.Webmentions.Sender.html","title":"LastCrusader.Webmentions.Sender","type":"module"},{"doc":"Finds syndication links (from bridy to twitter) in a list of Webmentions responses","ref":"LastCrusader.Webmentions.Sender.html#find_syndication_links/2","title":"LastCrusader.Webmentions.Sender.find_syndication_links/2","type":"function"},{"doc":"Schedules webmentions to be send with 1 minute wait between every try (default is 15 times)","ref":"LastCrusader.Webmentions.Sender.html#schedule_webmentions/2","title":"LastCrusader.Webmentions.Sender.schedule_webmentions/2","type":"function"},{"doc":"Sends Webmentions to every link","ref":"LastCrusader.Webmentions.Sender.html#send_webmentions/3","title":"LastCrusader.Webmentions.Sender.send_webmentions/3","type":"function"},{"doc":"","ref":"LastCrusader.Webmentions.Sender.html#t:url/0","title":"LastCrusader.Webmentions.Sender.url/0","type":"type"},{"doc":"An Indieweb server taylored mainly for my needs, but I hope easily configurable for yours. Your content is yours You are better connected You are in control Requires at least Elixir 12.0 with OTP 22. Works fine with latest Elixir/OTP, including OTP 24.","ref":"readme.html","title":"LastCrusader - Indieweb and the Last Crusade","type":"extras"},{"doc":"[ ] IndieAuth endpoint [X] Micropub endpoint [ ] Webmentions : [X] send webmentions on new posts [ ] receive webmentions [X] Comment API","ref":"readme.html#todo","title":"LastCrusader - Indieweb and the Last Crusade - Todo","type":"extras"},{"doc":"run tests: mix test run locally: iex -S mix install git hooks locally: mix git_hooks.install make a release: MIX_ENV=prod mix release or with personal secrets MIX_ENV=perso mix release make a release that targets a debian: ./debian_release.sh (uses docker)","ref":"readme.html#notes-to-self","title":"LastCrusader - Indieweb and the Last Crusade - Notes to self","type":"extras"},{"doc":"","ref":"changelog.html","title":"Changelog","type":"extras"},{"doc":"0.9.10 2022/11/11 syndication links: dedicated silo keywords (like twitter, mastodon) to display syndication to several studios for one note/post 0.9.9 2022/11/10 simplify webmention links detection: not done by hand, extracted from the published page 0.9.8 2022/11/10 hugo: link extraction for webmentions: always include https://fed.brid.gy/ dependencies update: #106: bump tz from 0.23.0 to 0.24.0 0.9.7 2022/11/09: 1st mastodon edition hugo syndication: send webmentions for mastodon silo (should be a parameter) a post can syndicate to several silos (e.g. twitter and mastodon) send webmentions for like_of posts dependencies update: #105: bump plug_cowboy from 2.5.2 to 2.6.0 #106: bump tz from 0.22.0 to 0.23.0 floki 0.33.1 =&gt; 0.34.0 0.9.6 2022/10/21 fix elixir 1.14: use Application.compile_env/3 instead of Application.get_env/3 dependencies update: #100: bump jason from 1.3.0 to 1.4.0 earmark_parser 1.4.28 =&gt; 1.4.29 mime 2.0.2 =&gt; 2.0.3 plug_crypto 1.2.2 =&gt; 1.2.3 0.9.5 2022/09/02 Micropub: Hugo: accept listen-of notes dependencies update: #96: bump castore from 0.1.17 to 0.1.18 #98: bump tz from 0.21.1 to 0.22.0 hpax: 0.1.1 -&gt; 0.1.2 0.9.4 2022/07/29 comments API: accept JSON and url-formencoded requests fix confusion in Map with atoms and string for keys / avoid getting atoms from the outside 0.9.1 2022/07/28 dependencies update: bump earmark_parser from 1.4.25 to 1.4.26 bump floki from 0.32.0 to 0.33.1 (minor) bump plug from 1.13.4 to 1.13.6 bump telemetry from 1.0.0 to 1.1.0 #92/#93: bump tz from 0.20.1 to 0.21.1 #89: bump mint from 1.4.1 to 1.4.2 #86: bump castore from 0.1.16 to 0.1.17 0.9.0 2022/03/25 new comments API, see LastCrusader.Micropub.MicropubHandler.comment/1 dependencies update: #82: bump castore from 0.1.15 to 0.1.16","ref":"changelog.html#0-9-x","title":"Changelog - 0.9.x","type":"extras"},{"doc":"0.8.2 2022/03/17 micropub: q=categories : returns an ordered list of (weighted) tags from your website log server port on application start dependencies update: bump plug from 1.12.1 to 1.13.4 bump makeup_elixir from 0.15.2 to 0.16.0 bump earmark_parser from 1.4.20 to 1.4.23 0.8.1 2022/03/10 micropub: q=syndicate-to : return syndication links micropub: github: fix reverse URL guessing 0.8.0 2022/03/09 micropub: Hugo: generate files as Pages Bundles as a preparation for welcoming comments in addition to webmentions micropub: Hugo: remove randomness from filename generation (use EPOCH seconds) dependencies update: #81: bump nimble_parsec from 1.2.2 to 1.2.3 #79: bump webmentions from 2.0.0 to 3.0.0","ref":"changelog.html#0-8-x","title":"Changelog - 0.8.x","type":"extras"},{"doc":"0.7.6 2022/02/25 micropub: Hugo: avoid markdown 'quote' char ( &gt; ) for filename generation dependencies update: #74: bump mint from 1.4.0 to 1.4.1 added dep on hpax 0.1.1 0.7.5 2022/02/15 micropub: Hugo: avoid hugo shortcode for twitter user for filename generation dependencies update: #71: bump hackney from 1.18.0 to 1.18.1 certify: 2.8.0 -&gt; 2.9.0 #72: bump nimble_parsec from 1.2.1 to 1.2.2 0.7.4 2022/02/02 dependencies update: #69: bump castore from 0.1.14 to 0.1.15 #67: bump nimble_parsec from 1.2.0 to 1.2.1 0.7.3 2022/01/20 webapp: add Plug.Cowboy.Drainer for a cleaner shutdown debug mode: webmention sender: more logs dependencies update: #62: bump webmentions from 1.0.3 to 2.0.0 floki: 0.31.0 -&gt; 0.32.0 0.7.2 2021/12/22 parse links from markdown: use nimble parsec instead of regex Note: it adds a new dependency to this (great) library dependencies update: #59: bump castore from 0.1.13 to 0.1.14 #60: bump tesla from 1.4.3 to 1.4.4 mime: 1.6.0 -&gt; 2.0.2 #61: bump jason from 1.2.2 to 1.3.0 0.7.1 2021/12/03 micropub: fix date conversion to Hugo (respect the timezone) removed compatibility with Elixir &lt; 1.12 fix sentry necessary dependencies and install dependencies update: #50/#55: bump bump castore from 0.1.11 to 0.1.13 #49: bump sentry from 8.0.5 to 8.0.6 certifi: 2.6.1 -&gt; 2.8.0 hackney: 1.17.4 -&gt; 1.18.0 0.7.0 2021/09/24 added sentry monitoring dependencies update: #40/#47: bump tz from 0.19.0 to 0.20.1 #45: bump mint from 1.3.0 to 1.4.0 #41: bump webmentions from 1.0.2 to 1.0.3 #44: bump plug_cowboy from 2.5.1 to 2.5.2 telemetry: 0.4.3 -&gt; 1.1.0 plug: 1.12.0 -&gt; 1.12.1 cowboy_telemetry: 0.3.1 -&gt; 0.4.0","ref":"changelog.html#0-7-x","title":"Changelog - 0.7.x","type":"extras"},{"doc":"0.6.4 2021/08/12 fix: LastCrusader.Micropub.add_keyword_to_post/2 : one integration test was missing (and an error crept in). I learned how powerful json decoding was with Tesla... dependencies update: remove unused dependency on toml remove unnecessary dependency on Poison (we use Jason for json encoding/decoding from now on) #34: bump plug_cowboy from 2.5.0 to 2.5.1 plug: 1.11.0 -&gt; 1.12.0 cowlib: 2.9.1 -&gt; 2.11.0 ranch: 1.7.1 -&gt; 1.8.0 #37: bump tz from 0.17.0 to 0.19.0 #39: bump tesla from 1.4.2 to 1.4.3 0.6.1 2021/07/21 investigation around automatic syndication: match LastCrusader.Micropub.add_keyword_to_post/2 response some refactor/duplication hunting 0.6.0 2021/07/16 update post after automatic syndication via brid.gy : find twitter syndication link in brid.gy's response github: retrieve a file's content update a file new LastCrusader.Utils.Toml module for light/easy Toml manipulation dependencies update: #28: bump webmentions from 1.0.1 to 1.0.2 floki: 0.30.1 -&gt; 0.31.0 #29: bump tz from 0.16.2 to 0.17.0 #30: bump tesla from 1.4.1 to 1.4.2 castore: 0.1.10 -&gt; 0.1.11","ref":"changelog.html#0-6-x","title":"Changelog - 0.6.x","type":"extras"},{"doc":"0.5.4 2021/06/22 dependencies update: #14: bump plug_cowboy from 2.4.1 to 2.5.0 telemetry: 0.4.2 -&gt; 0.4.3 #18/#20: bump webmentions from 0.5.3 to 1.0.1 (with contributions from me) #19/#21/#24: bump tz from 0.12.0 to 0.16.2 #22: bump mint from 1.2.1 to 1.3.0 script to make a release that targets a debian: ./debian_release.sh (uses docker) 0.5.3 2021/04/16 micropub: Hugo: fix links extraction from Hugo posts Hugo: fix: treat mp-syndicate-to property as a syndicate-to one webmention: add automatic syndication to twitter.com (via brid.gy ) better logs 0.5.0 2021/04/16 micropub: Hugo: support like-of types as Notes Hugo: support repost-of types as Notes webmention: check if origin exists every minute with a HEAD HTTP request. It will prevent us from waiting too long for the content to be published","ref":"changelog.html#0-5-x","title":"Changelog - 0.5.x","type":"extras"},{"doc":"0.4.3 2021/04/14 micropub: Hugo: support in-reply-to types as Notes webmention: add brid.gy webmention endpoint for: twitter.com github.com dependencies update: #11: bump tesla from 1.4.0 to 1.4.1 mime: 1.5.0 -&gt; 1.6.0 0.4.0 2021/04/06 drop support for Elixir &lt; 1.11 better handling of proxied HTTPS requests (see Plug.RewriteOn ) CI: added doctor to check added credo to check added as much Typespecs as possible dependencies update: #10: bump webmentions from 0.5.2 to 0.5.3 remove dependency to timex: drop support to Elixir &lt; 1.11","ref":"changelog.html#0-4-x","title":"Changelog - 0.4.x","type":"extras"},{"doc":"0.3.4 2021/03/04 micropub/webmention: Handles my personal special case with my &quot;indienews&quot; Hugo shortcode 0.3.3 2021/03/02 micropub: fix Github integration #5: dependencies: bump timex from 3.6.3 to 3.6.4 tzdata: 1.0.5 -&gt; 1.1.0 0.3.2 2021/02/25 micropub: fix encoding issues from another weird long dash (see also release 0.2.2) extract links from bookmark posts for webmention dependencies: remove unnecessary dependency to Tentacat 0.3.1 2021/02/24 added /status route for remote monitoring better logging configuration 0.3.0 2021/02/24 micropub: send webmentions to mentionned URL in published content (waits for a publishing delay from Github/Netlify)","ref":"changelog.html#0-3-x","title":"Changelog - 0.3.x","type":"extras"},{"doc":"0.2.2 2021/02/11 micropub: fix encoding issues from weird long dash dependencies update: #3: bump plug_cowboy from 2.3.0 to 2.4.1 cowboy_telemetry: 0.3.1 0.2.1 2021/01/28 micropub: fix encoding issues from emojis 0.2.0 2020/11/18 First &quot;production&quot; release (lol)","ref":"changelog.html#0-2-x","title":"Changelog - 0.2.x","type":"extras"},{"doc":"Please submit Issues or PR :)","ref":"contributing.html","title":"CONTRIBUTING","type":"extras"},{"doc":"MIT License Copyright (c) 2020 Jean-Philippe Caruana Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the &quot;Software&quot;), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software. THE SOFTWARE IS PROVIDED &quot;AS IS&quot;, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.","ref":"license.html","title":"LICENSE","type":"extras"}]