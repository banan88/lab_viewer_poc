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

use constant router => 'Routers::DefaultRouter' ;
use constant logger => 'Util::Logger';

my $PORT_NUMBER = 8080;
$SIG{INT}=\&handle_interrupt;

MAIN {
    my $async_loop = IO::Async::Loop->new();

    my $http_server = Net::Async::HTTP::Server->new(
        on_request => sub {
            my ($self, $request) = @_;
            my ($http_code, $body) = router->process_request($request);
            $request->respond(create_response($http_code, $body));
        }
    );

    $async_loop->add( $http_server );

    $http_server->listen(
        addr => { family => "inet", socktype => "stream", port => $PORT_NUMBER },
        on_listen_error => sub { die "Cannot listen - $_[-1]\n" },
    );

    say 'LabViewer server started, listening on port: ', $PORT_NUMBER;
    logger->open('../tmp1.txt', 'INFO'); #TODO: reading level & location from properties
    logger->write_msg('server started...', 'INFO');
    $async_loop->run;
};

sub create_response{
    my ($http_code, $body) = @_;
    my $response = HTTP::Response->new ($http_code);
    $response->add_content ($body);
    $response->content_type ("application/json");
    $response->content_length (length $response->content);
    return $response;
}

sub handle_interrupt{
    logger->write_msg('server stopped.', 'INFO');
    logger->close();
    exit(0);
}