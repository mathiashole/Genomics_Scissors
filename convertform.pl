#!/usr/bin/perl

use strict;
use warnings;


# Get command line arguments
my $option = shift;
my $input_file = shift;


# Check if all arguments are provided
unless ($option && $input_file) {
    die "\t Usage: perl convert.pl < -bed | -gff | -txt > input_file.\n \t See manual or --help option \n";
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

   # conver_bed_to_txt($input_file, $output_file);
    conver_bed_to_txt($input_file);
    ## only for debugging
    #    my $data_ref = conver_bed_to_txt($input_file);

    #     # Inspeccionar el contenido de la referencia devuelta
    #     print "Contenido de la referencia devuelta:\n";
    #     foreach my $row_ref (@$data_ref) {
    #         print join("\t", @$row_ref), "\n";
    #     }

} elsif ($option eq "-gff" && $directories eq ".gff") {

   # convert_gff_to_txt($input_file, $output_file);
    convert_gff_to_txt($input_file);

} elsif ($option eq "-txt" && $directories eq ".txt") {

    # If the option is -txt, the file is kept unchanged
    # Some additional verification can be added if needed
    rename($input_file, $output_file) or die "Error renaming the file: $!";

} else {

    die "\t Invalid option. Must be -bed, -gff, or -txt.\n \t See manual or --help option \n";

}

# Function to convert BED file to TXT
sub conver_bed_to_txt {
    # my ($input_file, $output_file) = @_;
    my ($input_file) = @_;

    open(my $input_fh, "<", $input_file) or die "Cannot open input file: $!";
   # open(my $output_fh, ">", $output_file) or die "Cannot open output file: $!";

    my @data;

    while (my $line = <$input_fh>) {
        chomp $line;
        my @fields = split("\t", $line);
        my $contig = $fields[0];
        my $start = $fields[1];
        my $end = $fields[2];
        my $name = $fields[3];
       # print "$contig\t$start\t$end\t$name\n"; # debug
       # print $output_fh "$contig\t$start\t$end\t$name\n"; # save in file
        push @data, [$contig, $start, $end, $name];
    }

    close($input_fh);
   # close($output_fh);

   ## this point create for debugging
    # print "Tabla generada:\n";
    # foreach my $row (@data) {
    #     my ($contig, $start, $end, $name) = @$row;
    #     print "$contig\t$start\t$end\t$name\n";
    # }

    return \@data;
    
}

# Function to convert GFF file to TXT
sub convert_gff_to_txt {
    # my ($input_file, $output_file) = @_;
    my ($input_file) = @_;

    open(my $input_fh, "<", $input_file) or die "Cannot open input file: $!";
   # open(my $output_fh, ">", $output_file) or die "Cannot open output file: $!";

    my @data;

    while (my $line = <$input_fh>) {
        chomp $line;
        #print "Line read: $line\n"; # debug
        #print "Fields: @fields\n"; # debug
        my @fields = split("\t", $line);
        my $contig = $fields[0];
        my $start = $fields[3];
        my $end = $fields[4];
        my $name = (split(";", $fields[8]))[0];
        $name =~ s/.*?ID=//;
        #print "$contig\t$start\t$end\t$name\n"; # debug
        #print $output_fh "$contig\t$start\t$end\t$name\n";
        push @data, [$contig, $start, $end, $name];
    }

    close($input_fh);
   # close($output_fh);
    return \@data;
}

