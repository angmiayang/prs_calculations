#!/bin/bash

# Unzip the GWAS Summary Statistics

gunzip -c BMI_GWAS_QC.txt.gz > BMI_GWAS_QC.txt


# --clump-p1 This option specifies the significance threshold for clumping. Variants with a p-value less than or equal to 1 will be considered as initial seeds for clumping.
# --clump-r2 This option specifies the LD (linkage disequilibrium) threshold for clumping. Variants in LD with an initial seed variant (r^2 greater than or equal to 0.1) will be clumped together.
# --clump-kb This option specifies the physical distance threshold for clumping in kilobases (kb). Variants within 250 kb of an initial seed variant will be considered for clumping.
# --clump This specifies the summary statistics for a GWAS. 
# --clump-snp-field This option specifies the field in the GWAS summary statistics file that contains the SNP IDs.
# --clump-field This option specifies the field in the GWAS summary statistics file that contains the p-values.

../plink \
    --bfile SLK.QC \
    --clump-p1 1 \
    --clump-r2 0.1 \
    --clump-kb 250 \
    --clump BMI_GWAS_QC.txt \
    --clump-snp-field SNP \
    --clump-field P \
    --out SLK


# Extract index SNP

awk 'NR!=1{print $3}' SLK.clumped > SLK.valid.snp


# Extract SNP and p-value from GWAS summary statistics
    # 4 SNP ID
    # 10 P

awk '{print $4,$10}' BMI_GWAS_QC.txt > SNP.pvalue


# Generate range_list file

echo "0.001 0 0.001" >> range_list 
echo "0.005 0 0.005" >> range_list 
echo "0.01 0 0.01" >> range_list
echo "0.05 0 0.05" >> range_list
echo "0.1 0 0.1" >> range_list
echo "0.2 0 0.2" >> range_list
echo "0.3 0 0.3" >> range_list
echo "0.4 0 0.4" >> range_list
echo "0.5 0 0.5" >> range_list


# --score This option tells Plink to perform a scoring operation using external scores from the file Height.QC.Transformed. 
    # 4 SNP ID
    # 5 effect allele
    # 8 BETA
    # The header keyword indicates that the first row of the external score file contains column headers.
# --q-score-range This option specifies the columns in the external score file to use as the range list and SNP p-value list for the scoring operation. 
# --extract This option specifies a list of variants to extract from the dataset. 

../plink \
    --bfile SLK.QC \
    --score BMI_GWAS_QC.txt 4 5 8 header \
    --q-score-range range_list SNP.pvalue \
    --extract SLK.valid.snp \
    --out SLK


# --indep-pairwise Instructs Plink to perform LD-based variant pruning. Specifically:
    # 200: Specifies the window size (in kilobases) for variants to be considered in LD calculations.
    # 50: Specifies the step size (in variants) for moving the sliding window.
    # 0.8: Sets the LD threshold (r^2) for variants to be considered in LD with each other. Variants with an r^2 greater than or equal to 0.25 will be pruned.

../plink \
    --bfile SLK.QC \
    --indep-pairwise 200 50 0.8 \
    --out SLK


# --extract Specifies a list of variants to extract from the dataset.
# --pca Perform Principal Component Analysis (PCA) and calculate the first 6 principal components.

../plink \
    --bfile SLK.QC \
    --extract SLK.prune.in \
    --pca 6 \
    --out SLK

