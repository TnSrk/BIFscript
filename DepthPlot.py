import matplotlib.pyplot as plt
import pandas as pd
import sys
import os

# Check if filename is provided as argument
if len(sys.argv) != 2:
    print("Usage: python plot_depth.py <depth_file>")
    sys.exit(1)

# Get input filename from command line argument
depth_file = sys.argv[1]

# Load depth data
depth_data = pd.read_csv(depth_file, sep="\t", header=None, names=["chr", "pos", "depth"])

# Create output filename for SVG (replace .txt with .svg)
output_file = os.path.splitext(depth_file)[0] + ".svg"

# Create plot
plt.figure(figsize=(10, 6))
plt.plot(depth_data["pos"], depth_data["depth"], color="blue")
plt.xlabel(f"Position on {depth_data['chr'][0]}")
plt.ylabel("Depth of Coverage")
plt.title(f"Depth Plot for {depth_data['chr'][0]}")
plt.grid(True)

# Save plot as SVG
plt.savefig(output_file, format="svg", bbox_inches="tight")
plt.close()
