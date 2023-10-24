#!/bin/bash

# QC for GWAS Summary Statistics

# Ask user to input the input file name
read -p "Enter the input file name: " input_filename

# Ask user to input the output file name
read -p "Enter the output file name: " output_filename

# Check if the input file exists
if [ ! -f "$input_filename" ]; then
  echo "Input file does not exist."
  exit 1
fi

gunzip -c "$input_filename" | \
  
  # Remove low quality MAF and INFO
  # $7 is MAF and $8 is INFO
  # awk 'NR==1 || ($7 > 0.01) && ($8 > 0.8) {print}' | \

  # no MAF and INFO, so filtering is not performed.

  # Remove duplicated SNPs
  # $4 is SNP ID
  # awk '{seen[$4]++; if(seen[$4]==1){ print}}' | \

  awk '{seen[$4]++; if(seen[$4]==1){ print}}' | \
  
  # Remove ambiguous SNPs
  # $5 is A1 and $6 is A2
  # awk '! (($5=="A" && $6=="T") || \
  #        ($5=="T" && $6=="A") || \
  #        ($5=="G" && $6=="C") || \
  #        ($5=="C" && $6=="G")) {print}' | \

  awk '! (($5=="A" && $6=="T") || \
         ($5=="T" && $6=="A") || \
         ($5=="G" && $6=="C") || \
         ($5=="C" && $6=="G")) {print}' | \

  gzip > "$output_filename"

echo "QC completed. Output saved to $output_filename"
