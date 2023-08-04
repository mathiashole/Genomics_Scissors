#!/usr/bin/perl

use strict;
use warnings;

# Get command line arguments
my $option = shift @ARGV;
my $input_file = shift @ARGV;


# Check if all arguments are provided
unless ($option && $input_file) {
    die "Uso: perl convertir.pl <-bed|-gff|-txt> archivo_entrada archivo_salida\n";
}

# Get the base name of the input file
#my ($output_file, $directories) = $input_file =~ /^(.*)\.[^.]+$/;
my ($output_file, $directories) = $input_file =~ /^(.*?)(\.[^.]+)?$/;

# Add the .txt extension to the output name
$output_file .= ".txt";

# Debug prints
print "Input File: $input_file\n";
print "Output File: $output_file\n";
print "Directories: $directories\n";

# Read input file and perform conversion as per option
if ($option eq "-bed" && $directories eq ".bed") {

    convertir_bed_a_txt($input_file, $output_file);

} elsif ($option eq "-gff" && $directories eq ".gff") {

    convertir_gff_a_txt($input_file, $output_file);

} elsif ($option eq "-txt" && $directories eq ".txt") {

    # If the option is -txt, the file is kept unchanged
    # Some additional verification can be added if needed
    rename($input_file, $output_file) or die "Error renaming the file: $!";

} else {

    die "Invalid option. Must be -bed, -gff, or -txt.\n";

}

# Function to convert BED file to TXT
sub convertir_bed_a_txt {
    my ($input_file, $output_file) = @_;

    open(my $input_fh, "<", $input_file) or die "Cannot open input file: $!";
    open(my $output_fh, ">", $output_file) or die "Cannot open output file: $!";

    while (my $line = <$input_fh>) {
        chomp $line;
        my @fields = split("\t", $line);
        my $contig = $fields[0];
        my $inicio = $fields[1];
        my $fin = $fields[2];
        my $nombre = $fields[3];
        print "$contig\t$inicio\t$fin\t$nombre\n"; # debug
        print $output_fh "$contig\t$inicio\t$fin\t$nombre\n";
    }

    close($input_fh);
    close($output_fh);
}

# Function to convert GFF file to TXT
sub convertir_gff_a_txt {
    my ($input_file, $output_file) = @_;

    open(my $input_fh, "<", $input_file) or die "Cannot open input file: $!";
    open(my $output_fh, ">", $output_file) or die "Cannot open output file: $!";

    while (my $line = <$input_fh>) {
        chomp $line;
        #print "Line read: $line\n"; # debug
        #print "Fields: @fields\n"; # debug
        my @fields = split("\t", $line);
        my $contig = $fields[0];
        my $inicio = $fields[3];
        my $fin = $fields[4];
        my $nombre = (split(";", $fields[8]))[0];
        $nombre =~ s/.*?ID=//;
        print "$contig\t$inicio\t$fin\t$nombre\n"; # debug
        print $output_fh "$contig\t$inicio\t$fin\t$nombre\n";
    
    }

    close($input_fh);
    close($output_fh);
}

