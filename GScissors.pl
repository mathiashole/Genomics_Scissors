#!/usr/bin/perl

use strict;
use warnings;
use FindBin qw($Bin);

#my $f1 = shift or die "multifasta file missing\n";
#my $f2 = shift or die "missing coordinate file\n";
#my $f3 = shift;
#my $f4 = shift;


# Check if a text file was provided as an argument
# Function to show help
if (grep { $_ eq '-h' || $_ eq '--help' } @ARGV) {
    
  # show help message
	show_help();

} elsif (grep { $_ eq '-v' || $_ eq '--version' } @ARGV) {
	
	show_version();

} elsif ( grep { $_ eq '-txt' } @ARGV || grep { $_ eq '--text' } @ARGV ) {
	
  # Construct the path to the perl script file
  my $script_convert = "$Bin/convertform.pl";

  # Command in perl to be executed
  my $script_convert_run = "perl $script_convert \"$1\\ "; ## debugger

  # Run the perl command
  system($script_convert_run);


} elsif ( grep { $_ eq '-gff' } @ARGV || grep { $_ eq '--gff' } @ARGV ) {

  # Construct the path to the perl script file
  my $script_convert = "$Bin/convertform.pl";

  # Command in perl to be executed
  my $script_convert_run = "perl $script_convert \"$1\\ "; ## debugger

  # Run the perl command
  system($script_convert_run);

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
