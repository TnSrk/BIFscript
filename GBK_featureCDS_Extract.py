#!/usr/bin/env python3

import sys
from Bio import SeqIO

def extract_nucleotide_to_fasta(input_file, output_file=None):
    """
    Extract nucleotide sequences for each feature from a GenBank file and output in FASTA format.
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
                    # Skip features without a defined location
                    if feature.location:
                        # Extract the nucleotide sequence for the feature
                        nucleotide_seq = feature.extract(record.seq)
                        # Get feature type and qualifiers for the FASTA header
                        feature_type = feature.type
                        feature_id = feature.qualifiers.get("locus_tag", ["unknown"])[0]
                        product = feature.qualifiers.get("product", [""])[0]
                        gene = feature.qualifiers.get("gene", [""])[0]
                        # Construct a meaningful header
                        header_parts = [feature_id]
                        if gene:
                            header_parts.append(f"gene:{gene}")
                        if product:
                            header_parts.append(f"product:{product}")
                        header = f"{feature_type}_{'_'.join(header_parts)}"
                        # Create a FASTA-formatted string
                        fasta_record = f">{header}\n{nucleotide_seq}\n"
                        
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

    # Extract nucleotide sequences to FASTA
    extract_nucleotide_to_fasta(input_file, output_file)

if __name__ == "__main__":
    main()
