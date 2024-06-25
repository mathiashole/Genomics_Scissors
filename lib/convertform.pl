#!/usr/bin/perl

use strict;
use warnings;

my ($option, $input_file) = @ARGV;

convert_file($option, $input_file);

sub convert_file {
    my ($option, $input_file) = @_;

    unless ($option && $input_file) {
        die "Error\tUsage: perl convert.pl < -bed | -gff | -txt > input_file.\n\n \t Check --help or manual\tn";
    }

    my ($output_file, $directories) = $input_file =~ /^(.*?)(\.[^.]+)?$/;
    $output_file .= ".txt";

    if ($option eq "-bed" || $option eq "--bed") {
        if ($directories eq ".bed") {
            my $data_ref = convert_bed_to_txt($input_file);
            return $data_ref;
        } else {
            die "Error\tInvalid final tag. The end tag must be .bed\n\n \t Check --help or manual\t\n";
        }
    } elsif ($option eq "-gff" || $option eq "--gff") {
        if ($directories eq ".gff") {
            my $data_ref = convert_gff_to_txt($input_file);
            return $data_ref;
        } else {
            die "Error\tInvalid final tag. The end tag must be .gff\n\n \t Check --help or manual\t\n";
        }
    } elsif ($option eq "-txt" || $option eq "--text") {
        if ($directories eq ".txt") {
            my $data_ref = read_txt($input_file);
            return $data_ref;
        } else {
            die "Error\tInvalid final tag. The end tag must be .txt\n \t Check --help or manual\t\n";
        }
    } else {
        die "Error\tInvalid option. Must be -bed, -gff, or -txt.\n \t Check --help or manual\t\n";
    }
}

# Function to convert BED file to TXT
sub convert_bed_to_txt {
    # my ($input_file, $output_file) = @_;
    my ($input_file) = @_;

    open(my $input_fh, "<", $input_file) or die "Error\tCannot open input file: $!";
   # open(my $output_fh, ">", $output_file) or die "Cannot open output file: $!";

    my @data;

    while (my $line = <$input_fh>) {
        chomp $line;
        
        # Ignore lines beginning with "#"
        next if $line =~ /^#/;

        my @fields = split("\t", $line);
        my $contig = $fields[0];
        my $start = $fields[1];
        my $end = $fields[2];
        my $name = $fields[3];

        push @data, [$contig, $start, $end, $name];
    }

    close($input_fh);
   # close($output_fh);

    return \@data;    
}

# Function to convert GFF file to TXT
sub convert_gff_to_txt {
    # my ($input_file, $output_file) = @_;
    my ($input_file) = @_;

    open(my $input_fh, "<", $input_file) or die "Error\tCannot open input file: $!";
   # open(my $output_fh, ">", $output_file) or die "Cannot open output file: $!";

    my @data;

    while (my $line = <$input_fh>) {
        chomp $line;
        # Ignore lines beginning with "#"
        next if $line =~ /^#/;
        #print "Fields: @fields\n"; # debug
        my @fields = split("\t", $line);
        my $contig = $fields[0];
        my $start = $fields[3];
        my $end = $fields[4];
        my $name = (split(";", $fields[8]))[0];
        $name =~ s/.*?ID=//;

        push @data, [$contig, $start, $end, $name];
    }

    close($input_fh);
   # close($output_fh);
    return \@data;
}

# Function to read TXT
sub read_txt {
    # my ($input_file, $output_file) = @_;
    my ($input_file) = @_;

    open(my $input_fh, "<", $input_file) or die "Error\tCannot open input file: $!";
   # open(my $output_fh, ">", $output_file) or die "Cannot open output file: $!";

    my @data;

    while (my $line = <$input_fh>) {
        chomp $line;
        print $line;
    my @row = split("\t", $line);
    push @data, \@row;
    }

    close($input_fh);
   # close($output_fh);
    return \@data;
}

# sub convert_blast_to_txt {
#     #my ($blast_file, $output_file) = @_;
#     my ($input_file) = @_;

#     open(my $blast_fh, '<', $blast_file) or die "Error opening BLAST file $blast_file: $!\n";
#     open(my $output_fh, '>', $output_file) or die "Error creating output file $output_file: $!\n";

#     while (my $line = <$blast_fh>) {
#         next if $line =~ /^#/;  # Skip comment lines if present
#         chomp $line;
#         my @fields = split(/\t/, $line);
#         my $result_line = join("\t", $fields[0], $fields[6], $fields[7]) . "\n";
#         print $output_fh $result_line;
#     }

#     close($blast_fh);
#     close($output_fh);

#     print "BLAST results converted to $output_file successfully.\n";
# }