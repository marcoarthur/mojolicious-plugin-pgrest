requires 'DDP';
requires 'Mojo::Base';
requires 'Mojolicious::Plugin::OpenAPI';
requires 'perl', '5.022';

on configure => sub {
    requires 'Module::Build::Tiny', '0.035';
};

on test => sub {
    requires 'Mojolicious::Lite';
    requires 'Test::Mojo';
    requires 'Test::More', '0.98';
};


