#!/usr/bin/perl

use strict;
use warnings;

my $f1 = shift or die "\nError\tMissing multifasta file\n";
my $f2 = shift or die "\nError\tMissing coordinate file (txt, gff or bed)\n";
my $f3 = shift;
my $f4 = shift;

# # por defecto convertir to_uppp si recibo flag no

extractor($f1,$f2,$f3,$f4);

 
sub extractor {
	my $archivo_multi_fasta = $_[0];
	my $archivo_con_coordenadas = $_[1];
	my $out_put = $_[2];
	my $flag_not_to_upper = $_[3];
		
	my %hash_secuencias = read_fasta($archivo_multi_fasta);
	
	open (READ,$archivo_con_coordenadas) or die "\nError\tThis file does not exist $archivo_con_coordenadas\n";
	while (<READ>) {
		my ($nombre, $coor_incio, $coor_fin, $nombre_prot, @resto) =  split(/\s+/, $_);
		my $contig = $hash_secuencias{$nombre};
		my $secuencia = extract_sequence($contig,$coor_incio,$coor_fin);
		
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


sub read_fasta {
    my ($fasta_file) = @_;
    my %sequences;

    open(my $fasta_fh, '<', $fasta_file) or die "Error al abrir el archivo FASTA: $!\n";

    my $current_name = "";
    my $sequence = "";

    while (<$fasta_fh>) {
        chomp;
        if (/^>(\S+)/) {
            if ($current_name) {
                $sequences{$current_name} = $sequence;
            }
            $current_name = $1;
            $sequence = "";
        } else {
            $sequence .= $_;
        }
    }

    $sequences{$current_name} = $sequence if $current_name;

    close($fasta_fh);

    return %sequences;
}

sub extract_sequence {
	my ($sequence, $start_coordinate, $end_coordinate) = @_;

    $start_coordinate--;
    $end_coordinate--;

    my $length = abs($end_coordinate - $start_coordinate) + 1;
    my $result = '';

    if ($start_coordinate <= $end_coordinate) {
        $result = substr($sequence, $start_coordinate, $length);
    } else {
        my $seq_aux = substr($sequence, $end_coordinate, $length);
        $result = reverse_complement($seq_aux);
    }

    return $result;
}

sub complementary_inverse {
	my ($dna_seq_ref) = @_;
	my $dna_seq_rev_comp = reverse $$dna_seq_ref;
	$dna_seq_rev_comp =~ tr/ACGTacgt/TGCAtgca/;
	return $dna_seq_rev_comp;
}

