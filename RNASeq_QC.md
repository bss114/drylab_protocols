# For QC of RNASeq data and creation of MultiQC report. This can be run locally.

	#!/bin/bash

# on the command line, set your working directory, need to change to correct path

	cd /Users/bss114/Documents/Colon_extractions/2026Feb_RNASeq_fastq/

# check to make sure your files are there

	ls

# create output directories, this script will separate NTC from samples

	mkdir -p trimmed

	mkdir -p fastp_reports

	mkdir -p trimmed_NTC

	mkdir -p fastp_reports_NTC

# set up environment

	conda activate rnaseq
	fastp

# Loop over all read files


	for sample in *_R1_001.fastq.gz

	do

	base=$(basename ${sample} _R1_001.fastq.gz)

	if [[ "$base" == *NTC* ]]; then

		OUT_R1="trimmed_NTC/${base}_R1.trimmed.fastq.gz"

		OUT_R2="trimmed_NTC/${base}_R2.trimmed.fastq.gz"

		HTML_REPORT="fastp_reports_NTC/${base}.html"

		JSON_REPORT="fastp_reports_NTC/${base}.json"

	else

		OUT_R1="trimmed/${base}_R1.trimmed.fastq.gz"

		OUT_R2="trimmed/${base}_R2.trimmed.fastq.gz"

		HTML_REPORT="fastp_reports/${base}.html"

		JSON_REPORT="fastp_reports/${base}.json"

	fi

	echo "Trimming adapters for sample $base ..."

	fastp \

		-i ${base}_R1_001.fastq.gz \

		-I ${base}_R2_001.fastq.gz \

		-o "$OUT_R1" \

		-O "$OUT_R2" \

		-h "$HTML_REPORT" \

		-j "$JSON_REPORT" \

		--adapter_sequence AGATCGGAAGAGCACACGTCTGAACTCCAGTCA \

		--adapter_sequence_r2 AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT \

		--trim_poly_g \

		--trim_poly_x \

		--length_required 25

	done

# Run MultiQC to generate reports, need to change title for report name

	multiqc fastp_reports -o multiqc_report_samples --title Feb_2026_Samples

	multiqc fastp_reports_NTC -o multiqc_report_NTC --title Feb_2026_NTCs
<!--stackedit_data:
eyJoaXN0b3J5IjpbLTE1MDM5NTY0MjRdfQ==
-->