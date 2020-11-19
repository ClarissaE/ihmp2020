
samples= [x.strip().split("_")[0] for x in open("external_IDs.txt")]
rule all:
	input: 
            expand("raw_data/zipped_data/{sample}.tar", sample = samples)

rule download: 
	output: "raw_data/zipped_data/{sample}.tar"
	params: URL= lambda wildcards: "https://ibdmdb.org/tunnel/static/HMP2/WGS/1818/" + wildcards.sample + ".tar"
	shell: "wget -O {output} {params.URL}"
