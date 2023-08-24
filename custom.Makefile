SPARQLDIR				:=	data/sparql

$(ONTOLOGYDIR)/upheno1-equivalent.owl: $(MIRRORDIR)/upheno1-equivalent.owl
	robot merge -i $< -o $@

$(ONTOLOGYDIR)/upheno2-equivalent.owl: $(MIRRORDIR)/upheno2-lattice.owl $(ONTOLOGYDIR)/upheno-mappings-equivalent-class.owl
	robot query -i $(ONTOLOGYDIR)/upheno-mappings-equivalent-class.owl --update $(SPARQLDIR)/prepare-upheno-mapping.ru \
	merge -i $< -o $@


$(TMP_DATA)/upheno_custom_mapping.sssom.tsv: $(TMP_DATA)/upheno_species_lexical.csv $(TMP_DATA)/upheno_mapping_logical.csv #is created using phenio-toolkit
	phenio-toolkit lexical-mapping \
	--species-lexical $< \
	--mapping-logical $(TMP_DATA)/upheno_mapping_logical.csv \
	--output $(TMP_DATA)

$(TMP_DATA)/upheno_custom_mapping.sssom.parsed.tsv: $(TMP_DATA)/upheno_custom_mapping.sssom.tsv
	sssom parse $< \
	-m $(TMP_DATA)/upheno_custom_mapping.sssom.metadata.yaml \
	-o $@

#there's no option like this:
#sssom convert --output-format ttl
$(ONTOLOGYDIR)/upheno-mappings-equivalent-class.owl: $(TMP_DATA)/upheno_custom_mapping.sssom.parsed.tsv
	sssom convert $< -o $@


$(ONTOLOGYDIR)/%-without-abstract.owl: $(MIRRORDIR)/%.owl
	robot merge -i $< \
	remove --select "BFO:*" --select classes \
	remove --select "PATO:*" --select classes \
	-o $@

$(ONTOLOGYDIR)/%-without-abstract.db: $(ONTOLOGYDIR)/%-without-abstract.owl
	./odk.sh semsql make $@

