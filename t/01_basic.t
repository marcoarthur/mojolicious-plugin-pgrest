## no critic
package MyPgRest;
use Mojolicious::Lite -strict;
use Mojo::JSON qw(decode_json);

my $api = <<EOAPI;
{
  "swagger": "2.0",
  "info": {
    "title": "Sample API",
    "description": "API description in Markdown.",
    "version": "1.0.0"
  },
  "host": "localhost:3000",
  "basePath": "/v1",
  "schemes": [
    "http"
  ],
  "paths": {
    "/users": {
      "get": {
        "summary": "Returns a list of users.",
        "description": "Optional extended description in Markdown.",
        "produces": [
          "application/json"
        ],
        "responses": {
          "200": {
            "description": "OK"
          }
        }
      }
    }
  }
}
EOAPI

get '/' => sub { my $c = shift; $c->render( json => decode_json($api) ) };

# Plugin must be initialized at end of application because we
# need to set the '/' (root route) before
plugin PgREST => { openApi => app->ua->server->url };

1;

package main;
## use critic
use Test::More;
use Test::Mojo;

use Mojolicious -signatures;

my $pg = MyPgRest->new;
$pg->log->level('fatal');

my $t = Test::Mojo->new($pg);

sub tests {
    my $route = $pg->routes;
    isa_ok $route, 'Mojolicious::Routes';
    is $pg->url_for('users'), '/v1/users', 'Right url from spec';

    $t->get_ok('/')->status_is(200)->json_is( '/swagger' => '2.0' );
    done_testing;
}

tests;
