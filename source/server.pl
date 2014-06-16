#!/usr/bin/perl

use v5.14;
use warnings;

use Net::Async::HTTP::Server;
use IO::Async::Loop;

use HTTP::Request;
use HTTP::Response;

use Routers::DefaultRouter;

my $PORT_NUMBER = 8080;

my $async_loop = IO::Async::Loop->new();

my $http_server = Net::Async::HTTP::Server->new(
    on_request => sub {
        my ($self, $request) = @_;
        my ($code, $result) = Routers::DefaultRouter->process_request($request);

        my $response = HTTP::Response->new ($code);
        $response->add_content ($result);
        $response->content_type ("application/json");
        $response->content_length (length $response->content);
        $request->respond($response);
    }
);

$async_loop->add( $http_server );

$http_server->listen(
    addr => { family => "inet", socktype => "stream", port => $PORT_NUMBER },
    on_listen_error => sub { die "Cannot listen - $_[-1]\n" },
);

say 'Server started, listening on port: ', $PORT_NUMBER;

$async_loop->run;