# lib/Log/Reporter.pm
package Log::Reporter;
use strict;
use warnings;
use Exporter 'import';
our @EXPORT_OK = qw(generate_report);

sub generate_report {
    my ($data, $type, $output_file) = @_;

    if ($type eq 'text') {
        generate_text_report($data, $output_file);
    } elsif ($type eq 'html') {
        generate_html_report($data, $output_file);
    } else {
        die "Unknown report type: $type";
    }
}

sub generate_text_report {
    my ($data, $output_file) = @_;

    open my $fh, '>', $output_file or die "Could not open $output_file: $!";
    
    print $fh "IP Address Count:\n";
    foreach my $ip (keys %{$data->{ip_count}}) {
        print $fh "$ip: $data->{ip_count}{$ip}\n";
    }

    print $fh "\nStatus Code Count:\n";
    foreach my $status (keys %{$data->{status_count}}) {
        print $fh "$status: $data->{status_count}{$status}\n";
    }

    print $fh "\nLog Entries:\n";
    foreach my $entry (@{$data->{entries}}) {
        print $fh "IP: $entry->{ip}, Timestamp: $entry->{timestamp}, Method: $entry->{method}, URL: $entry->{url}, Status: $entry->{status}, Size: $entry->{size}\n";
    }

    close $fh;
}

sub generate_html_report {
    my ($data, $output_file) = @_;

    open my $fh, '>', $output_file or die "Could not open $output_file: $!";
    print $fh "<html><body>\n";
    print $fh "<h1>IP Address Count:</h1>\n";
    print $fh "<ul>\n";
    foreach my $ip (keys %{$data->{ip_count}}) {
        print $fh "<li>$ip: $data->{ip_count}{$ip}</li>\n";
    }
    print $fh "</ul>\n";

    print $fh "<h1>Status Code Count:</h1>\n";
    print $fh "<ul>\n";
    foreach my $status (keys %{$data->{status_count}}) {
        print $fh "<li>$status: $data->{status_count}{$status}</li>\n";
    }
    print $fh "</ul>\n";

    print $fh "<h1>Log Entries:</h1>\n";
    print $fh "<table border='1'>\n";
    print $fh "<tr><th>IP</th><th>Timestamp</th><th>Method</th><th>URL</th><th>Status</th><th>Size</th></tr>\n";
    foreach my $entry (@{$data->{entries}}) {
        print $fh "<tr><td>$entry->{ip}</td><td>$entry->{timestamp}</td><td>$entry->{method}</td><td>$entry->{url}</td><td>$entry->{status}</td><td>$entry->{size}</td></tr>\n";
    }
    print $fh "</table>\n";
    print $fh "</body></html>\n";
    close $fh;
}

1;
