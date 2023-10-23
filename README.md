# gscissors

[![Perl](https://img.shields.io/badge/Perl-blue?style=for-the-badge&logo=perl&logoColor=white&labelColor=101010)](https://www.perl.org)
![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/mathiashole/GScissors?color=white&logo=GitHub&style=for-the-badge&logoColor=white&labelColor=101010)
![GitHub](https://img.shields.io/github/license/mathiashole/GScissors?color=%23179287&style=for-the-badge&logoColor=white&labelColor=101010)

`gscissors` is a Perl script for the extraction of sequences from a multifasta file, allowing the selection of specific sequences by specifying their start and end positions.

## :book: Features

-   Extraction of sequences from a multifasta file.
-   Specification of start and end positions of the sequences to be extracted.
-   Changing of sequence names and addition of comments.
-   Command-line interface.
-   Support for different input formats, including GFF, BED and TXT.

## :hammer: Usage

To use `gscissors`, follow these steps:

-   Clone the gscissors.pl file from the GitHub repository [Link](https://github.com/mathiashole/GScissors).
-   Open a terminal on your operating system and navigate to the folder where the gscissors.pl file is located.
-   Run the perl gscissors.pl command followed by the necessary arguments to execute the script. Required arguments include the input multifasta file, the start and end positions of the sequences to be extracted, and the output multifasta file.
-   Optionally, you can specify the input and output file formats, as well as change sequence names and add comments.

## :bulb: Quick Examples

```{bash, eval = FALSE}
./bin/gscissors -fasta input.fasta -txt position_of_my_sequence.txt output.fasta 
```
```{bash, eval = FALSE}
./bin/gscissors -fasta input.fasta -gff file.gff output.fasta 
```
```{bash, eval = FALSE}
./bin/gscissors -fasta input.fasta -bed file.bed output.fasta 
```
```{bash, eval = FALSE}
./bin/gscissors --help 
```
`GScissors` extracts the sequence of positions in the input.fasta file, renames it, and saves the resulting sequence in the output.fasta file.

## :sparkling_heart: Contributing

- :octocat: [Pull requests](https://github.com/mathiashole/GScissors/pulls) and :star2: stars are always welcome.
- For major changes, please open an [issue](https://github.com/mathiashole/GScissors/issues) first to discuss what you would like to change.
- Please make sure to update tests as appropriate.

## :mega: Contact

:mailbox: joacomangino@gmail.com

:heavy_multiplication_x: X [@MathiasMangino](https://twitter.com/joaquinmangino)

## License
MIT &copy; [Mathias Mangino](https://github.com/mathiashole)