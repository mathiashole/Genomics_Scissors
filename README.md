# GScissors

[![Perl](https://img.shields.io/badge/Perl-blue?style=for-the-badge&logo=perl&logoColor=white&labelColor=101010)](https://www.perl.org)
![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/mathiashole/GScissors?logo=GitHub&style=for-the-badge)

`GScissors` is a Perl script for the extraction of sequences from a multifasta file, allowing the selection of specific sequences by specifying their start and end positions.

## :book: Features

-   Extraction of sequences from a multifasta file.
-   Specification of start and end positions of the sequences to be extracted.
-   Changing of sequence names and addition of comments.
-   Command-line interface.
-   Support for different input and output file formats, including FASTA, FASTQ, and GenBank.

## :hammer: Usage

To use `GScissors`, follow these steps:

-   Clone the gscissors.pl file from the GitHub repository [Link](https://github.com/mathiashole/GScissors).
-   Open a terminal on your operating system and navigate to the folder where the gscissors.pl file is located.
-   Run the perl gscissors.pl command followed by the necessary arguments to execute the script. Required arguments include the input multifasta file, the start and end positions of the sequences to be extracted, and the output multifasta file.
-   Optionally, you can specify the input and output file formats, as well as change sequence names and add comments.

## :bulb: Quick Example

```{bash, eval = FALSE}
perl gscissors.pl input.fasta position_of_my_sequence.txt output.fasta 
```
This command extracts the sequence from positions in the input.fasta file, changes its name to my_sequence and adds the comment This is my sequence, and saves the resulting sequence in the output.fasta file.

## :sparkling_heart: Contributing

- :octocat: [Pull requests](https://github.com/mathiashole/GScissors/pulls) and :star2: stars are always welcome.
- For major changes, please open an [issue](https://github.com/mathiashole/GScissors/issues) first to discuss what you would like to change.
- Please make sure to update tests as appropriate.

## :mega: Contact

:mailbox: joacomangino@gmail.com

:bird: Twitter [@JoaquinMangino](https://twitter.com/joaquinmangino)

## License
MIT &copy; [Mathias Mangino](https://github.com/mathiashole)