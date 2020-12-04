
samples= [x.strip().split("_")[0] for x in open("working_external_IDs.txt")]
rule all:
	input: 
            expand("raw_data/zipped_data/{sample}.tar", sample = samples),
            expand("raw_data/{sample}_R1.fastq.gz", sample = samples),
            expand("raw_data/{sample}_R2.fastq.gz", sample = samples),
            expand("fastp/{sample}_R1.trimmed.gz", sample = samples),
            expand("fastp/{sample}_R2.trimmed.gz", sample = samples),
            expand("fastp/{sample}_fastp.html", sample = samples),
            expand("fastp/{sample}_fastp.json", sample = samples),
            #expand("bbduk/{sample}_R1.nohost.fq.gz", sample = samples),
            #expand("bbduk/{sample}_R2.nohost.fq.gz", sample = samples),
            #expand("bbduk/{sample}_R1.human.fq.gz", sample = samples),
            #expand("bbduk/{sample}_R2.human.fq.gz", sample = samples)

rule download: 
	output: "raw_data/zipped_data/{sample}.tar"
	params: URL= lambda wildcards: "https://ibdmdb.org/tunnel/static/HMP2/WGS/1818/" + wildcards.sample + ".tar"
	shell: "wget -O {output} {params.URL}"

rule untar:
	input: "raw_data/zipped_data/{sample}.tar"
	output: R1="raw_data/{sample}_R1.fastq.gz", 
		R2="raw_data/{sample}_R2.fastq.gz"
	shell: "tar xvf {input} -C ~/ihmp2020/raw_data/" 

rule fastp:
	input:  R1="raw_data/{sample}_R1.fastq.gz",
		R2="raw_data/{sample}_R2.fastq.gz"
	output: R1="fastp/{sample}_R1.trimmed.gz",  
                R2="fastp/{sample}_R2.trimmed.gz",
                html="fastp/{sample}_fastp.html",
                json="fastp/{sample}_fastp.json"
	shell:  """
        	fastp -i {input.R1} -I {input.R2}  \
        	-o {output.R1} -O {output.R2} \
        	-h {output.html} -j {output.json}
        	"""

#rule bbduk:
	#input:
		#R1 = "fastp/{sample}_R1.trim.fastq.gz",
        	#R2 = "fastp/{sample}_R2.trim.fastq.gz",
        	#human = "databases/hg19_main_mask_ribo_animal_allplant_allfungus.fa.gz"
	#output:
        	#R1 = "bbduk/{sample}_R1.nohost.fq.gz",
        	#R2 = "bbduk/{sample}_R2.nohost.fq.gz",
        	#human_R1 = "bbduk/{sample}_R1.human.fq.gz",
        	#human_R2 = "bbduk/{sample}_R2.human.fq.gz"
    #bbduk requires 64gb of mem, and requires "-n 4" in srun command
	#shell:
        	#"""
        	#bbduk.sh -Xmx64g t=4 in={input.R1} in2={input.R2} out={output.R1} out2={output.R2} outm={output.human_R1} outm2={output.human_R2} k=31 ref={input.human}
        	#"""




