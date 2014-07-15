#!/usr/bin/perl

use v5.14;
use warnings;

use Net::Async::HTTP::Server;
use IO::Async::Loop;
use DBI;
use HTTP::Request;
use HTTP::Response;

use Routers::DefaultRouter;
use Util::Logger;

use constant ROUTER => 'Routers::DefaultRouter' ;
use constant LOG => 'Util::Logger';

my $PORT_NUMBER = 8080;
$SIG{INT}=\&handle_interrupt;

MAIN {
    my $async_loop = IO::Async::Loop->new();

    my $http_server = Net::Async::HTTP::Server->new(
        on_request => sub {
            my ($self, $request) = @_;
            my ($code, $result) = ROUTER->process_request($request);

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

    say 'LabViewer server started, listening on port: ', $PORT_NUMBER;
    LOG->open('../tmp1.txt');
    LOG->write_msg('YEAH RUNS');
    $async_loop->run;
};

sub handle_interrupt{
    LOG->close();
    exit(0);
}