# NAME

Mojolicious::Plugin::PgREST - This plugins enables Mojo to proxy calls to a
PgREST (actually any openAPI service) and optionally caching the
request.

# SYNOPSIS

    use Mojolicious::Plugin::PgREST;
    plugin 'proxy', { openApi => 'your.openapi/spec' };
    

# DESCRIPTION

Mojolicious::Plugin::PgREST enables a Mojo application to access PgREST or any
open API service to be proxied. In this manner you can build your Mojolicious
Application with other OpenAPI services (provided it shares the specifications).

Your Mojolicious App can, for example cache it, actually this plugin can cache
it by default, just flag it in configuration `cache => 1`

It uses [Mojolicious::Plugin::OpenAPI](https://metacpan.org/pod/Mojolicious%3A%3APlugin%3A%3AOpenAPI) to read the specification and mount
routes. And uses [CHI](https://metacpan.org/pod/CHI) for caching.

# LICENSE

Copyright (C) Marco Arthur.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

Marco Arthur <arthurpbs@gmail.com>
