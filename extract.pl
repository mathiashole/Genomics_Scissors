#Made by Mathias Mangino
#Date 10-05-2021

use strict;
#use warnings;
use FindBin qw($Bin);


# Check if a text file was provided as an argument
# Function to show help
if (@ARGV == 0 || grep { $_ eq '-h' } @ARGV || grep { $_ eq '--help' } @ARGV ) {
  # show help message
	show_help();

} elsif ( grep { $_ eq '-v' } @ARGV || grep { $_ eq '--version' } @ARGV ) {
	
	show_version();

} elsif ( grep { $_ eq '-txt' } @ARGV || grep { $_ eq '--text' } @ARGV ) {
	
	# Verify that a second argument is supplied
    die "Error: Missing FASTA file. Usage: perl main.pl -n50 <fasta_file>\n" unless @ARGV >= 3;

    # Get the name of the FASTA file given as an argument
    # my $fasta_file = $ARGV[1];

    # Verify that the file exists
    # die "Error: File '$fasta_file' not found.\n" unless -e $fasta_file; # -e chack for file existence

    # $fasta_file path of file
    # Verify that the file has a .fasta or .fa extension
    # my ($file_name, $file_path, $file_ext) = fileparse($fasta_file, qr/\.[^.]*/); # \. = dot in file name. [^.]* = any sequence followed by a dot
    
    # fileparse() parse the text and save it in a list of variables
    #    $file_name = sample
    #    $file_path = /ruta/del/archivo/fasta/
    #    $file_ext = .fasta
    # die "Error: File '$fasta_file' is not in FASTA format.\n" unless $file_ext =~ /^\.fasta|\.fa$/i;

    # Construct the path to the perl script file
    my $script_convert = "$Bin/convertform.pl";

    # Command in perl to be executed
    my $comando_n50 = "perl $script_convert \"$1\\ "; ## debugger

    # Run the perl command
    system($comando_n50);

	# DEBUGGEAR THIS!!!
	my $f1 = shift or die "multifasta file missing\n";
	my $f2 = shift or die "need format of cootdinate file -txt, -gff or -bed"
	my $f3 = shift or die "missing coordinate file\n";
	my $f4 = shift;
	my $f5 = shift;

	# por defecto convertir to_uppp si recibo flag no

	extractor($f1,$f3,$f4,$f5);

} elsif ( grep { $_ eq '-gff' } @ARGV || grep { $_ eq '--gff' } @ARGV ) {

	# DEBUGGEAR THIS!!!
	my $f1 = shift or die "multifasta file missing\n";
	my $f2 = shift or die "need format of cootdinate file -txt, -gff or -bed"
	my $f3 = shift or die "missing coordinate file\n";
	my $f4 = shift;
	my $f5 = shift;

	# por defecto convertir to_uppp si recibo flag no

	extractor($f1,$f3,$f4,$f5);

}


# my $f1 = shift or die "multifasta file missing\n";
# my $f2 = shift or die "missing coordinate file\n";
# my $f3 = shift;
# my $f4 = shift;

# # por defecto convertir to_uppp si recibo flag no

# extractor($f1,$f2,$f3,$f4);

 
sub extractor {
	my $archivo_multi_fasta = $_[0];
	my $archivo_con_coordenadas = $_[1];
	my $out_put = $_[2];
	my $flag_not_to_upper = $_[3];
		
	my %hash_secuencias = leer_multi_fasta($archivo_multi_fasta);
	
	open (READ,$archivo_con_coordenadas) or die "no file exists $archivo_con_coordenadas\n";
	while (<READ>) {
		my ($nombre, $coor_incio, $coor_fin, $nombre_prot, @resto) =  split(/\s+/, $_);
		my $contig = $hash_secuencias{$nombre};
		my $secuencia = extraer_secuencia($contig,$coor_incio,$coor_fin);
		
		formatear_secuencia(\$secuencia);
		
		unless($flag_not_to_upper){
			$secuencia = uc($secuencia);
		}
		
		my $fasta_string = ">$nombre"."_$nombre_prot [$coor_incio $coor_fin] ".join(" ",@resto)."\n".$secuencia."\n";;
		
		if ($out_put){
			open(FILE,">>./$out_put");
			print FILE "$fasta_string";
			close(FILE);
		}else{
			print "$fasta_string";
		}
	}
	close(READ);
}

sub formatear_secuencia{
	my $secuencia = $_[0];
	$$secuencia =~ s/(.{80})/$1\n/g;
}

sub leer_multi_fasta {
	my $archivo_multi_fasta = $_[0];
	my %hash_retorno = ();
	my $secuencias = '';
	my $nombre_secuencias = '';
	
	open (READ,$archivo_multi_fasta) or die "no file exists $archivo_multi_fasta\n";
	while(my $line = <READ>){

		chomp($line);
		
		if($line =~ />(.*)/) {
        		if($secuencias) { $hash_retorno{$nombre_secuencias} = $secuencias ; }
        		$nombre_secuencias = $1;
			$nombre_secuencias =~ s/ .*//;
        		$secuencias = '';
		}else {
			$line =~ s/\s+//g;
        		$secuencias .= $line;
   		}
	}
	$hash_retorno{$nombre_secuencias} = $secuencias;
	close(READ);
	
	return %hash_retorno;
}

sub extraer_secuencia {
	my $secuencia = $_[0];
	my $coordenada_inicio = $_[1];
	my $coordenada_fin = $_[2];
#	if ($coordenada_inicio == 0){ die "the start coordinate cannot take values ​​less than one";}
	
	$coordenada_inicio--;
	$coordenada_fin--;
	my $largo = abs ($coordenada_fin-$coordenada_inicio)+1;
	my $retorno = '';
 	
	if ($coordenada_inicio <= $coordenada_fin) {
		$retorno = substr($secuencia,$coordenada_inicio,$largo);
	}else{
		my $seq_aux = substr($secuencia,$coordenada_fin,$largo);
		$retorno = inversa_complementaria(\$seq_aux);
	}
	return $retorno;
}

sub inversa_complementaria {
	my $dna_seq_ref = $_[0];
	my $dna_seq_rev_comp = reverse $$dna_seq_ref;
	$dna_seq_rev_comp =~ tr/ACGTacgt/TGCAtgca/;
	return $dna_seq_rev_comp;
}


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
