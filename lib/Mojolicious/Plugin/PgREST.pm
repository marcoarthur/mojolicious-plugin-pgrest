package Mojolicious::Plugin::PgREST;
use 5.022;
use Mojo::Base 'Mojolicious::Plugin', -signatures;
use Mojolicious::Plugin::OpenAPI;
use constant DEBUG => $ENV{MOJO_PGREST_DEBUG} || 0;
use DDP;

our $VERSION = "0.01";

sub register($self, $app, $config) {
    # Set hook to point to the proxy method
    $app->hook(
        openapi_routes_added => sub( $openapi, $routes ) {
            for my $route (@$routes) {
                $route->to( cb => sub($c) { $self->_do_proxy } );
            }
        }
    );

    $self->_load_openapi($app, $config);
}

sub _load_openapi($self, $app, $config) {
    my $json = $app->ua->get($config->{ openApi })->result->json or
    die "Can't get the schema";

    my $p = $app->plugin( 'OpenAPI' => { url => $json } );

    # Stop warnings with these format values common found in PGREST
    ## no critic Subroutines::ProhibitExplicitReturnUndef
    $p->validator->formats->{text}                = sub { return undef };
    $p->validator->formats->{'character varying'} = sub { return undef };
}

sub _do_proxy( $self ) {
    my $c = $self->openapi->valid_input or return;
    $c->render_later;

    my $input   = $c->validation->output;
    my $name    = $c->match->endpoint->name;
    my $method  = $c->req->method;
    my $params  = $c->req->params->to_hash;
    my $json    = $c->req->json;
    my $auth    = $c->req->headers->authorization;
    my $host    = $c->openapi->spec("/host");
    my $schemes = $c->openapi->spec("/schemes");

    my $uri = Mojo::URL->new;
    $uri->scheme($schemes->[0]);
    $uri->host($host);
    $uri->path($name);
    $uri->query($params) if $params && %$params;

    # proxy to pgREST
    my $tx =
        $json && %$json
      ? $c->ua->build_tx( $method => $uri => json => $json )
      : $c->ua->build_tx( $method => $uri );

    # copy auth headers
    $tx->req->headers->authorization($auth) if $auth;
    $tx->req->headers->accept('application/json');
    $c->app->log->debug("Calling pgREST ($method): $uri");

    $c->ua->start_p($tx)->then(
        sub( $tx ) {
            my $res = $tx->result;
            if ( $res->json ) { 
                $c->render( json => $res->json,    status => $res->code );
            } else { 
                $c->render( text => 'No response', status => $res->code );
            }
        }
    )->catch( sub( $err ) { warn "Error proxying request:  $err" } );

}

1;
__END__

=encoding utf-8

=head1 NAME

Mojolicious::Plugin::PgREST - This plugins enables Mojo to proxy calls to a
PgREST (actually any openAPI service) and optionally instance memcaching the
request.

=head1 SYNOPSIS

    use Mojolicious::Plugin::PgREST;
    plugin 'proxy', { openApi => 'your.openapi/spec' };
    

=head1 DESCRIPTION

Mojolicious::Plugin::PgREST enables a Mojo application to access PgREST or any
open API service to be proxied. In this manner you can build your Mojolicious
Application with other OpenAPI services (provide it shares the specifications).

Your Mojolicious App can for example cache it, actually this plugin can cache
it by default, just flag it in configuration C<< cache => 1 >>

It uses L<Mojolicious::Plugin::OpenAPI> to read the specification and mount
routes. And uses L<Cache::Memcached::Fast> for caching

=head1 LICENSE

Copyright (C) Marco Arthur.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Marco Arthur E<lt>arthurpbs@gmail.comE<gt>

=cut

