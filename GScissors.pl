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
} elsif ($f1 eq '-txt' || $f1 eq '--text') {
    
    # Construct the path to the perl script file
    my $script_convert = "$Bin/convertform.pl";

    # Command in perl to be executed
    my $convert_run = "perl $script_convert $f1 $f2";

    print "$convert_run";

    # Run the perl command
    system($convert_run);

} elsif ($f1 eq '-gff' || $f1 eq '--gff') {
    
    # Construct the path to the perl script file
    my $script_convert = "$Bin/convertform.pl";

    # Command in perl to be executed
    my $convert_run = "perl $script_convert $f1 $f2";

    print "$convert_run";

    # Run the perl command
    system($convert_run);

} elsif ($f1 eq '-bed' || $f1 eq '--bed') {
    
    # Construct the path to the perl script file
    my $script_convert = "$Bin/convertform.pl";

    # Command in perl to be executed
    my $convert_run = "perl $script_convert $f1 $f2";

    print "$convert_run";

    # Run the perl command
    system($convert_run);

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
    joacomangino\@gmail.com
    https://twitter.com/joaquinmangino

    MIT © Mathias Mangino
HELP
}

# Function to show the version of the program
sub show_version {
    print "GScissors.pl v0.0.1\n";
}
