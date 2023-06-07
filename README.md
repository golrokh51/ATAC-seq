# ATAC-seq
<h2 id="tools">Tools</h2>
  <h4 id="fastqc"><a href="#fastqc">FastQC</a>, <code>fastqc/0.11.9</code></h4>
  <h4 id="multiqc"><a href="#multiqc">MultiQC</a>, <code>MultiQC/1.14</code></h4>
  <h4 id="trimmomatic"><a href="#trim">Trimmomatic</a>, <code>trimmomatic/0.39</code></h4>
  <h4 id="aligner"><a href="#align">Bowtie2</a>, <code>bowtie2/2.4.4</code></h4>
  <h4 id="samtools"><a href="#samstat">Samtools</a>, <code>samtools/1.16.1</code></h4>
  <h4 id="sambamba"><a href="#sambamba-markdup">Sambamba</a>, <code>sambamba/0.8.0</code></h4>
  <h4 id="macs2"><a href="#macs2">MACS2</a>, <code>macs2/2.2.7.1</code></h4>
  
<h2 id="steps">Steps</h2>
<p id="note">
This pipeline is based on <a href="https://github.com/harvardinformatics/ATAC-seq#peak">ATAC-seq tutorial</a>:
</p>
<h3 id="qcseq">Sequencing QC</h3>
  <h4 id="fastqc">FastQC</h4>
  <ul>
  <li>file name: <code>template_fqc.sh</code></li>
  <li>commande: <code>fastqc -o ../results/_fastqc2/ --dir ../results/_TMP -f fastq  $f1</code></li>
  </ul>
  <h4 id="multiqc">MultiQC</h4>
  <ul>
  <li>file name: <code>template_mqc.sh</code></li>
  <li>commande: <code>multiqc --outdir ../results/_fastqc ../results/_fastqc </code></li>
  </ul>
  <h4 id="trim">Trimming</h4>
  <ul>
      <li>file name: <code>template_trimmomatic.sh</code></li>
      <li>options: </li>
      <ul>
          <li> <code>ILLUMINACLIP:sequencing-adapters.fa:2:30:5</code></li>
          <li> <code>SLIDINGWINDOW:5:20</code></li>
          <li> <code>HEADCROP:10</code></li>
          <li> <code>MINLEN:16</code></li>
        </ul>
      <li>commande: <code> java -jar -Xmx8g $EBROOTTRIMMOMATIC/trimmomatic-0.39.jar PE  -threads 40 -trimlog $logfile  $f1 $f2 $fwP $fwU $rvP $rvU ILLUMINACLIP:sequencing-adapters.fa:2:30:5 SLIDINGWINDOW:5:20 HEADCROP:10 MINLEN:16 </code></li>
      <li>FastQC commandes: 
        <ul>
          <li><code>fastqc -o ../results/_fastqc2/ --dir ../results/_TMP -f fastq  $fwP</code></li>
          <li><code>fastqc -o ../results/_fastqc2/ --dir ../results/_TMP -f fastq  $rvP </code></li>
        </ul>
  </ul>
  
  <h4 id="multiqc">MultiQC</h4>
  <ul>
  <li>file name: <code>template_mqc1.sh</code></li>
  <li>commande: <code>multiqc --outdir ../results/_fastqc2 ../results/_fastqc2 </code></li>
  </ul>

<h3 id="alignment">Alignment</h3>
  <h4 id="align">Bowtie2</h4>
      <ul>
        <li>file name: <code>template_bowtie2.sh</code></li>
        <li>options:</li>
        <ul>
          <li><code>--very-sensitive</code></li>
          <li><code>-X 1000</code></li>
          <li><code>-k 10</code></li>
        </ul>  
        <li>commande:</li><code>bowtie2 --threads 40 --very-sensitive -X 1000  -k 10 --un $ump --al $mmp  --met-file $metric $rgline  -x $indx -1 $f1 -2 $f2 -S $sam 2>$logf</code>
      </ul>     
<h3 id="alignsort">Alignment QC and Sorting</h3>
  <h4 id="samstat">samtools stat</h4>
      <ul>
        <li>file name: <code>template_samstat1.sh</code></li>
        <li>commande: <code>samtools stats $sam >$samstat</code></li>  
      </ul>
  <h4 id="multiBowtie">MultiQC on bowtie2</h4>
      <ul>
        <li>file name: <code>template_mqc2.sh</code></li>
        <li>commande: <code>mugqic/MultiQC/1.14 -m bowtie2 --outdir ../results/_logs/_bowtie2 $WORK_DIR/$1/results/_logs/_bowtie2/*</code></li>  
      </ul>    
  <h4 id="samsort">samtools sort</h4>
      <ul>
        <li>commande: <code>samtools sort -@ 48 -o $ssam $sam</code></li>
      </ul>
<h3 id="chrremove">Remove chloroplast alignements</h3>
  <h4 id="filter">samtools view</h4>
    <ul>
    <li>file name: <code>template_bFilter_sam.sh</code></li>
    <li>commandes:</li>
      <ul>
        <li><code>samtools index $f1 # to filter by chromosome, samtools need indexed bam input</code></li>   
        <li><code>samtools view -H $f1 | grep -v "@SQ\sSN:GU592207\.1\sLN:134551" >$filtered</code></li>   
        <li>loup over wanted chromosomes:</li>
          <code>mapfile -t lines < $chroms</code></br>
          <code>for line in "${lines[@]}"; do samtools view $f1 $line >>$filtered; done</code>
      </ul> 
  </ul>
<h3 id="sam2bam">SAM to BAM</h3> 
      <h4 id="sam2bam">samtools view</h4>
      <ul>
        <li>commande: <code>samtools view -Sb $filtered > $bam</code></li>
      </ul>
      <h4 id="multiBAM">MultiQC on filtered BAM</h4>
      <ul>
        <li>file name: <code>template_mqc3.sh</code></li>
        <li>commande: <code>mugqic/MultiQC/1.14 -m samtools --outdir ../results/_BAM/_filtered $WORK_DIR/$1/results/_BAM/_filtered/*_filtered_stats.txt</code></li>  
      </ul> 
<h3 id="genrich"><a href="https://github.com/golrokh51/ATAC-seq/blob/main/Genrich.md" target="_blank">Genrich pipeline</a></h3>
<h3 id="markdup">MarkDuplicate</h3>
  <h4 id="sambamb">sambamba markdup</h4></li>
      <ul>
        <li>file name: <code>template_sambambaMarkDup.sh</code></li>
        <li>commande: <code>sambamba markdup $f1 $marked</code></li>
      </ul>
<!--     <li><h4 id="picard">Picard markdup</li>
      <ul>
        <li>file name: <code>template_MarkDup.sh</code></li>
        <li>commande: <code>java -jar -Xmx32g $EBROOTPICARD/picard.jar MarkDuplicates INPUT=$f1 OUTPUT=$marked METRICS_FILE=$metric</code></li>
      </ul> -->
 <h3 id="macs2">Peak calling</h3>
   <h4 id="bam2bed">BAM to BED</h4>
      <ul>
        <li>file name: <code>template_bam2bed.sh</code></li>
        <li>command: <code>bedtools bamtobed -color 255,0,0 -bed12 -cigar -i $f1 > $bed</code></li>
      </ul>
   <h4 id="macs2">MACS2</h4>
     <ul>
        <li>file name: <code>template_macs2.sh</code></li>
        <li>commande: <code>macs2 callpeak -t $f1 --nomodel -g 379627553 -f BED -n $out -q 0.05 --extsize 200 --shift -100 --keep-dup all -B</code></li>
     </ul> 
