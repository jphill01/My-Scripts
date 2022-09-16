# Retrieve_bold_taxa pulls taxon sequences from BOLD. 
# You only need to specify a Linnean name (in quotes). 
# By default, COI-5P sequences are retrieved, but any locus can be targeted

retrieve_bold_taxa <- function(taxon, marker = "COI-5P") {
  
  # The first command pulls all the sequence data from BOLD for a specific taxa of interest.
  # Can put in a list of taxa by creating a vector with taxon=c("Genus species1", "Genus species2")
  # This code also species to retrieve only records which have a COI-5P sequence, HOWEVER the code functions by downloading all other gene regions
  # for these specimens. So, it only pulls specimens with a COI-5P sequence, but downloads all sequences for the specimen. 
  
  Genus_species <- bold_seqspec(taxon = taxon, marker = marker)
  
  # The next line of code takes a subset of the above data.frame which has a markercode value (the column specifying gene marker) of COI-5P
  # and then saves them into a new vector.
  
  G_species <- subset(Genus_species, markercode == marker)
  
  # We now have a data table with all our information in it, but we need them in a fasta file to align them later.
  # The write.fasta function wants references to specific columns for the names and the sequences. The sequences are already isolated, so we just
  # want to make an additional column which pastes together the ProcessID, SampleID and the Species name, so each sequence can be easily traced 
  # back to BOLD later.
  
  G_species$name <- paste(G_species$processid, G_species$sampleid, G_species$species_name)
  
  # The final step is to write what we need out to a fasta file. The general structure of this code is 
  # write.fasta(sequences, names, file name), however for whatever reason the code nicely designates the names where they belong
  # but it dumps all of the sequences together at the end. So you need to use "as.list(<location of sequence in dataframe>)" in order
  # for the sequences to be reported line-by-line. 
  # You can verify that the sequences are matched with the right IDs by checking back with the original list created by bold_seq!
  
  write.fasta(sequences = as.list(G_species$nucleotides), names = G_species$name, file.out = paste0("taxa.fas"))
}

# Example code that can be run that pulls sequences for a taxon of interest and formats them cleanly into a FASTA output.

# Load required packages (assuming they are already installed)

library(bold) # to download sequences
library(seqinr) # to write sequences to FASTA file

# set working directory so you can find FASTA file later

setwd("/Users/jarrettphillips/Desktop") 

# Master species list - paste desired species names here

taxa <- c("Homo sapiens") 

retrieve_bold_taxa(taxon = taxa) # outputted FASTA file will be called "taxa.fas" 
