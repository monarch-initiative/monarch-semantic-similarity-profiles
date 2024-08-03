SPARQLDIR				:=	scripts/sparql

$(ONTOLOGYDIR)/upheno1-equivalent.owl: $(MIRRORDIR)/upheno1-equivalent.owl
	$(ROBOT) merge -i $< -o $@

$(ONTOLOGYDIR)/upheno2-equivalent.owl: $(MIRRORDIR)/upheno2-lattice.owl $(ONTOLOGYDIR)/upheno-mappings-equivalent-class.owl
	$(ROBOT) query -i $(ONTOLOGYDIR)/upheno-mappings-equivalent-class.owl --update $(SPARQLDIR)/prepare-upheno-mapping.ru \
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
	$(ROBOT) merge -i $< \
	remove --select "BFO:*" --select classes \
	remove --select "PATO:*" --select classes \
	-o $@

$(ONTOLOGYDIR)/%.db: $(ONTOLOGYDIR)/%.owl
	semsql make $@


$(TMP_DATA)/%.db:  $(TMP_DATA)/%.owl
	@rm -f .template.db
	@rm -f .template.db.tmp
	@rm -f $(TMP_DATA)/$*-relation-graph.tsv.gz
	semsql make $@
	@rm -f .template.db
	@rm -f .template.db.tmp
	@rm -f $(TMP_DATA)/$*-relation-graph.tsv.gz

PHENIO_MONARCH_DB = https://data.monarchinitiative.org/monarch-kg/latest/phenio.db.gz

$(ONTOLOGYDIR)/phenio-monarch.db.gz:
	test -d $(ONTOLOGYDIR) || mkdir -p $(ONTOLOGYDIR)
	wget $(PHENIO_MONARCH_DB) -O $@

$(ONTOLOGYDIR)/phenio-monarch.db: $(ONTOLOGYDIR)/phenio-monarch.db.gz
	gunzip $<

PHENIO_URL = https://github.com/monarch-initiative/phenio/releases/download/2023-07-11/phenio.owl
$(TMP_DATA)/phenio.owl:
	mkdir -p $(TMP_DATA)
	wget $(PHENIO_URL) -O $@


$(TMP_DATA)/phenio-plus.owl: $(TMP_DATA)/phenio.owl $(TMP_DATA)/hpoa_d2p_preprocessed.ttl $(TMP_DATA)/hpoa_g2p_preprocessed.ttl
	$(ROBOT) merge $(foreach n,$^, -i $(n)) -o $@
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

$(TMP_DATA)/gene_phenotype.%.tsv.gz:
	mkdir -p $(TMP_DATA)
	wget https://data.monarchinitiative.org/monarch-kg/latest/tsv/gene_associations/gene_phenotype.$*.tsv.gz -O $@

$(TMP_DATA)/gene_phenotype.%.tsv: $(TMP_DATA)/gene_phenotype.%.tsv.gz
	gunzip -f $<

#HP
$(TMP_DATA)/phenio_monarch_hp_ic.tsv: $(TMP_DATA)/gene_phenotype.9606.tsv $(ONTOLOGYDIR)/phenio-monarch.db
	runoak -i $(ONTOLOGYDIR)/phenio-monarch.db -g $< -G hpoa_g2p information-content -p i i^HP: -o $@

#MP
$(TMP_DATA)/phenio_monarch_mp_ic.tsv: $(TMP_DATA)/gene_phenotype.10090.tsv $(ONTOLOGYDIR)/phenio-monarch.db
	runoak -i $(ONTOLOGYDIR)/phenio-monarch.db -g $< -G hpoa_g2p information-content -p i i^MP: -o $@

$(TMP_DATA)/phenio_monarch_hp_mp_ic.tsv: $(TMP_DATA)/phenio_monarch_hp_ic.tsv $(TMP_DATA)/phenio_monarch_mp_ic.tsv
	awk 'FNR==1 && NR!=1{next} {print}' $< $(TMP_DATA)/phenio_monarch_mp_ic.tsv > $@


#ZP
$(TMP_DATA)/phenio_monarch_zp_ic.tsv: $(TMP_DATA)/gene_phenotype.7955.tsv $(ONTOLOGYDIR)/phenio-monarch.db
	runoak -i $(ONTOLOGYDIR)/phenio-monarch.db -g $< -G hpoa_g2p information-content -p i i^ZP: -o $@

$(TMP_DATA)/phenio_monarch_hp_zp_ic.tsv: $(TMP_DATA)/phenio_monarch_hp_ic.tsv $(TMP_DATA)/phenio_monarch_zp_ic.tsv
	awk 'FNR==1 && NR!=1{next} {print}' $< $(TMP_DATA)/phenio_monarch_zp_ic.tsv > $@

#XPO
$(TMP_DATA)/phenio_monarch_xpo_ic.tsv: $(TMP_DATA)/gene_phenotype.8364.tsv $(ONTOLOGYDIR)/phenio-monarch.db
	runoak -i $(ONTOLOGYDIR)/phenio-monarch.db -g $< -G hpoa_g2p information-content -p i i^XPO: -o $@

$(TMP_DATA)/phenio_monarch_hp_xpo_ic.tsv: $(TMP_DATA)/phenio_monarch_hp_ic.tsv $(TMP_DATA)/phenio_monarch_xpo_ic.tsv
	awk 'FNR==1 && NR!=1{next} {print}' $< $(TMP_DATA)/phenio_monarch_xpo_ic.tsv > $@
