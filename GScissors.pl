#!/usr/bin/perl

use strict;
use warnings;
use FindBin qw($Bin);

my $f1 = shift or die "Missing option. 🔴\n";
my $f2 = shift; #or die "Missing input fasta file\n";
my $f3 = shift; #or die "Missing option format -gff, -bed or -txt\n";
my $f4 = shift; #or die "Missing file in gff, bed or txt\n";
my $f5 = shift; #or die "Missing output fasta file";
my $f6 = shift;

#process_f6();

# Check if a text file was provided as an argument
# Function to show help

if ($f1 eq '-h' || $f1 eq '--help') {
    show_help();
} elsif ($f1 eq '-v' || $f1 eq '--version') {
    show_version();
} elsif ($f1 eq '-fasta' || $f1 eq '--fasta') {
    validation_and_execution_flow($f1, $f2, $f3, $f4, $f5, $f6);
} else {
    print "\tUnrecognized option: $f1 🔴\n\n \tCheck --help or manual\t🔍\n";
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
    print "GScissors.pl v1.2.0-beta\n";
}

sub validate_filename_format {
    my ($filename) = @_;
    # Regular expression to check if the filename has a valid extension
    return $filename =~ /^[^.]+\.(txt|gff|bed)$/i;
}

sub process_conversion {
    my ($f3, $f4) = @_;
    
    # Construct the path to the perl script file
    my $script_convert = "$Bin/convertform.pl";

    # Command in perl to be executed
    my $convert_run = "perl $script_convert $f3 $f4";
    
    #my @arreglo = system($convert_run);

    my $output = `$convert_run`;  # Capture command output

    return $output;
}

sub process_extract {
    my ($f1, $f2, $f3, $f4, $f5, $f6) = @_;

    process_f6(\$f6); # define args $f6

    print "Start of format conversion $f4 ✅\n\n";
    # This section execute process_conversion() and save in variable
    my $prueba = process_conversion($f3, $f4);
    
    # split array into line
    my @arreglo = split("\n", $prueba);
    
    my $acumulated_output = '';

    foreach my $line (@arreglo) {
       # Work with each line in the array
        #print "$line\n";
        # Accumulate line in variable
        my $acumulated_output .= "$line\n";
        #print $acumulated_output;
    }
    
    # Construct the path to the perl script file
    my $script_extract = "$Bin/extract.pl";
    print $script_extract;
    # Command in perl to be executed
    my $extract_run = "perl $script_extract $f2 $acumulated_output $f4 $f5 $f6";
    
    #my @arreglo = system($convert_run);

    system($extract_run);  # Capture command output

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

sub validate_fasta_format {
    my ($file) = @_;

    if (check_fasta_format($file)) {
        print "$file is in FASTA format. Successful ✅\n\n";
    } else {
        die "Error: $file is not in valid FASTA format. 🔴\n";
    }
}


sub validation_and_execution_flow {
    my ($f1, $f2, $f3, $f4, $f5, $f6) = @_;

    #print "$f1 $f2 $f3 $f4 $f5 $f6";

    if ($f1 eq '-fasta' || $f1 eq '--fasta') {
        print "\nStart GScissots program ✅\n\n";
        print "Valid FASTA format. Processing... ⏲\n";
        if (validate_fasta_format($f2)) {
            # Continue here if FASTA format validation is successful
            
            process_extract($f1, $f2, $f3, $f4, $f5, $f6);
        } else {
            print "Invalid FASTA format: $f2 🔴\n";
            # Handle the case of invalid format if necessary
        }
    } elsif ($f3 eq '-txt' || $f3 eq '--text' ||
             $f3 eq '-gff' || $f3 eq '--gff' ||
             $f3 eq '-bed' || $f3 eq '--bed') {
        if (validate_filename_format($f4)) {
            # Continue here if the file format is valid
            print "Valid file format: $f4 ✅\n";
            process_extract($f1, $f2, $f3, $f4, $f5, $f6);
        } else {
            print "\tFile format is invalid: $f4 🔴\n";
            # Handle the case of invalid format if necessary

        }
    } else {
        print "\tUnrecognized option: $f3 🔴\n";
        # Handle the case of unrecognized option if necessary
    }
}

sub process_f6 {
    my ($f6_ref) = @_;

    if ($$f6_ref eq "") {
        $$f6_ref = 0;
    } else {
        $$f6_ref = 1;
    }
}