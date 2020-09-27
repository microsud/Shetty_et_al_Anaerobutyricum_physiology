#!/bin/bash

INPUT_DIR="/path/to/project/projects/sim_com/"

conda create --name rnaseq_v1
source activate rnaseq_v1
#conda install -c bioconda diamond
conda install -c bioconda bowtie2
conda install -c bioconda fastqc
conda install -c bioconda htseq python=3.6
conda install -c bioconda trimmomatic pear
#conda install -c bioconda pear
conda install -c conda-forge pigz
#conda install -c bioconda trim-galore

mkdir ena
cd ena
wget ftp.sra.ebi.ac.uk/vol1/fastq/ERR213/005/ERR2134135/ERR2134135_1.fastq.gz
wget ftp.sra.ebi.ac.uk/vol1/fastq/ERR213/005/ERR2134135/ERR2134135_2.fastq.gz
wget ftp.sra.ebi.ac.uk/vol1/fastq/ERR213/006/ERR2134136/ERR2134136_1.fastq.gz
wget ftp.sra.ebi.ac.uk/vol1/fastq/ERR213/006/ERR2134136/ERR2134136_2.fastq.gz
wget ftp.sra.ebi.ac.uk/vol1/fastq/ERR213/007/ERR2134137/ERR2134137_1.fastq.gz
wget ftp.sra.ebi.ac.uk/vol1/fastq/ERR213/007/ERR2134137/ERR2134137_2.fastq.gz
wget ftp.sra.ebi.ac.uk/vol1/fastq/ERR213/008/ERR2134138/ERR2134138_1.fastq.gz
wget ftp.sra.ebi.ac.uk/vol1/fastq/ERR213/008/ERR2134138/ERR2134138_2.fastq.gz
wget ftp.sra.ebi.ac.uk/vol1/fastq/ERR213/009/ERR2134139/ERR2134139_1.fastq.gz
wget ftp.sra.ebi.ac.uk/vol1/fastq/ERR213/009/ERR2134139/ERR2134139_2.fastq.gz
wget ftp.sra.ebi.ac.uk/vol1/fastq/ERR213/000/ERR2134140/ERR2134140_1.fastq.gz
wget ftp.sra.ebi.ac.uk/vol1/fastq/ERR213/000/ERR2134140/ERR2134140_2.fastq.gz
wget ftp.sra.ebi.ac.uk/vol1/fastq/ERR213/001/ERR2134141/ERR2134141_1.fastq.gz
wget ftp.sra.ebi.ac.uk/vol1/fastq/ERR213/001/ERR2134141/ERR2134141_2.fastq.gz
wget ftp.sra.ebi.ac.uk/vol1/fastq/ERR213/002/ERR2134142/ERR2134142_1.fastq.gz
wget ftp.sra.ebi.ac.uk/vol1/fastq/ERR213/002/ERR2134142/ERR2134142_2.fastq.gz
wget ftp.sra.ebi.ac.uk/vol1/fastq/ERR213/003/ERR2134143/ERR2134143_1.fastq.gz
wget ftp.sra.ebi.ac.uk/vol1/fastq/ERR213/003/ERR2134143/ERR2134143_2.fastq.gz
wget ftp.sra.ebi.ac.uk/vol1/fastq/ERR213/004/ERR2134144/ERR2134144_1.fastq.gz
wget ftp.sra.ebi.ac.uk/vol1/fastq/ERR213/004/ERR2134144/ERR2134144_2.fastq.gz
wget ftp.sra.ebi.ac.uk/vol1/fastq/ERR213/005/ERR2134145/ERR2134145_1.fastq.gz
wget ftp.sra.ebi.ac.uk/vol1/fastq/ERR213/005/ERR2134145/ERR2134145_2.fastq.gz
wget ftp.sra.ebi.ac.uk/vol1/fastq/ERR213/006/ERR2134146/ERR2134146_1.fastq.gz
wget ftp.sra.ebi.ac.uk/vol1/fastq/ERR213/006/ERR2134146/ERR2134146_2.fastq.gz
wget ftp.sra.ebi.ac.uk/vol1/fastq/ERR213/007/ERR2134147/ERR2134147_1.fastq.gz
wget ftp.sra.ebi.ac.uk/vol1/fastq/ERR213/007/ERR2134147/ERR2134147_2.fastq.gz
wget ftp.sra.ebi.ac.uk/vol1/fastq/ERR213/008/ERR2134148/ERR2134148_1.fastq.gz
wget ftp.sra.ebi.ac.uk/vol1/fastq/ERR213/008/ERR2134148/ERR2134148_2.fastq.gz
wget ftp.sra.ebi.ac.uk/vol1/fastq/ERR213/009/ERR2134149/ERR2134149_1.fastq.gz
wget ftp.sra.ebi.ac.uk/vol1/fastq/ERR213/009/ERR2134149/ERR2134149_2.fastq.gz

cd ..
mkdir asoe
cd asoe
# Genome of A. soehngenii
#https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/900/209/925/GCA_900209925.1_EH1/
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/900/209/925/GCA_900209925.1_EH1/GCA_900209925.1_EH1_translated_cds.faa.gz
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/900/209/925/GCA_900209925.1_EH1/GCA_900209925.1_EH1_cds_from_genomic.fna.gz
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/900/209/925/GCA_900209925.1_EH1/GCA_900209925.1_EH1_genomic.fna.gz
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/900/209/925/GCA_900209925.1_EH1/GCA_900209925.1_EH1_genomic.gtf.gz

# https://mmg434.readthedocs.io/en/latest/daythreemod.html

cd ..
conda install -c bioconda gffread 
gffread $INPUT_DIR/asoe/GCA_900209925_1_EH1_genomic.gff -T -o $INPUT_DIR/asoe/EH1_genomic.gff.gtf


mkdir -p asoe/bowtieDB
# build bw index
bowtie2-build $INPUT_DIR/asoe/GCA_900209925.1_EH1_genomic.fna $INPUT_DIR/asoe/bowtieDB/asoe

####################################################################################################
# STEP 1a - unzip .gz files
####################################################################################################

# unzip files
#INPUT_DIR="/path/to/project/projects/sim_com"
echo "Bash script decompression"
mkdir -p $INPUT_DIR/logs/
unpigz $INPUT_DIR/ena/*.fastq.gz --keep -p 9
mkdir -p $INPUT_DIR/raw_compressed
mv $INPUT_DIR/ena/*.fastq.gz $INPUT_DIR/raw_compressed/

echo "STEP 1a Decompressed raw .gz files moved to $INPUT_DIR/raw_compressed "
echo "STEP 1a Decompression test finished "

# move the raw uncompressed fastq file to storage
#mkdir -p $INPUT_DIR/raw_uncompressed
#mv $INPUT_DIR/ena/*.fastq $INPUT_DIR/raw_uncompressed/

####################################################################################################
# STEP 1c - Trim raw files
#
####################################################################################################
# make directory to store trimmomatic output
mkdir -p $INPUT_DIR/trimmed
mkdir -p $INPUT_DIR/untrimmed
#
for infile in $INPUT_DIR/*_1.fastq
do
  base=$(basename ${infile} _1.fastq)
  trimmomatic PE ${infile} $INPUT_DIR/${base}_2.fastq \
               $INPUT_DIR/trimmed/${base}_1.trim.fastq \
			   $INPUT_DIR/untrimmed/${base}_1un.trim.fastq \
               $INPUT_DIR/trimmed/${base}_2.trim.fastq \
			   $INPUT_DIR/untrimmed/${base}_2un.trim.fastq \
               SLIDINGWINDOW:4:20 MINLEN:70 -threads 6 \
			   HEADCROP:20
done

####################################################################################################
# STEP 1f - BOWTIE mapping
#	Dependencies:	bowtie2
#				
####################################################################################################

mkdir -p $INPUT_DIR/bowtie_out
# BOWTIE2
for reads in $INPUT_DIR/trimmed/*_1.trim.fastq.gz
do
	base=$(basename ${reads} _1.trim.fastq.gz)
	bowtie2 -x $INPUT_DIR/asoe/bowtieDB/asoe \
	-1 ${reads} -2 $INPUT_DIR/trimmed/${base}_2.trim.fastq.gz \
	-p 6 --very-sensitive -S $INPUT_DIR/bowtie_out/*${base}_aligned.sam

done

####################################################################################################
# STEP 1f - htseq counts from mapping
#	Dependencies:	htseq
#				
####################################################################################################

mkdir -p $INPUT_DIR/htseq_out
for samf in $INPUT_DIR/bowtie_out/*.sam
do 
	base=$(basename ${samf} .sam)
	htseq-count --type=CDS ${samf} --idattr=transcript_id  \
	$INPUT_DIR/asoe/EH1_genomic.gff.gtf > $INPUT_DIR/htseq_out/${base}_map.sam
done


# bsub -q bio -n 10 -o out_STEP_01.txt -e err_STEP_01.txt ./rna_seq_workflow.sh
