#!/usr/bin/perl

use strict;
use warnings;


# Get command line arguments
my $option = shift;
my $input_file = shift;


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

    die "Invalid option. Must be -bed, -gff, or -txt.\n See manual or --help option \n";

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
        my $inicio = $fields[1];
        my $fin = $fields[2];
        my $nombre = $fields[3];
       # print "$contig\t$inicio\t$fin\t$nombre\n"; # debug
       # print $output_fh "$contig\t$inicio\t$fin\t$nombre\n"; # save in file
        push @data, [$contig, $inicio, $fin, $nombre];
    }

    close($input_fh);
   # close($output_fh);

   ## this point create for debugging
    # print "Tabla generada:\n";
    # foreach my $row (@data) {
    #     my ($contig, $inicio, $fin, $nombre) = @$row;
    #     print "$contig\t$inicio\t$fin\t$nombre\n";
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
        my $inicio = $fields[3];
        my $fin = $fields[4];
        my $nombre = (split(";", $fields[8]))[0];
        $nombre =~ s/.*?ID=//;
        #print "$contig\t$inicio\t$fin\t$nombre\n"; # debug
        #print $output_fh "$contig\t$inicio\t$fin\t$nombre\n";
        push @data, [$contig, $inicio, $fin, $nombre];
    }

    close($input_fh);
   # close($output_fh);
    return \@data;
}

