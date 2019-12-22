use Mojo::Base -strict;
use Test::Mojo;
use Test::More;

use Mojolicious::Lite;

plugin PgREST => { openApi => 'http://localhost:4000' };

my $t = Test::Mojo->new;

$t->get_ok('/api')->status_is(200)->json_is('/swagger', '2.0');

done_testing;
