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
		$(ROBOT) merge -i $(ONTOLOGYDIR)/upheno2-lattice-download.owl convert -o $@.tmp.owl && mv $@.tmp.owl $(TMP_DATA)/$@.owl; fi



generate-ontologies: $(ONTOLOGYDIR)/upheno2-lattice.db

$(ONTOLOGYDIR)/upheno2-lattice.db: $(ONTOLOGYDIR)/upheno2-lattice.owl
	./odk.sh semsql make $@


#4
generate-ontologies: $(ONTOLOGYDIR)/upheno2-lattice_flat.owl

#4
# Maybe it's better to just create an empty semsim table rather than doing this unecessary computation
$(ONTOLOGYDIR)/upheno2-lattice_flat.owl: $(ONTOLOGYDIR)/upheno2-lattice.owl
	$(ROBOT) remove --axioms "logical" --input $< --output $@


generate-ontologies: $(ONTOLOGYDIR)/upheno1-equivalent.owl

mirror-upheno1-equivalent:
	mkdir -p $(TMP_DATA)
	if [ $(MIR) = true ]; then curl -L http://purl.obolibrary.org/obo/upheno.owl --create-dirs -o $(ONTOLOGYDIR)/upheno1-equivalent-download.owl  --max-time 600 &&\
		$(ROBOT) merge -i $(ONTOLOGYDIR)/upheno1-equivalent-download.owl convert -o $@.tmp.owl && mv $@.tmp.owl $(TMP_DATA)/$@.owl; fi



generate-ontologies: $(ONTOLOGYDIR)/upheno1-equivalent.db

$(ONTOLOGYDIR)/upheno1-equivalent.db: $(ONTOLOGYDIR)/upheno1-equivalent.owl
	./odk.sh semsql make $@


#4
generate-ontologies: $(ONTOLOGYDIR)/upheno1-equivalent_flat.owl

#4
# Maybe it's better to just create an empty semsim table rather than doing this unecessary computation
$(ONTOLOGYDIR)/upheno1-equivalent_flat.owl: $(ONTOLOGYDIR)/upheno1-equivalent.owl
	$(ROBOT) remove --axioms "logical" --input $< --output $@


generate-ontologies: $(ONTOLOGYDIR)/upheno1.owl

mirror-upheno1:
	mkdir -p $(TMP_DATA)
	if [ $(MIR) = true ]; then curl -L http://purl.obolibrary.org/obo/upheno.owl --create-dirs -o $(ONTOLOGYDIR)/upheno1-download.owl  --max-time 600 &&\
		$(ROBOT) merge -i $(ONTOLOGYDIR)/upheno1-download.owl convert -o $@.tmp.owl && mv $@.tmp.owl $(TMP_DATA)/$@.owl; fi



generate-ontologies: $(ONTOLOGYDIR)/upheno1.db

$(ONTOLOGYDIR)/upheno1.db: $(ONTOLOGYDIR)/upheno1.owl
	./odk.sh semsql make $@


#4
generate-ontologies: $(ONTOLOGYDIR)/upheno1_flat.owl

#4
# Maybe it's better to just create an empty semsim table rather than doing this unecessary computation
$(ONTOLOGYDIR)/upheno1_flat.owl: $(ONTOLOGYDIR)/upheno1.owl
	$(ROBOT) remove --axioms "logical" --input $< --output $@


generate-ontologies: $(ONTOLOGYDIR)/hp.owl

mirror-hp:
	mkdir -p $(TMP_DATA)
	if [ $(MIR) = true ]; then curl -L http://purl.obolibrary.org/obo/hp.owl --create-dirs -o $(ONTOLOGYDIR)/hp-download.owl  --max-time 600 &&\
		$(ROBOT) merge -i $(ONTOLOGYDIR)/hp-download.owl convert -o $@.tmp.owl && mv $@.tmp.owl $(TMP_DATA)/$@.owl; fi

$(TMP_DATA)/hp_terms.txt: $(ONTOLOGYDIR)/hp.owl
	runoak -i sqlite:$< descendants -p i HP:0000118 -o $@



generate-ontologies: $(ONTOLOGYDIR)/hp.db

$(ONTOLOGYDIR)/hp.db: $(ONTOLOGYDIR)/hp.owl
	./odk.sh semsql make $@


#4
generate-ontologies: $(ONTOLOGYDIR)/hp_flat.owl

#4
# Maybe it's better to just create an empty semsim table rather than doing this unecessary computation
$(ONTOLOGYDIR)/hp_flat.owl: $(ONTOLOGYDIR)/hp.owl
	$(ROBOT) remove --axioms "logical" --input $< --output $@


generate-ontologies: $(ONTOLOGYDIR)/mp.owl

mirror-mp:
	mkdir -p $(TMP_DATA)
	if [ $(MIR) = true ]; then curl -L http://purl.obolibrary.org/obo/mp.owl --create-dirs -o $(ONTOLOGYDIR)/mp-download.owl  --max-time 600 &&\
		$(ROBOT) merge -i $(ONTOLOGYDIR)/mp-download.owl convert -o $@.tmp.owl && mv $@.tmp.owl $(TMP_DATA)/$@.owl; fi

$(TMP_DATA)/mp_terms.txt: $(ONTOLOGYDIR)/mp.owl
	runoak -i sqlite:$< descendants -p i MP:0000001 -o $@



generate-ontologies: $(ONTOLOGYDIR)/mp.db

$(ONTOLOGYDIR)/mp.db: $(ONTOLOGYDIR)/mp.owl
	./odk.sh semsql make $@


#4
generate-ontologies: $(ONTOLOGYDIR)/mp_flat.owl

#4
# Maybe it's better to just create an empty semsim table rather than doing this unecessary computation
$(ONTOLOGYDIR)/mp_flat.owl: $(ONTOLOGYDIR)/mp.owl
	$(ROBOT) remove --axioms "logical" --input $< --output $@


generate-ontologies: $(ONTOLOGYDIR)/zp.owl

mirror-zp:
	mkdir -p $(TMP_DATA)
	if [ $(MIR) = true ]; then curl -L http://purl.obolibrary.org/obo/zp.owl --create-dirs -o $(ONTOLOGYDIR)/zp-download.owl  --max-time 600 &&\
		$(ROBOT) merge -i $(ONTOLOGYDIR)/zp-download.owl convert -o $@.tmp.owl && mv $@.tmp.owl $(TMP_DATA)/$@.owl; fi

$(TMP_DATA)/zp_terms.txt: $(ONTOLOGYDIR)/zp.owl
	runoak -i sqlite:$< descendants -p i ZP:00000000 -o $@



generate-ontologies: $(ONTOLOGYDIR)/zp.db

$(ONTOLOGYDIR)/zp.db: $(ONTOLOGYDIR)/zp.owl
	./odk.sh semsql make $@


#4
generate-ontologies: $(ONTOLOGYDIR)/zp_flat.owl

#4
# Maybe it's better to just create an empty semsim table rather than doing this unecessary computation
$(ONTOLOGYDIR)/zp_flat.owl: $(ONTOLOGYDIR)/zp.owl
	$(ROBOT) remove --axioms "logical" --input $< --output $@



.PHONY: run-semsim

run-semsim: generate-ontologies




run-semsim: profiles/upheno2-lattice-hp-mp.semsimian.0.tsv

profiles/upheno2-lattice-hp-mp.semsimian.0.tsv: $(ONTOLOGYDIR)/upheno2-lattice.db $(TMP_DATA)/hp_terms.txt $(TMP_DATA)/mp_terms.txt $(TMP_DATA)/zp_terms.txt
	test -d profiles || mkdir -p profiles
	runoak --stacktrace -vvv  -i semsimian:sqlite:$< similarity -p i \
	--set1-file $(TMP_DATA)/hp_terms.txt \
	--set2-file $(TMP_DATA)/mp_terms.txt \
	--min-ancestor-information-content 4.0 \
	--low-memory \
 	--min-jaccard-similarity 0 \
	--autolabel \
	-O csv \
	-o $@




run-semsim: profiles/upheno2-lattice-hp-hp.semsimian.0.tsv

profiles/upheno2-lattice-hp-hp.semsimian.0.tsv: $(ONTOLOGYDIR)/upheno2-lattice.db $(TMP_DATA)/hp_terms.txt $(TMP_DATA)/mp_terms.txt $(TMP_DATA)/zp_terms.txt
	test -d profiles || mkdir -p profiles
	runoak --stacktrace -vvv  -i semsimian:sqlite:$< similarity -p i \
	--set1-file $(TMP_DATA)/hp_terms.txt \
	--set2-file $(TMP_DATA)/hp_terms.txt \
	--min-ancestor-information-content 4.0 \
	--low-memory \
 	--min-jaccard-similarity 0 \
	--autolabel \
	-O csv \
	-o $@




run-semsim: profiles/upheno2-lattice-hp-zp.semsimian.0.tsv

profiles/upheno2-lattice-hp-zp.semsimian.0.tsv: $(ONTOLOGYDIR)/upheno2-lattice.db $(TMP_DATA)/hp_terms.txt $(TMP_DATA)/mp_terms.txt $(TMP_DATA)/zp_terms.txt
	test -d profiles || mkdir -p profiles
	runoak --stacktrace -vvv  -i semsimian:sqlite:$< similarity -p i \
	--set1-file $(TMP_DATA)/hp_terms.txt \
	--set2-file $(TMP_DATA)/zp_terms.txt \
	--min-ancestor-information-content 4.0 \
	--low-memory \
 	--min-jaccard-similarity 0 \
	--autolabel \
	-O csv \
	-o $@




run-semsim: profiles/upheno2-lattice-hp-mp.semsimian.0.7.tsv

profiles/upheno2-lattice-hp-mp.semsimian.0.7.tsv: $(ONTOLOGYDIR)/upheno2-lattice.db $(TMP_DATA)/hp_terms.txt $(TMP_DATA)/mp_terms.txt $(TMP_DATA)/zp_terms.txt
	test -d profiles || mkdir -p profiles
	runoak --stacktrace -vvv  -i semsimian:sqlite:$< similarity -p i \
	--set1-file $(TMP_DATA)/hp_terms.txt \
	--set2-file $(TMP_DATA)/mp_terms.txt \
	--min-ancestor-information-content 4.0 \
	--low-memory \
 	--min-jaccard-similarity 0.7 \
	--autolabel \
	-O csv \
	-o $@




run-semsim: profiles/upheno2-lattice-hp-hp.semsimian.0.7.tsv

profiles/upheno2-lattice-hp-hp.semsimian.0.7.tsv: $(ONTOLOGYDIR)/upheno2-lattice.db $(TMP_DATA)/hp_terms.txt $(TMP_DATA)/mp_terms.txt $(TMP_DATA)/zp_terms.txt
	test -d profiles || mkdir -p profiles
	runoak --stacktrace -vvv  -i semsimian:sqlite:$< similarity -p i \
	--set1-file $(TMP_DATA)/hp_terms.txt \
	--set2-file $(TMP_DATA)/hp_terms.txt \
	--min-ancestor-information-content 4.0 \
	--low-memory \
 	--min-jaccard-similarity 0.7 \
	--autolabel \
	-O csv \
	-o $@




run-semsim: profiles/upheno2-lattice-hp-zp.semsimian.0.7.tsv

profiles/upheno2-lattice-hp-zp.semsimian.0.7.tsv: $(ONTOLOGYDIR)/upheno2-lattice.db $(TMP_DATA)/hp_terms.txt $(TMP_DATA)/mp_terms.txt $(TMP_DATA)/zp_terms.txt
	test -d profiles || mkdir -p profiles
	runoak --stacktrace -vvv  -i semsimian:sqlite:$< similarity -p i \
	--set1-file $(TMP_DATA)/hp_terms.txt \
	--set2-file $(TMP_DATA)/zp_terms.txt \
	--min-ancestor-information-content 4.0 \
	--low-memory \
 	--min-jaccard-similarity 0.7 \
	--autolabel \
	-O csv \
	-o $@






run-semsim: profiles/upheno1-hp-mp.semsimian.0.tsv

profiles/upheno1-hp-mp.semsimian.0.tsv: $(ONTOLOGYDIR)/upheno1.db $(TMP_DATA)/hp_terms.txt $(TMP_DATA)/mp_terms.txt $(TMP_DATA)/zp_terms.txt
	test -d profiles || mkdir -p profiles
	runoak --stacktrace -vvv  -i semsimian:sqlite:$< similarity -p i \
	--set1-file $(TMP_DATA)/hp_terms.txt \
	--set2-file $(TMP_DATA)/mp_terms.txt \
	--min-ancestor-information-content 4.0 \
	--low-memory \
 	--min-jaccard-similarity 0 \
	--autolabel \
	-O csv \
	-o $@




run-semsim: profiles/upheno1-hp-hp.semsimian.0.tsv

profiles/upheno1-hp-hp.semsimian.0.tsv: $(ONTOLOGYDIR)/upheno1.db $(TMP_DATA)/hp_terms.txt $(TMP_DATA)/mp_terms.txt $(TMP_DATA)/zp_terms.txt
	test -d profiles || mkdir -p profiles
	runoak --stacktrace -vvv  -i semsimian:sqlite:$< similarity -p i \
	--set1-file $(TMP_DATA)/hp_terms.txt \
	--set2-file $(TMP_DATA)/hp_terms.txt \
	--min-ancestor-information-content 4.0 \
	--low-memory \
 	--min-jaccard-similarity 0 \
	--autolabel \
	-O csv \
	-o $@




run-semsim: profiles/upheno1-hp-zp.semsimian.0.tsv

profiles/upheno1-hp-zp.semsimian.0.tsv: $(ONTOLOGYDIR)/upheno1.db $(TMP_DATA)/hp_terms.txt $(TMP_DATA)/mp_terms.txt $(TMP_DATA)/zp_terms.txt
	test -d profiles || mkdir -p profiles
	runoak --stacktrace -vvv  -i semsimian:sqlite:$< similarity -p i \
	--set1-file $(TMP_DATA)/hp_terms.txt \
	--set2-file $(TMP_DATA)/zp_terms.txt \
	--min-ancestor-information-content 4.0 \
	--low-memory \
 	--min-jaccard-similarity 0 \
	--autolabel \
	-O csv \
	-o $@




run-semsim: profiles/upheno1-hp-mp.semsimian.0.7.tsv

profiles/upheno1-hp-mp.semsimian.0.7.tsv: $(ONTOLOGYDIR)/upheno1.db $(TMP_DATA)/hp_terms.txt $(TMP_DATA)/mp_terms.txt $(TMP_DATA)/zp_terms.txt
	test -d profiles || mkdir -p profiles
	runoak --stacktrace -vvv  -i semsimian:sqlite:$< similarity -p i \
	--set1-file $(TMP_DATA)/hp_terms.txt \
	--set2-file $(TMP_DATA)/mp_terms.txt \
	--min-ancestor-information-content 4.0 \
	--low-memory \
 	--min-jaccard-similarity 0.7 \
	--autolabel \
	-O csv \
	-o $@




run-semsim: profiles/upheno1-hp-hp.semsimian.0.7.tsv

profiles/upheno1-hp-hp.semsimian.0.7.tsv: $(ONTOLOGYDIR)/upheno1.db $(TMP_DATA)/hp_terms.txt $(TMP_DATA)/mp_terms.txt $(TMP_DATA)/zp_terms.txt
	test -d profiles || mkdir -p profiles
	runoak --stacktrace -vvv  -i semsimian:sqlite:$< similarity -p i \
	--set1-file $(TMP_DATA)/hp_terms.txt \
	--set2-file $(TMP_DATA)/hp_terms.txt \
	--min-ancestor-information-content 4.0 \
	--low-memory \
 	--min-jaccard-similarity 0.7 \
	--autolabel \
	-O csv \
	-o $@




run-semsim: profiles/upheno1-hp-zp.semsimian.0.7.tsv

profiles/upheno1-hp-zp.semsimian.0.7.tsv: $(ONTOLOGYDIR)/upheno1.db $(TMP_DATA)/hp_terms.txt $(TMP_DATA)/mp_terms.txt $(TMP_DATA)/zp_terms.txt
	test -d profiles || mkdir -p profiles
	runoak --stacktrace -vvv  -i semsimian:sqlite:$< similarity -p i \
	--set1-file $(TMP_DATA)/hp_terms.txt \
	--set2-file $(TMP_DATA)/zp_terms.txt \
	--min-ancestor-information-content 4.0 \
	--low-memory \
 	--min-jaccard-similarity 0.7 \
	--autolabel \
	-O csv \
	-o $@





.PHONY: generate-mappings
generate-mappings: $(TMP_DATA)/hp-lexmatch.sssom.tsv

generate-mappings: $(TMP_DATA)/mp-lexmatch.sssom.tsv

generate-mappings: $(TMP_DATA)/zp-lexmatch.sssom.tsv


### 2.2
$(TMP_DATA)/%-lexmatch.sssom.tsv: $(ONTOLOGYDIR)/%.owl
	runoak -i $< lexmatch -o $@


# Obtain lexmatch results then combine to upheno2

### 3

upheno1-equivalent-inferred.owl: $(ONTOLOGYDIR)/upheno1-equivalent.owl
	$(ROBOT) merge -i $< reason --reasoner ELK --axiom-generators "EquivalentClass" -o $@

generate-ontologies: upheno1-equivalent-inferred.owl

.PHONY: install

install:
	pip install oaklib -U
	pip install semsimian -U

include ./custom.Makefile