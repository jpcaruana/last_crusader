# Last Crusader v0.14.0 - API Reference

## Modules

- [LastCrusader.Auth.AuthHandler](LastCrusader.Auth.AuthHandler.md): IndieAuth authorization endpoint
- [LastCrusader.Auth.MetadataHandler](LastCrusader.Auth.MetadataHandler.md): IndieAuth authorization server metadata endpoint.
- [LastCrusader.Auth.TokenHandler](LastCrusader.Auth.TokenHandler.md): IndieAuth token, introspection, and revocation endpoints.
- [LastCrusader.Cache.MemoryTokenStore](LastCrusader.Cache.MemoryTokenStore.md):   Simple ETS-based cache.
- [LastCrusader.Micropub](LastCrusader.Micropub.md): Handles the _logic_ of micro-publishing.
- [LastCrusader.Micropub.Backend](LastCrusader.Micropub.Backend.md): Behaviour for git backends used to persist Hugo post files.

- [LastCrusader.Micropub.GitHub](LastCrusader.Micropub.GitHub.md):   Posts content to github

- [LastCrusader.Micropub.GitLab](LastCrusader.Micropub.GitLab.md):   Posts content to GitLab

- [LastCrusader.Micropub.Hugo](LastCrusader.Micropub.Hugo.md):   Generates Hugo compatible data, file content, file name

- [LastCrusader.Micropub.MicropubHandler](LastCrusader.Micropub.MicropubHandler.md): The Micropub protocol is used to create, update and delete posts on one's own domain using third-party clients.
- [LastCrusader.Micropub.PostTypeDiscovery](LastCrusader.Micropub.PostTypeDiscovery.md):   Indieweb Post Type discovery implementation
- [LastCrusader.Utils.Http](LastCrusader.Utils.Http.md): Utils for easy HTTP manipulation

- [LastCrusader.Utils.IdentifierValidator](LastCrusader.Utils.IdentifierValidator.md): Indie Auth Identifier Validator
- [LastCrusader.Utils.Randomizer](LastCrusader.Utils.Randomizer.md): Random string generator module.
- [LastCrusader.Utils.Toml](LastCrusader.Utils.Toml.md):   TOML strings manipulation

- [LastCrusader.Webmentions.Sender](LastCrusader.Webmentions.Sender.md): Schedules webmentions to be send

