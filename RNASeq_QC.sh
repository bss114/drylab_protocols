#!/bin/bash

# RNA-seq QC and trimming pipeline
# Author: Bethany Swencki-Underwood
# Date: Feb 2026

# assumes your negative controls contain "NTC" in their filenames

echo "Creating output directories..."
mkdir -p trimmed
mkdir -p fastp_reports
mkdir -p multiqc_samples
mkdir -p multiqc_NTC

echo "Starting trimming with fastp..."

for sample in *_R1_001.fastq.gz
do
    base=$(basename ${sample} _R1_001.fastq.gz)

    echo "Processing ${base}..."

    fastp \
        -i ${base}_R1_001.fastq.gz \
        -I ${base}_R2_001.fastq.gz \
        -o trimmed/${base}_R1.trimmed.fastq.gz \
        -O trimmed/${base}_R2.trimmed.fastq.gz \
        -h fastp_reports/${base}.html \
        -j fastp_reports/${base}.json \
        --adapter_sequence AGATCGGAAGAGCACACGTCTGAACTCCAGTCA \
        --adapter_sequence_r2 AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT \
        --trim_poly_g \
        --trim_poly_x \
        --length_required 25

done

echo "Running MultiQC for NON-NTC samples..."
multiqc fastp_reports \
    --exclude "*NTC*" \
    -o multiqc_samples \
    -n RNASeq_fastp_samples

echo "Running MultiQC for NTC samples..."
multiqc fastp_reports \
    --include "*NTC*" \
    -o multiqc_NTC \
    -n RNASeq_fastp_NTC

echo "Finished!"
