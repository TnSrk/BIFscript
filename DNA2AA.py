#!/usr/bin/env python3

import sys

# Codon table for translation
CODON_TABLE = {
    'TTT': 'F', 'TTC': 'F', 'TTA': 'L', 'TTG': 'L',
    'TCT': 'S', 'TCC': 'S', 'TCA': 'S', 'TCG': 'S',
    'TAT': 'Y', 'TAC': 'Y', 'TAA': '*', 'TAG': '*',
    'TGT': 'C', 'TGC': 'C', 'TGA': '*', 'TGG': 'W',
    'CTT': 'L', 'CTC': 'L', 'CTA': 'L', 'CTG': 'L',
    'CCT': 'P', 'CCC': 'P', 'CCA': 'P', 'CCG': 'P',
    'CAT': 'H', 'CAC': 'H', 'CAA': 'Q', 'CAG': 'Q',
    'CGT': 'R', 'CGC': 'R', 'CGA': 'R', 'CGG': 'R',
    'ATT': 'I', 'ATC': 'I', 'ATA': 'I', 'ATG': 'M',
    'ACT': 'T', 'ACC': 'T', 'ACA': 'T', 'ACG': 'T',
    'AAT': 'N', 'AAC': 'N', 'AAA': 'K', 'AAG': 'K',
    'AGT': 'S', 'AGC': 'S', 'AGA': 'R', 'AGG': 'R',
    'GTT': 'V', 'GTC': 'V', 'GTA': 'V', 'GTG': 'V',
    'GCT': 'A', 'GCC': 'A', 'GCA': 'A', 'GCG': 'A',
    'GAT': 'D', 'GAC': 'D', 'GAA': 'E', 'GAG': 'E',
    'GGT': 'G', 'GGC': 'G', 'GGA': 'G', 'GGG': 'G'
}

def translate_dna(dna_seq):
    """Translate DNA sequence to amino acid sequence"""
    # Remove any whitespace and convert to uppercase
    dna_seq = dna_seq.strip().upper()
    
    # Check if sequence length is divisible by 3
    if len(dna_seq) % 3 != 0:
        print("Warning: DNA sequence length is not divisible by 3", file=sys.stderr)
    
    # Translate codons to amino acids
    protein = ""
    for i in range(0, len(dna_seq) - 2, 3):
        codon = dna_seq[i:i+3]
        if codon in CODON_TABLE:
            protein += CODON_TABLE[codon]
        else:
            protein += 'X'  # Unknown codon
            print(f"Warning: Unknown codon {codon} found", file=sys.stderr)
    
    return protein

def main():
    # Read from stdin
    if not sys.stdin.isatty():  # Check if input is piped
        dna_sequence = sys.stdin.read()
    else:
        print("Please provide a DNA sequence through stdin (e.g., echo 'ATGGCC' | python script.py)")
        sys.exit(1)
    
    if not dna_sequence:
        print("Error: No DNA sequence provided", file=sys.stderr)
        sys.exit(1)
    
    # Translate and print result
    protein_sequence = translate_dna(dna_sequence)
    print(protein_sequence)

if __name__ == "__main__":
    main()
