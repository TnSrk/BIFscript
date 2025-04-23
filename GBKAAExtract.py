#!/usr/bin/env python3

import sys
from Bio import SeqIO

def extract_aa_to_fasta(input_file, output_file=None):
    """
    Extract amino acid sequences from a GenBank file and output in FASTA format.
    - input_file: Path to the GenBank (.gb) file.
    - output_file: Path to the output file (optional). If None, print to stdout.
    """
    try:
        # Read the GenBank file
        with open(input_file, "r") as gb_file:
            # Parse GenBank file
            for record in SeqIO.parse(gb_file, "genbank"):
                # Iterate through features in the record
                for feature in record.features:
                    # Only process CDS features with a translation
                    if feature.type == "CDS" and "translation" in feature.qualifiers:
                        # Get the amino acid sequence
                        aa_seq = feature.qualifiers["translation"][0]
                        # Get the locus_tag or protein_id for the FASTA header
                        gene_id = feature.qualifiers.get("locus_tag", ["unknown"])[0]
                        protein_id = feature.qualifiers.get("protein_id", [""])[0]
                        header = f"{gene_id}_{protein_id}" if protein_id else gene_id
                        # Create a FASTA-formatted string
                        fasta_record = f">{header}\n{aa_seq}\n"
                        
                        if output_file:
                            # Write to the specified output file
                            with open(output_file, "a") as out_file:
                                out_file.write(fasta_record)
                        else:
                            # Print to stdout
                            print(fasta_record, end="")
                            
    except FileNotFoundError:
        print(f"Error: Input file '{input_file}' not found.", file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(f"Error processing file: {str(e)}", file=sys.stderr)
        sys.exit(1)

def main():
    # Check command-line arguments
    if len(sys.argv) < 2 or len(sys.argv) > 3:
        print("Usage: python script.py <input_genbank_file.gb> [output_fasta_file]", file=sys.stderr)
        sys.exit(1)

    input_file = sys.argv[1]
    output_file = sys.argv[2] if len(sys.argv) == 3 else None

    # Extract amino acid sequences to FASTA
    extract_aa_to_fasta(input_file, output_file)

if __name__ == "__main__":
    main()
