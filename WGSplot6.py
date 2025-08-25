import sys
import matplotlib.pyplot as plt

def read_blast_results(blast_file):
	"""Read BLAST result file and return list of alignments."""
	alignments = []
	try:
		with open(blast_file, 'r') as f:
			for line in f:
				fields = line.strip().split('\t')
				if len(fields) >= 12:  # Ensure valid BLAST tabular format
					qseqid, sseqid = fields[0], fields[1]
					qstart, qend = int(fields[6]), int(fields[7])
					sstart, send = int(fields[8]), int(fields[9])
					alignments.append({
						'qseqid': qseqid,
						'sseqid': sseqid,
						'qstart': qstart,
						'qend': qend,
						'sstart': sstart,
						'send': send
					})
	except FileNotFoundError:
		print(f"Error: {blast_file} not found")
		sys.exit(1)
	except ValueError:
		print("Error: Invalid format in BLAST file")
		sys.exit(1)
	return alignments

def read_seq_metadata(metadata_file):
	"""Read sequence metadata file and return dictionary of sequence lengths."""
	seq_lengths = {}
	try:
		with open(metadata_file, 'r') as f:
			for line in f:
				fields = line.strip().split('\t')
				if len(fields) == 2:
					seq_lengths[fields[0]] = int(fields[1])
	except FileNotFoundError:
		print(f"Error: {metadata_file} not found")
		sys.exit(1)
	except ValueError:
		print("Error: Invalid format in metadata file")
		sys.exit(1)
	return seq_lengths

def plot_genome_links(blast_file, metadata_file):
	"""Create a plot showing links between two genomes with the first query sequence on a separate track, unique sequence bars, highlighted matched regions, varied linker lines, and sequence labels."""
	# Read input files
	alignments = read_blast_results(blast_file)
	seq_lengths = read_seq_metadata(metadata_file)

	# Get unique query and subject sequences from BLAST results
	query_seqs_in_blast = set(align['qseqid'] for align in alignments)
	subject_seqs_in_blast = set(align['sseqid'] for align in alignments)

	# Filter sequences to those present in both metadata and BLAST results
	query_seqs = [seq for seq in seq_lengths if seq in query_seqs_in_blast]
	subject_seqs = [seq for seq in seq_lengths if seq in subject_seqs_in_blast]

	# Identify the first query sequence
	first_query_seq = alignments[0]['qseqid'] if alignments else None

	# Create figure and axis
	fig, ax = plt.subplots(figsize=(10, 8))

	# Define lists for colors and line styles
	colors = ['green', 'purple', 'orange', 'cyan', 'magenta', 'yellow', 'lime', 'pink', 'teal', 'brown']
	linestyles = ['-', '--', ':', '-.']

	# Plot genome bars
	y_offset = 0.5
	query_positions = {}
	subject_positions = {}

	# Plot query genome (top) - base bars with labels
	current_pos = 0
	for seq in query_seqs:
		length = seq_lengths[seq]
		# Place the first query sequence on a separate track
		if seq == first_query_seq:
			y_pos = y_offset + 2
			label_y = y_offset + 2.1
		else:
			y_pos = y_offset + 1
			label_y = y_offset + 1.1
		ax.hlines(y_pos, current_pos, current_pos + length, color='blue', linewidth=2, alpha=0.3)
		# Add sequence name label near the start of the bar
		ax.text(current_pos, label_y, seq, fontsize=8, verticalalignment='bottom', horizontalalignment='left')
		query_positions[seq] = (current_pos, y_pos)
		current_pos += length + 1000  # Add gap between sequences

	# Plot subject genome (bottom) - base bars with labels
	current_pos = 0
	for seq in subject_seqs:
		length = seq_lengths[seq]
		ax.hlines(y_offset, current_pos, current_pos + length, color='red', linewidth=2, alpha=0.3)
		# Add sequence name label near the start of the bar
		ax.text(current_pos, y_offset - 0.1, seq, fontsize=8, verticalalignment='top', horizontalalignment='left')
		subject_positions[seq] = current_pos
		current_pos += length + 1000

	# Highlight matched regions and plot links with different colors and styles
	for i, align in enumerate(alignments):
		qseq, sseq = align['qseqid'], align['sseqid']
		if qseq in query_positions and sseq in subject_positions:
			qstart = query_positions[qseq][0] + align['qstart']
			qend = query_positions[qseq][0] + align['qend']
			q_y_pos = query_positions[qseq][1]  # Get the y-position for this query sequence
			sstart = subject_positions[sseq] + align['sstart']
			send = subject_positions[sseq] + align['send']
			
			# Highlight matched regions on query genome
			ax.hlines(q_y_pos, qstart, qend, color='blue', linewidth=4, capstyle='butt')
			
			# Highlight matched regions on subject genome
			ax.hlines(y_offset, sstart, send, color='red', linewidth=4, capstyle='butt')
			
			# Choose color and linestyle for linker lines (cycle through lists)
			link_color = colors[i % len(colors)]
			link_style = linestyles[i % len(linestyles)]
			
			# Draw curved links
			x = [qstart, (qstart + sstart) / 2, sstart]
			y = [q_y_pos, (q_y_pos + y_offset) / 2, y_offset]
			ax.plot(x, y, color=link_color, linestyle=link_style, alpha=0.7)
			
			x = [qend, (qend + send) / 2, send]
			y = [q_y_pos, (q_y_pos + y_offset) / 2, y_offset]
			ax.plot(x, y, color=link_color, linestyle=link_style, alpha=0.7)

	# Customize plot
	ax.set_ylim(-0.2, 3.2)  # Adjusted to accommodate the new track and labels
	ax.set_xlabel('Genomic Position')
	ax.set_yticks([y_offset, y_offset + 1, y_offset + 2])
	ax.set_yticklabels(['Subject Genome', 'Other Query Sequences', 'First Query Sequence'])
	plt.title('Synteny Plot: Query vs Subject Genome')
	
	# Remove top and right spines
	ax.spines['top'].set_visible(False)
	ax.spines['right'].set_visible(False)
	
	plt.tight_layout()
	plt.show()

def main():
	if len(sys.argv) != 3:
		print("Usage: python script.py BlastResult.tab SeqMetadata.tab")
		sys.exit(1)
	
	blast_file = sys.argv[1]
	metadata_file = sys.argv[2]
	plot_genome_links(blast_file, metadata_file)

if __name__ == "__main__":
	main()
