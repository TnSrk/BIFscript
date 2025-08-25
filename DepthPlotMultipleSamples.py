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
depth_data = pd.read_csv(sys.stdin, sep="\t", header=None)

# Assign column names: first two columns are chr and pos, rest are samples
depth_data.columns = ["chr", "pos"] + [f"sample_{i+1}" for i in range(depth_data.shape[1] - 2)]

# Create plot
plt.figure(figsize=(12, 6))

# Define colors for different samples
colors = ['blue', 'red', 'green', 'purple', 'orange', 'cyan', 'magenta', 'brown', 'lime']

# Plot each sample's depth
for i, sample in enumerate(depth_data.columns[2:]):  # Skip chr and pos columns
    plt.plot(depth_data["pos"], depth_data[sample], color=colors[i % len(colors)], label=sample)

plt.xlabel(f"Position on {depth_data['chr'][0]}")
plt.ylabel("Depth of Coverage")
plt.title(f"Depth Plot for {depth_data['chr'][0]} (Multiple Samples)")
plt.grid(True)
plt.legend()

# Save plot as SVG
plt.savefig(output_file, format="svg", bbox_inches="tight")
plt.close()
