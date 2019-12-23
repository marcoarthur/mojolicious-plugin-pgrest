# NAME

Mojolicious::Plugin::PgREST - Enables Mojo to proxy calls to a PgREST (actually
any openAPI service) and cache the requests.

# SYNOPSIS

    use Mojolicious::Plugin::PgREST;
    plugin PgREST => { openApi => 'your.openapi/spec' };
    

# DESCRIPTION

Mojolicious::Plugin::PgREST enables a Mojo application to access PgREST or any
open API service to be proxied. In this manner you can build your Mojolicious
Application with other OpenAPI services (provided it shares the specifications).

Your Mojolicious App can, for example, cache it, ( actually, it does by default )

It uses [Mojolicious::Plugin::OpenAPI](https://metacpan.org/pod/Mojolicious%3A%3APlugin%3A%3AOpenAPI) to read the specification and mount
routes. And uses [CHI](https://metacpan.org/pod/CHI) for in memory caching, defaults to 30 minutes cache
expiration.

# CAVEATS

This plugins attempts to read the OpenAPI specification in json format. All
responses will only be in json format, disregarding the possible other formats
accepted from the spec.

# LICENSE

Copyright (C) Marco Arthur.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

Marco Arthur <arthurpbs@gmail.com>
