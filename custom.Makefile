SPARQLDIR				:=	scripts/sparql

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

$(ONTOLOGYDIR)/upheno-mappings-equivalent-class.owl: $(TMP_DATA)/upheno_custom_mapping.sssom.parsed.tsv
	sssom convert $< -o $@ > /dev/null


$(ONTOLOGYDIR)/%-without-abstract.owl: $(MIRRORDIR)/%.owl
	robot merge -i $< \
	remove --select "BFO:*" --select classes \
	remove --select "PATO:*" --select classes \
	-o $@

$(ONTOLOGYDIR)/%.db: $(ONTOLOGYDIR)/%.owl
	./odk.sh semsql make $@


$(TMP_DATA)/%.db:  $(TMP_DATA)/%.owl
	@rm -f .template.db
	@rm -f .template.db.tmp
	@rm -f $(TMP_DATA)/$*-relation-graph.tsv.gz
	semsql make $@
	@rm -f .template.db
	@rm -f .template.db.tmp
	@rm -f $(TMP_DATA)/$*-relation-graph.tsv.gz

PHENIO_URL = https://github.com/monarch-initiative/phenio/releases/download/2023-07-11/phenio.owl
$(TMP_DATA)/phenio.owl:
	wget $(PHENIO_URL) -O $@

$(TMP_DATA)/phenio-plus.owl: $(TMP_DATA)/phenio.owl $(TMP_DATA)/hpoa_d2p_preprocessed.ttl $(TMP_DATA)/hpoa_g2p_preprocessed.ttl
	robot merge $(foreach n,$^, -i $(n)) -o $@
#Here are the ones for the HPOA file:

HPOA_D2P_MONARCH=https://data.monarchinitiative.org/monarch-kg-dev/latest/rdf/hpoa_disease_to_phenotype.nt.gz
HPOA_G2P_MONARCH=https://data.monarchinitiative.org/monarch-kg-dev/latest/rdf/hpoa_gene_to_phenotype.nt.gz

$(TMP_DATA)/hpoa_d2p.nt.gz: | $(TMP_DATA)
	wget $(HPOA_D2P_MONARCH) -O $@

$(TMP_DATA)/hpoa_g2p.nt.gz: | $(TMP_DATA)
	wget $(HPOA_G2P_MONARCH) -O $@

$(TMP_DATA)/hpoa_%.nt: $(TMP_DATA)/hpoa_%.nt.gz
	gunzip -f $<
	test $@

$(TMP_DATA)/hpoa_%.ttl: $(TMP_DATA)/hpoa_%.nt
	$(ROBOT) convert -i $(TMP_DATA)/hpoa_$*.nt -f ttl -o $@ > /dev/null

$(TMP_DATA)/hpoa_%_preprocessed.ttl: $(TMP_DATA)/hpoa_%.nt
	$(ROBOT) query -i $< --update scripts/sparql/preprocess_$*.ru -o $@ > /dev/null
