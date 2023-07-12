#!/usr/bin/perl

use strict;
use warnings;

# Obtener los argumentos de la línea de comandos
my $option = shift @ARGV;
my $input_file = shift @ARGV;
my $output_file = shift @ARGV;

# Verificar si se proporcionaron todos los argumentos
unless ($option && $input_file && $output_file) {
    die "Uso: perl convertir.pl <-bed|-gff|-txt> archivo_entrada archivo_salida\n";
}

# Leer el archivo de entrada y realizar la conversión según la opción
if ($option eq "-bed") {
    convertir_bed_a_txt($input_file, $output_file);
} elsif ($option eq "-gff") {
    convertir_gff_a_txt($input_file, $output_file);
} elsif ($option eq "-txt") {
    # Si la opción es -txt, se mantiene el archivo sin cambios
    # Se puede agregar alguna verificación adicional si es necesario
    rename($input_file, $output_file) or die "Error al renombrar el archivo: $!";
} else {
    die "Opción no válida. Debe ser -bed, -gff o -txt.\n";
}

# Función para convertir archivo BED a TXT
sub convertir_bed_a_txt {
    my ($input_file, $output_file) = @_;

    open(my $input_fh, "<", $input_file) or die "No se puede abrir el archivo de entrada: $!";
    open(my $output_fh, ">", $output_file) or die "No se puede abrir el archivo de salida: $!";

    while (my $line = <$input_fh>) {
        chomp $line;
        my @fields = split("\t", $line);
        my $contig = $fields[0];
        my $inicio = $fields[1];
        my $fin = $fields[2];
        my $nombre = $fields[3];
        print $output_fh "$contig\t$inicio\t$fin\t$nombre\n";
    }

    close($input_fh);
    close($output_fh);
}

# Función para convertir archivo GFF a TXT
sub convertir_gff_a_txt {
    my ($input_file, $output_file) = @_;

    open(my $input_fh, "<", $input_file) or die "No se puede abrir el archivo de entrada: $!";
    open(my $output_fh, ">", $output_file) or die "No se puede abrir el archivo de salida: $!";

    while (my $line = <$input_fh>) {
        chomp $line;
        my @fields = split("\t", $line);
        my $contig = $fields[0];
        my $inicio = $fields[3];
        my $fin = $fields[4];
        my $nombre = (split(";", $fields[8]))[0];
        $nombre =~ s/.*?ID=//;
        print $output_fh "$contig\t$inicio\t$fin\t$nombre\n";
    }

    close($input_fh);
    close($output_fh);
}

