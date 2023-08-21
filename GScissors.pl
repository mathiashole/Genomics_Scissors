#!/usr/bin/perl

use strict;
use warnings;
use FindBin qw($Bin);

my $f1 = shift; 
my $f2 = shift;

# Check if a text file was provided as an argument
# Function to show help

if ($f1 eq '-h' || $f1 eq '--help') {
    show_help();
} elsif ($f1 eq '-v' || $f1 eq '--version') {
    show_version();
} elsif ($f1 eq '-txt' || $f1 eq '--text' ||
         $f1 eq '-gff' || $f1 eq '--gff' ||
         $f1 eq '-bed' || $f1 eq '--bed') {
    if (validate_filename_format($f2)) {
        process_conversion($f1, $f2);
        proof($f1, $f2);
    } else {
        print "\tFile format is invalid: $f2\n";
    }
} else {
    print "\tUnrecognized option: $f1\n";
}

## Function to show help of the program
sub show_help {

  print << 'HELP';
  "Usage: GScissors 🔪

  💻 Available [OPTIONS]:

    -h, --help		Show this help.
    -v, --version	Show the version of the program.
    -gff, --gff		If your data is gff format.
	  -bed, --bed		If your data is bed format.
	  -txt, --text	If your data is txt format.

  📂 Available [ARGUMENTS]:

	  first argument sequence in fasta format.
	  second argument input txt, bed or gff format.
	  third argument output fasta file.

  📄 The format of txt table [FORMAT]:
    sequence_ID	start	end  
    sequence_ID	start	end	  output_ID

  📨 CONTACT
    https://github.com/mathiashole
    https://twitter.com/joaquinmangino

    MIT © Mathias Mangino
HELP
}

# Function to show the version of the program
sub show_version {
    print "GScissors.pl v0.0.1\n";
}

sub validate_filename_format {
    my ($filename) = @_;
    # Regular expression to check if the filename has a valid extension
    return $filename =~ /^[^.]+\.(txt|gff|bed)$/i;
}

sub process_conversion {
    my ($option, $file) = @_;

    # Construct the path to the perl script file
    my $script_convert = "$Bin/convertform.pl";

    # Command in perl to be executed
    my $convert_run = "perl $script_convert $option $file";
    
    #my @arreglo = system($convert_run);

    my $output = `$convert_run`;  # Capture command output

    return $output;
}

sub proof {
    my $prueba = process_conversion($f1, $f2);
    my @arreglo = split("\n", $prueba);
    foreach my $line (@arreglo) {
       # Trabajar con cada línea en el array
        #print "$line\n";
        # Acumular la línea en la variable
        my $acumulated_output .= "$line\n";
        #print $acumulated_output;
    }
    #another_cuntion(la, la, la, $acumulated_output)
}

sub check_fasta_format {
    my ($file) = @_;

    open(my $fh, "<", $file) or return 0;

    my $is_fasta = 0;
    while (<$fh>) {
        chomp;
        if (/^>/) {
            $is_fasta = 1;
            last;
        }
    }

    close($fh);

    return $is_fasta;
}

