#!/usr/bin/perl
use strict;
use warnings;
use Time::Local;
use POSIX qw(strftime);

my $num_entries = 1000;  # Change this to generate more or fewer entries
my $filename = 'test_log.log';

# Define possible values for different fields
my @ips = (
    '127.0.0.1', '192.168.1.1', '203.0.113.0', '10.0.0.1', '172.16.0.1',
    '8.8.8.8', '192.168.0.100', '10.0.0.2', '203.0.113.1', '172.16.0.2'
);
my @methods = ('GET', 'POST', 'PUT', 'DELETE');
my @urls = (
    '/index.html', '/login', '/home', '/about', '/contact', 
    '/products', '/services', '/api/data', '/api/user', '/api/login'
);
my @statuses = (200, 201, 301, 302, 400, 401, 403, 404, 500, 502, 503);
my $start_time = timelocal(0, 0, 0, 1, 0, 120);  # January 1, 2020
my $end_time = timelocal(0, 0, 0, 31, 11, 124); # December 31, 2024

sub random_ip {
    return $ips[int(rand(@ips))];
}

sub random_method {
    return $methods[int(rand(@methods))];
}

sub random_url {
    return $urls[int(rand(@urls))];
}

sub random_status {
    return $statuses[int(rand(@statuses))];
}

sub random_size {
    return int(rand(5000)) + 100;
}

sub random_timestamp {
    my $random_time = $start_time + int(rand($end_time - $start_time));
    return strftime("%d/%b/%Y:%H:%M:%S %z", localtime($random_time));
}

open my $fh, '>', $filename or die "Could not open file '$filename': $!";
for (my $i = 0; $i < $num_entries; $i++) {
    print $fh random_ip() . " - - [" . random_timestamp() . "] \"" . random_method() . " " . random_url() . " HTTP/1.1\" " . random_status() . " " . random_size() . "\n";
}
close $fh;

print "Randomized test log file generated: $filename\n";
