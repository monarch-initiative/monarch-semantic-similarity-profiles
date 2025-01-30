SPARQLDIR				:=	scripts/sparql


#################################
### PREPARE ONTOLOGIES ##########
#################################

$(ONTOLOGYDIR)/upheno1.owl: $(MIRRORDIR)/upheno1.owl
	$(ROBOT) merge -i $< reason --reasoner ELK --axiom-generators "EquivalentClass" -o $@
.PRECIOUS: $(ONTOLOGYDIR)/upheno1.owl

######## PHENIO RELEASE VERSION #######

# Created a custom goal for this as the OWL file is too large to be stored in the repo
mirror-phenio-release:
	mkdir -p $(TMP_DATA)
	if [ $(MIR) = true ]; then curl -L https://github.com/monarch-initiative/phenio/releases/latest/download/phenio.owl.gz --create-dirs -o $(ONTOLOGYDIR)/phenio-release-download.owl.gz  --max-time 600 &&\
		$(ROBOT) merge -i $(ONTOLOGYDIR)/phenio-release-download.owl.gz convert -o $@.tmp.owl && mv $@.tmp.owl $(TMP_DATA)/$@.owl; fi

$(ONTOLOGYDIR)/phenio-release.owl: $(MIRRORDIR)/phenio-release.owl
	cp $< $@
.PRECIOUS: $(ONTOLOGYDIR)/phenio-release.owl

######## PHENIO MONARCH VERSION #######
# The version of PHENIO stored used by Monarch Apps

$(ONTOLOGYDIR)/phenio-monarch.owl:
	@echo "$@ is not needed, we download the db file directly"
	touch $@
.PRECIOUS: $(ONTOLOGYDIR)/phenio-monarch.owl

######## PHENIO FLAT VERSION #######
# A version without subclass axioms

$(ONTOLOGYDIR)/phenio-flat.owl: $(MIRRORDIR)/phenio-release.owl
	$(ROBOT) merge -i $< \
		remove --term UPHENO:0001001 --select "self descendants" --axioms logical -o $@
.PRECIOUS: $(ONTOLOGYDIR)/phenio-flat.owl

######## PHENIO EQUIVALENT #######
## Needs a bit of fuzzzzing around

# TODO: Figure out most comprehensive / correct equivalence mapping for uPheno

$(TMP_DATA)/upheno-species-independent.sssom.tsv:
	wget https://data.monarchinitiative.org/mappings/latest/upheno-species-independent.sssom.tsv -O $@

$(TMP_DATA)/upheno-custom.sssom.tsv:
	wget https://data.monarchinitiative.org/mappings/latest/upheno-cross-species.sssom.tsv -O $@

$(TMP_DATA)/upheno-equivalence-mappings.sssom.tsv: $(TMP_DATA)/upheno-species-independent.sssom.tsv $(TMP_DATA)/upheno-custom.sssom.tsv
	sssom merge $^ -o $@

$(ONTOLOGYDIR)/upheno-mappings-equivalent-class.owl: $(TMP_DATA)/upheno-equivalence-mappings.sssom.tsv
	sssom convert $< -O owl -o $@ > /dev/null

$(ONTOLOGYDIR)/phenio-equivalent.owl: $(MIRRORDIR)/phenio-release.owl $(ONTOLOGYDIR)/upheno-mappings-equivalent-class.owl
	$(ROBOT) query -i $(ONTOLOGYDIR)/upheno-mappings-equivalent-class.owl --update $(SPARQLDIR)/prepare-upheno-mapping.ru \
	merge -i $<  \
	remove --axioms disjoint \
	reason \
	reduce -o $@
.PRECIOUS: $(ONTOLOGYDIR)/phenio-equivalent.owl


# TODO DELETE THIS:
#$(TMP_DATA)/upheno_custom_mapping.sssom.parsed.tsv: $(TMP_DATA)/upheno_custom_mapping.sssom.tsv
#	sssom parse $< \
#	-m $(TMP_DATA)/upheno_custom_mapping.sssom.metadata.yaml \
#	-o $@

######## PHENIO MONARCH VERSION #######

PHENIO_MONARCH_DB = https://data.monarchinitiative.org/monarch-kg/latest/phenio.db.gz

$(TMP_DATA)/phenio-monarch.db.gz:
	test -d $(TMP_DATA) || mkdir -p $(TMP_DATA)
	wget $(PHENIO_MONARCH_DB) -O $@

$(ONTOLOGYDIR)/phenio-monarch.db: $(TMP_DATA)/phenio-monarch.db.gz
	gunzip $<

#################################
### PREPARE ANNOTATION DATA #####
#################################

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

#################################
### PREPARE IC SCORES ###########
#################################

$(TMP_DATA)/phenio_monarch_hp_ic.tsv: $(TMP_DATA)/gene_phenotype.9606.tsv $(ONTOLOGYDIR)/phenio-monarch.db
	runoak -i $(ONTOLOGYDIR)/phenio-monarch.db -g $< -G hpoa_g2p information-content -p i i^HP: -p i i^UPHENO: -o $@
.PRECIOUS: $(TMP_DATA)/phenio_monarch_hp_ic.tsv

$(TMP_DATA)/phenio_monarch_mp_ic.tsv: $(TMP_DATA)/gene_phenotype.10090.tsv $(ONTOLOGYDIR)/phenio-monarch.db
	runoak -i $(ONTOLOGYDIR)/phenio-monarch.db -g $< -G hpoa_g2p information-content -p i i^MP: -p i i^UPHENO: -o $@
.PRECIOUS: $(TMP_DATA)/phenio_monarch_mp_ic.tsv

$(TMP_DATA)/phenio_monarch_hp_mp_ic.tsv: $(TMP_DATA)/phenio_monarch_hp_ic.tsv $(TMP_DATA)/phenio_monarch_mp_ic.tsv
	awk 'FNR==1 && NR!=1{next} {print}' $< $(TMP_DATA)/phenio_monarch_mp_ic.tsv | uniq > $@
.PRECIOUS: $(TMP_DATA)/phenio_monarch_hp_mp_ic.tsv

$(TMP_DATA)/phenio_monarch_zp_ic.tsv: $(TMP_DATA)/gene_phenotype.7955.tsv $(ONTOLOGYDIR)/phenio-monarch.db
	runoak -i $(ONTOLOGYDIR)/phenio-monarch.db -g $< -G hpoa_g2p information-content -p i i^ZP: -p i i^UPHENO: -o $@
.PRECIOUS: $(TMP_DATA)/phenio_monarch_zp_ic.tsv

$(TMP_DATA)/phenio_monarch_hp_zp_ic.tsv: $(TMP_DATA)/phenio_monarch_hp_ic.tsv $(TMP_DATA)/phenio_monarch_zp_ic.tsv
	awk 'FNR==1 && NR!=1{next} {print}' $< $(TMP_DATA)/phenio_monarch_zp_ic.tsv | uniq > $@
.PRECIOUS: $(TMP_DATA)/phenio_monarch_hp_zp_ic.tsv

$(TMP_DATA)/phenio_monarch_xpo_ic.tsv: $(TMP_DATA)/gene_phenotype.8364.tsv $(ONTOLOGYDIR)/phenio-monarch.db
	runoak -i $(ONTOLOGYDIR)/phenio-monarch.db -g $< -G hpoa_g2p information-content -p i i^XPO: -p i i^UPHENO: -o $@
.PRECIOUS: $(TMP_DATA)/phenio_monarch_xpo_ic.tsv

$(TMP_DATA)/phenio_monarch_hp_xpo_ic.tsv: $(TMP_DATA)/phenio_monarch_hp_ic.tsv $(TMP_DATA)/phenio_monarch_xpo_ic.tsv
	awk 'FNR==1 && NR!=1{next} {print}' $< $(TMP_DATA)/phenio_monarch_xpo_ic.tsv | uniq > $@
.PRECIOUS: $(TMP_DATA)/phenio_monarch_hp_xpo_ic.tsv

#########################
### MISC GOALS ##########
#########################

.PHONY: public_release
public_release:
	gsutil rsync -d profiles/ gs://data-public-monarchinitiative/semantic-similarity/$(shell date +%Y-%m-%d)
	gsutil -m rm -r gs://data-public-monarchinitiative/semantic-similarity/latest/*
	gsutil cp -r gs://data-public-monarchinitiative/semantic-similarity/$(shell date +%Y-%m-%d) gs://data-public-monarchinitiative/semantic-similarity/latest
