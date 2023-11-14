# Where to get taxonomy dump files:
https://ftp.ncbi.nlm.nih.gov/pub/taxonomy/new_taxdump/

# For annotations using a SAM file, how to get taxids from NCBI sequence identifiers, e.g. NC_XXXXXX
List of e-direct database names: https://www.ncbi.nlm.nih.gov/books/NBK25497/table/chapter2.T._entrez_unique_identifiers_ui/?report=objectonly

These are some one-liners that work, but the for loop is what I used. 
1:
esearch -db nucleotide -query "NC_012783.2" | esummary | xtract -pattern DocumentSummary -element TaxId
2:
epost -db nucleotide -id NC_012783.2, NC_022098.1 | efetch -format uid | esummary -db nucleotide | xtract -pattern DocumentSummary -element TaxId,AccessionVersion

This works well:
for i in `echo $b`;do tax=$(esearch -db nucleotide -query $i | esummary | xtract -pattern DocumentSummary -element TaxId); printf "$i\t$tax\n" >> seqid_to_taxid.txt;done

