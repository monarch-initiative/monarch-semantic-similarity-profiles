SPARQLDIR				:=	data/sparql

$(ONTOLOGYDIR)/upheno1-equivalent.owl: $(MIRRORDIR)/upheno1-equivalent.owl
	robot merge -i $< -o $@

$(ONTOLOGYDIR)/upheno2-equivalent.owl: $(MIRRORDIR)/upheno2-lattice.owl $(ONTOLOGYDIR)/upheno-mappings-equivalent-class.owl
	robot query -i $(ONTOLOGYDIR)/upheno-mappings-equivalent-class.owl --update $(SPARQLDIR)/prepare-upheno-mapping.ru \
	merge -i $< -o $@


$(TMP_DATA)/upheno_custom_mapping.sssom.tsv: #is created using phenio-toolkit
	phenio-toolkit lexical-mapping \
	--species-lexical $(TMP_DATA)/upheno_species_lexical.csv \
	--mapping-logical $(TMP_DATA)/upheno_mapping_logical.csv \
	--output $(TMP_DATA)

$(TMP_DATA)/upheno_custom_mapping.sssom.parsed.tsv: $(TMP_DATA)/upheno_custom_mapping.sssom.tsv
	sssom parse $< \
	-m $(TMP_DATA)/upheno_custom_mapping.sssom.metadata.yaml \
	-o $@

#there's no option like this:
#sssom convert --output-format ttl
$(ONTOLOGYDIR)/upheno-mappings-equivalent-class.owl: $(TMP_DATA)/upheno_custom_mapping.sssom.parsed.tsv
	sssom convert $<  -o $@
# robot query -i $@


$(ONTOLOGYDIR)/phenio-without-abstract.owl: $(MIRRORDIR)/phenio.owl
	robot merge -i $< \
	remove --select "BFO:*" --select classes \
	remove --select "PATO:*" --select classes \
	-o $@

$(ONTOLOGYDIR)/phenio-without-abstract.db: $(ONTOLOGYDIR)/phenio-without-abstract.owl
	./odk.sh semsql make $@

$(ONTOLOGYDIR)/upheno2-lattice-without-abstract.owl: $(MIRRORDIR)/upheno2-lattice.owl
	robot merge -i $< \
	remove --select "BFO:*" --select classes \
	remove --select "PATO:*" --select classes \
	-o $@

$(ONTOLOGYDIR)/upheno2-lattice-without-abstract.db: $(ONTOLOGYDIR)/upheno2-lattice-without-abstract.owl
	./odk.sh semsql make $@

$(ONTOLOGYDIR)/upheno1-without-abstract.owl: $(MIRRORDIR)/upheno1.owl
	robot merge -i $< \
	remove --select "BFO:*" --select classes \
	remove --select "PATO:*" --select classes \
	-o $@

$(ONTOLOGYDIR)/upheno1-without-abstract.db: $(ONTOLOGYDIR)/upheno1-without-abstract.owl
	./odk.sh semsql make $@

