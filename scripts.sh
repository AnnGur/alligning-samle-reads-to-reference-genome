bash Miniforge3-Darwin-arm64.sh
export PATH="/Users/mac/Desktop/genome/STAR-2.7.11b/bin/MacOSX_x86_64:$PATH"
conda install -c conda-forge liblzma=5.8.1
conda install -c bioconda samtools=1.22.1 
conda install -c bioconda perl
conda install -c conda-forge gnuplot
# conda install -c conda-forge r-rcpparmadillo
# conda install -c bioconda bioconductor-deseq2

# STAR --runThreadN 8 --runMode genomeGenerate \
#   --genomeDir star_mm10 \
#   --genomeFastaFiles mm10.fa \
#   --sjdbGTFfile gencode.vM38.annotation.gtf \
#   --sjdbOverhang 100


# gencode.v49.chr_patch_hapl_scaff.annotation.gtf
# gencode.v38.chr_patch_hapl_scaff.annotation.gtf
# gencode.v38.primary_assembly.annotation.gtf

extract_splice_sites.py gencode.v49.chr_patch_hapl_scaff.annotation.gtf > gencode.v49.splice_sites.txt
extract_exons.py gencode.v49.chr_patch_hapl_scaff.annotation.gtf > gencode.v49.exon_sites.txt


################# HUMAN
hisat2-build GCA_000001405.29_GRCh38.p14_genomic.fna hg38_hisat2_index

hisat2 -p 8 --dta -x 29_GRCh38_index \
  --known-splicesite-infile gencode.v49.splice_sites.txt \
  -1 reads_1.fq.gz -2 reads_2.fq.gz \
  --summary-file 29_GRCh38_summary_with_splicesites_v49.txt \
  | samtools view -@ 8 -b \
  | samtools sort -@ 8 -o 29_GRCh38_Test_Aligned.sortedByChrPosition.bam


featureCounts -T 8 -p -t exon -g gene_id \
  -a gencode.vM38.annotation.gtf \
  -o 27_GRCm39_featureCounts.txt 27_GRCm39_Test_Aligned.sortedByChrPosition.bam

samtools index hg38_Test_Aligned.sortedByChrPosition.bam

################# MOUSE 
hisat2-build mm10.fa mm10_hisat2_index

## --dta : reports alignments tailored for transcript assemblers
## -@ 8 - threads
## samtools -b - BAM output
## samtools -q 30 - min mapping quality

# sorting by chromosomes positions
hisat2 -p 8 --dta -x mm10_hisat2_index\
  -x mm10_hisat2_index -1 reads_1.fq.gz -2 reads_2.fq.gz \
  --summary-file hisat2_m10_summary_without_splicesites.txt \
  | samtools view -@ 8 -b \
  | samtools sort -@ 8 -o mm10_Test_Aligned.sortedByChrPosition.bam

# 93.75% overall alignment rate (+1 ) +1 aligned >1 times when --known-splicesite-infile gencode.vM38.splice_sites.txt 
hisat2 -p 8 --dta -x mm10_hisat2_index \
  --known-splicesite-infile gencode.vM38.splice_sites.txt \
  --summary-file hisat2_m10_summary_with_splicesites.txt \
  | samtools view -@ 8 -b \
  | samtools sort -@ 8 -o mm10_Test_Aligned.sortedByChrPosition.bam

# index .bam for further processing
samtools index mm10_Test_Aligned.sortedByChrPosition.bam

## samtools QC
# is well-formed and not truncated or corrupted.
# contains a valid header
# has proper indexing (if required by downstream processes)
samtools quickcheck -v mm10_Test_Aligned.sortedByChrPosition.bam
samtools flagstat mm10_Test_Aligned.sortedByChrPosition.bam > mm10_flagstat_summary.txt
samtools stats mm10_Test_Aligned.sortedByChrPosition.bam > mm10_Test_Aligned.stats.txt
plot-bamstats -p plots/ mm10_Test_Aligned.stats.txt

featureCounts -T 8 -p -t exon -g gene_id \
  -a gencode.vM38.annotation.gtf \
  -o mm10_featureCounts.txt mm10_Test_Aligned.sortedByChrPosition.bam
