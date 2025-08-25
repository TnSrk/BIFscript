import matplotlib.pyplot as plt
import pandas as pd
import sys
import os

# Check if stdin is empty
if sys.stdin.isatty():
	print("Error: No input provided via stdin. Pipe depth data to the script.")
	print("Usage: cat depth_file.txt | python plot_depth_stdin.py [output.svg]")
	sys.exit(1)

# Get output filename from command line argument or use default
output_file = sys.argv[1] if len(sys.argv) > 1 else "depth_plot.svg"

# Ensure output file has .svg extension
if not output_file.endswith(".svg"):
	output_file += ".svg"

# Read depth data from stdin
depth_data = pd.read_csv(sys.stdin, sep="\t", header=0)

# Use the column names from the input file
# First two columns are 'ContigNames' and 'Count', rest are sample names
sample_columns = depth_data.columns[2:]  # Get sample names (S1, S2, ..., S9)
depth_data.columns = ["chr", "pos"] + list(sample_columns)  # Rename columns for consistency

# Create plot
plt.figure(figsize=(12, 6))

# Define colors for different samples
colors = ['blue', 'red', 'green', 'purple', 'orange', 'cyan', 'magenta', 'brown', 'lime']

# Extract sample columns for stacking
depth_values = [depth_data[sample] for sample in sample_columns]

# Create stacked line plot (filled area plot)
plt.stackplot(depth_data["pos"], depth_values, labels=sample_columns, colors=colors[:len(sample_columns)], alpha=0.8)

plt.xlabel(f"Position on {depth_data['chr'][0]}")
plt.ylabel("Depth of Coverage (Stacked)")
plt.title(f"Stacked Depth Plot for {depth_data['chr'][0]} (Multiple Samples)")
plt.grid(True, alpha=0.3)
plt.legend(loc='upper right')

# Save plot as SVG
plt.savefig(output_file, format="svg", bbox_inches="tight")
plt.close()
