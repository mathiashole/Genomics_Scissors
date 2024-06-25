#!/usr/bin/perl

use strict;
use warnings;
use FindBin qw($Bin);
use File::Spec;

# -----------------------------------------------------------------------------
# Extractor Script
# -----------------------------------------------------------------------------
# Original Author: Miguel Ponce de Leon
# Modified by: Mathias Mangino
#
# This script was originally created by Miguel Ponce de Leon. The modifications
# include additional functionality and improvements by Mathias Mangino.
# -----------------------------------------------------------------------------


my $f1 = shift or die "\nError\tMissing multifasta file\n";
my $f2 = shift or die "\nError\tMissing coordinate file (txt, gff or bed)\n";
my $f3 = shift;
my $f4 = shift;

# # por defecto convertir to_uppp si recibo flag no

extractor($f1,$f2,$f3,$f4);

 
sub extractor {
	my ($fasta_file, $coordinate_file, $output_file, $flag_not_to_upper) = @_; ## ADD more argument of all contig
		
	my %hash_sequence = read_fasta($fasta_file);
	
	open(my $coordinate_fh, '<', $coordinate_file) or die "\nError\tThis file does not exist $coordinate_file: $!\n";
	while (<$coordinate_fh>) {
		my ($name, $start, $end, $seq_name, @rest) =  split(/\s+/, $_);
		my $contig = $hash_sequence{$name};
		my $secuencia = extract_sequence($contig,$start,$end);
		
		format_sequence(\$secuencia);
		
		unless($flag_not_to_upper){
			$secuencia = uc($secuencia);
		}
		
        my $output_path = File::Spec->catfile('output', $output_file);
		my $fasta_string = ">$name"."_$seq_name [$start $end] ".join(" ",@rest)."\n".$secuencia."\n";;
		
		if ($output_file){
			open(FILE, '>', $output_path);
			print FILE "$fasta_string";
			close(FILE);
		}else{
			print "$fasta_string";
		}
	}
	close($coordinate_fh);
}

sub format_sequence{
	my $secuencia = $_[0];
	$$secuencia =~ s/(.{80})/$1\n/g;
}


sub read_fasta {
    my ($fasta_file) = @_;
    my %sequences;

    open(my $fasta_fh, '<', $fasta_file) or die "Error\topening FASTA file: $!\n";

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

sub extract_aminoacid_sequence {
    my ($sequence, $start_coordinate, $end_coordinate) = @_;

    $start_coordinate--;
    $end_coordinate--;

    my $length = abs($end_coordinate - $start_coordinate) + 1;
    my $result = '';

    if ($start_coordinate <= $end_coordinate) {
        $result = substr($sequence, $start_coordinate, $length);
    } else {
        my $seq_aux = substr($sequence, $end_coordinate, $length);
        $result = $seq_aux;
    }

    return $result;
}


sub complementary_inverse {
	my ($dna_seq_ref) = @_;
	my $dna_seq_rev_comp = reverse $$dna_seq_ref;
	$dna_seq_rev_comp =~ tr/ACGTacgt/TGCAtgca/;
	return $dna_seq_rev_comp;
}

