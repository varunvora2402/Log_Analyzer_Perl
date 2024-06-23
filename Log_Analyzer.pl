# log_analyzer.pl
use strict;
use warnings;
use lib 'C:/Users/Varun/Log_Analyzer/lib';  # Use the absolute path
use Getopt::Long;
use Log::Parser qw(parse_log);
use Log::Reporter qw(generate_report);

my $file;
my $report_type;
my $output_file;

GetOptions(
    "file=s"   => \$file,
    "report=s" => \$report_type,
    "output=s" => \$output_file
) or die("Error in command line arguments\n");

# Improved error handling
if (!defined $file || $file eq '') {
    die "File not provided\n";
}
if (!defined $report_type || $report_type eq '') {
    die "Report type not provided\n";
}
if (!-e $file) {
    die "File '$file' does not exist\n";
}
if (!defined $output_file || $output_file eq '') {
    $output_file = $report_type eq 'html' ? 'report.html' : 'report.txt';
}

# Parse the log file
my $data;
eval {
    $data = parse_log($file);
};
if ($@) {
    die "Failed to parse log file: $@\n";
}

# Generate the report
eval {
    generate_report($data, $report_type, $output_file);
};
if ($@) {
    die "Failed to generate report: $@\n";
}

# Print a confirmation message
print "Report generated successfully and saved to $output_file\n";
