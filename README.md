# GScissors

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

## :runner: Author

-   [Mathias Mangino](https://github.com/mathiashole) Student

## :sparkling_heart: Contributing

We welcome any contributions! By participating in this project you agree
to abide by the terms outlined in the [Contributor Code of
Conduct](https://github.com/mathiashole).
