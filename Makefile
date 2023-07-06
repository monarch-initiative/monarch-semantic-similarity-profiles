MAKEFLAGS 				+=	--warn-undefined-variables
SHELL 					:=	bash
.DEFAULT_GOAL			:=	help
URIBASE					:=	http://purl.obolibrary.org/obo
TMP_DATA				:=	data/tmp
MIRRORDIR				:=	data/mirror
ONTOLOGYDIR				:=	data/ontology
MIR						:=	true
ROBOT					:=  robot

$(MIRRORDIR)/%.owl: mirror-%
	if [ $(MIR) = true ] && [ -f $(TMP_DATA)/mirror-$*.owl ]; then mkdir -p $(MIRRORDIR) && if cmp -s $(TMP_DATA)/mirror-$*.owl $@ ; then echo "Mirror identical, ignoring."; else echo "Mirrors different, updating." &&\
		cp $(TMP_DATA)/mirror-$*.owl $@; fi; fi
.PRECIOUS: $(MIRRORDIR)/%.owl

.PHONY: generate-ontologies

$(ONTOLOGYDIR)/%.owl: $(MIRRORDIR)/%.owl
	test -d $(ONTOLOGYDIR) || mkdir -p $(ONTOLOGYDIR)
	cp $< $@
generate-ontologies: $(ONTOLOGYDIR)/upheno2-lattice.owl

mirror-upheno2-lattice:
	mkdir -p $(TMP_DATA)
	if [ $(MIR) = true ]; then curl -L http://purl.obolibrary.org/obo/upheno.owl --create-dirs -o $(ONTOLOGYDIR)/upheno2-lattice-download.owl  --max-time 600 &&\
		$(ROBOT) convert -i $(ONTOLOGYDIR)/upheno2-lattice-download.owl -o $@.tmp.owl && mv $@.tmp.owl $(TMP_DATA)/$@.owl; fi


$(TMP_DATA)/upheno2-lattice_hp_terms.txt: $(ONTOLOGYDIR)/upheno2-lattice.owl
	runoak -i sqlite:$< descendants -p i HP:0000118 > $@

$(TMP_DATA)/upheno2-lattice_mp_terms.txt: $(ONTOLOGYDIR)/upheno2-lattice.owl
	runoak -i sqlite:$< descendants -p i MP:0000001 > $@

generate-ontologies: $(ONTOLOGYDIR)/upheno2-lattice.db

$(ONTOLOGYDIR)/upheno2-lattice.db:
	semsql make $@


#4
generate-ontologies: $(ONTOLOGYDIR)/upheno2-lattice_flat.owl

#4
# Maybe it's better to just create an empty semsim table rather than doing this unecessary computation
$(ONTOLOGYDIR)/upheno2-lattice_flat.owl: $(ONTOLOGYDIR)/upheno2-lattice.owl
	robot remove --axioms "logical" --input $< --output $@


generate-ontologies: $(ONTOLOGYDIR)/upheno1-equivalent.owl

mirror-upheno1-equivalent:
	mkdir -p $(TMP_DATA)
	if [ $(MIR) = true ]; then curl -L http://purl.obolibrary.org/obo/upheno.owl --create-dirs -o $(ONTOLOGYDIR)/upheno1-equivalent-download.owl  --max-time 600 &&\
		$(ROBOT) convert -i $(ONTOLOGYDIR)/upheno1-equivalent-download.owl -o $@.tmp.owl && mv $@.tmp.owl $(TMP_DATA)/$@.owl; fi


$(TMP_DATA)/upheno1-equivalent_hp_terms.txt: $(ONTOLOGYDIR)/upheno1-equivalent.owl
	runoak -i sqlite:$< descendants -p i HP:0000118 > $@

$(TMP_DATA)/upheno1-equivalent_mp_terms.txt: $(ONTOLOGYDIR)/upheno1-equivalent.owl
	runoak -i sqlite:$< descendants -p i MP:0000001 > $@

generate-ontologies: $(ONTOLOGYDIR)/upheno1-equivalent.db

$(ONTOLOGYDIR)/upheno1-equivalent.db:
	semsql make $@


#4
generate-ontologies: $(ONTOLOGYDIR)/upheno1-equivalent_flat.owl

#4
# Maybe it's better to just create an empty semsim table rather than doing this unecessary computation
$(ONTOLOGYDIR)/upheno1-equivalent_flat.owl: $(ONTOLOGYDIR)/upheno1-equivalent.owl
	robot remove --axioms "logical" --input $< --output $@


generate-ontologies: $(ONTOLOGYDIR)/upheno1.owl

mirror-upheno1:
	mkdir -p $(TMP_DATA)
	if [ $(MIR) = true ]; then curl -L http://purl.obolibrary.org/obo/upheno.owl --create-dirs -o $(ONTOLOGYDIR)/upheno1-download.owl  --max-time 600 &&\
		$(ROBOT) convert -i $(ONTOLOGYDIR)/upheno1-download.owl -o $@.tmp.owl && mv $@.tmp.owl $(TMP_DATA)/$@.owl; fi


$(TMP_DATA)/upheno1_hp_terms.txt: $(ONTOLOGYDIR)/upheno1.owl
	runoak -i sqlite:$< descendants -p i HP:0000118 > $@

$(TMP_DATA)/upheno1_mp_terms.txt: $(ONTOLOGYDIR)/upheno1.owl
	runoak -i sqlite:$< descendants -p i MP:0000001 > $@

generate-ontologies: $(ONTOLOGYDIR)/upheno1.db

$(ONTOLOGYDIR)/upheno1.db:
	semsql make $@


#4
generate-ontologies: $(ONTOLOGYDIR)/upheno1_flat.owl

#4
# Maybe it's better to just create an empty semsim table rather than doing this unecessary computation
$(ONTOLOGYDIR)/upheno1_flat.owl: $(ONTOLOGYDIR)/upheno1.owl
	robot remove --axioms "logical" --input $< --output $@


generate-ontologies: $(ONTOLOGYDIR)/hp.owl

mirror-hp:
	mkdir -p $(TMP_DATA)
	if [ $(MIR) = true ]; then curl -L http://purl.obolibrary.org/obo/hp.owl --create-dirs -o $(ONTOLOGYDIR)/hp-download.owl  --max-time 600 &&\
		$(ROBOT) convert -i $(ONTOLOGYDIR)/hp-download.owl -o $@.tmp.owl && mv $@.tmp.owl $(TMP_DATA)/$@.owl; fi


$(TMP_DATA)/hp_hp_terms.txt: $(ONTOLOGYDIR)/hp.owl
	runoak -i sqlite:$< descendants -p i HP:0000118 > $@

$(TMP_DATA)/hp_mp_terms.txt: $(ONTOLOGYDIR)/hp.owl
	runoak -i sqlite:$< descendants -p i MP:0000001 > $@

generate-ontologies: $(ONTOLOGYDIR)/hp.db

$(ONTOLOGYDIR)/hp.db:
	semsql make $@


#4
generate-ontologies: $(ONTOLOGYDIR)/hp_flat.owl

#4
# Maybe it's better to just create an empty semsim table rather than doing this unecessary computation
$(ONTOLOGYDIR)/hp_flat.owl: $(ONTOLOGYDIR)/hp.owl
	robot remove --axioms "logical" --input $< --output $@


generate-ontologies: $(ONTOLOGYDIR)/mp.owl

mirror-mp:
	mkdir -p $(TMP_DATA)
	if [ $(MIR) = true ]; then curl -L http://purl.obolibrary.org/obo/mp.owl --create-dirs -o $(ONTOLOGYDIR)/mp-download.owl  --max-time 600 &&\
		$(ROBOT) convert -i $(ONTOLOGYDIR)/mp-download.owl -o $@.tmp.owl && mv $@.tmp.owl $(TMP_DATA)/$@.owl; fi


$(TMP_DATA)/mp_hp_terms.txt: $(ONTOLOGYDIR)/mp.owl
	runoak -i sqlite:$< descendants -p i HP:0000118 > $@

$(TMP_DATA)/mp_mp_terms.txt: $(ONTOLOGYDIR)/mp.owl
	runoak -i sqlite:$< descendants -p i MP:0000001 > $@

generate-ontologies: $(ONTOLOGYDIR)/mp.db

$(ONTOLOGYDIR)/mp.db:
	semsql make $@


#4
generate-ontologies: $(ONTOLOGYDIR)/mp_flat.owl

#4
# Maybe it's better to just create an empty semsim table rather than doing this unecessary computation
$(ONTOLOGYDIR)/mp_flat.owl: $(ONTOLOGYDIR)/mp.owl
	robot remove --axioms "logical" --input $< --output $@



.PHONY: run-semsim

run-semsim: generate-ontologies




run-semsim: profiles/upheno2-lattice-hp-mp.semsimian.tsv

profiles/upheno2-lattice-hp-mp.semsimian.tsv: $(TMP_DATA)/upheno2-lattice.db $(TMP_DATA)/upheno2-lattice_hp_terms.txt $(TMP_DATA)/upheno2-lattice_mp_terms.txt
	semsql make $(TMP_DATA)/upheno2-lattice.db
	runoak -i semsimian:sqlite:$< similarity -p i --set1-file $(TMP_DATA)/upheno2-lattice_hp_terms.txt --set2-file $(TMP_DATA)/upheno2-lattice_mp_terms.txt -O csv -o $@



run-semsim: profiles/upheno2-lattice-hp-mp.cosine.tsv

profiles/upheno2-lattice-hp-mp.cosine.tsv: $(TMP_DATA)/upheno2-lattice.db $(TMP_DATA)/upheno2-lattice_hp_terms.txt $(TMP_DATA)/upheno2-lattice_mp_terms.txt
	semsql make $(TMP_DATA)/upheno2-lattice.db
	runoak -i cosine:sqlite:$< similarity -p i --set1-file $(TMP_DATA)/upheno2-lattice_hp_terms.txt --set2-file $(TMP_DATA)/upheno2-lattice_mp_terms.txt -O csv -o $@




.PHONY: generate-mappings
generate-mappings: $(TMP_DATA)/hp-lexmatch.sssom.tsv

generate-mappings: $(TMP_DATA)/mp-lexmatch.sssom.tsv


### 2.2
$(TMP_DATA)/%-lexmatch.sssom.tsv: $(ONTOLOGYDIR)/%.owl
	runoak -i $< lexmatch -o $@


# Obtain lexmatch results then combine to upheno2
$(TMP_DATA)/%-

### 3

upheno1-equivalent-inferred.owl: $(ONTOLOGYDIR)/upheno1-equivalent.owl
	$(ROBOT) merge -i $< reason --reasoner ELK --axiom-generators "EquivalentClass" -o $@

generate-ontologies: upheno1-equivalent-inferred.owl

.PHONY: install

install:
	pip install oaklib -U
	pip install semsimian -U

include ./custom.Makefile