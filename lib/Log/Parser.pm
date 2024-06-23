package Log::Parser;
use strict;
use warnings;
use Exporter 'import';
our @EXPORT_OK = qw(parse_log);

sub parse_log {
    my ($file) = @_;
    my %data;

    open my $fh, '<', $file or die "Could not open file '$file': $!";
    while (my $line = <$fh>) {
        
        if ($line =~ /(\d+\.\d+\.\d+\.\d+).*?\[(.*?)\] "(.*?)" (\d+) (\d+)/) {
            my ($ip, $timestamp, $request, $status, $size) = ($1, $2, $3, $4, $5);
            my ($method, $url) = split(' ', $request);
            push @{$data{entries}}, {
                ip        => $ip,
                timestamp => $timestamp,
                method    => $method,
                url       => $url,
                status    => $status,
                size      => $size
            };
            $data{ip_count}{$ip}++;
            $data{status_count}{$status}++;
        }
    }
    close $fh;

    return \%data;
}

1;  # End of Log::Parser
