import csv
import sys

def distmat_to_csv(input_stream):
    # Read from input stream (file or stdin)
    lines = input_stream.readlines()

    # Filter out header lines and empty lines, keeping only the matrix data
    matrix_lines = [line for line in lines if line.strip() and not line.startswith(('Distance Matrix', '-', 'Using', 'Gap'))]

    # Extract sequence names and distances
    sequence_names = []
    distances = []
    for line in matrix_lines:
        # Split by tabs and filter out empty strings
        parts = [x for x in line.split('\t') if x.strip()]
        # Last element is the sequence name (after removing trailing numbers and newline)
        seq_name = parts[-1].strip().split()[0]
        sequence_names.append(seq_name)
        # Convert distance values to floats (excluding the sequence name)
        dist_row = [float(x) for x in parts[:-1]]
        distances.append(dist_row)

    # Construct a full square matrix (since input is lower triangular)
    n = len(sequence_names)
    full_matrix = [[0.0] * n for _ in range(n)]
    for i in range(n):
        for j in range(len(distances[i])):
            full_matrix[i][j] = distances[i][j]
            full_matrix[j][i] = distances[i][j]  # Symmetric fill for upper triangle

    # Write to stdout using csv writer
    writer = csv.writer(sys.stdout, lineterminator='\n')
    # Write header row (empty first cell + sequence names)
    writer.writerow([''] + sequence_names)
    # Write each row with sequence name as first column
    for i, row in enumerate(full_matrix):
        writer.writerow([sequence_names[i]] + row)

# Handle input from file or stdin
if __name__ == "__main__":
    if len(sys.argv) > 1:
        # If a file is provided as an argument, read from it
        with open(sys.argv[1], 'r') as f:
            distmat_to_csv(f)
    else:
        # Otherwise, read from stdin
        distmat_to_csv(sys.stdin)
