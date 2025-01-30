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
	test -d $(MIRRORDIR) || mkdir -p $(MIRRORDIR)
	if [ $(MIR) = true ] && [ -f $(TMP_DATA)/mirror-$*.owl ]; then mkdir -p $(MIRRORDIR) && if cmp -s $(TMP_DATA)/mirror-$*.owl $@ ; then echo "Mirror identical, ignoring."; else echo "Mirrors different, updating." &&\
		cp $(TMP_DATA)/mirror-$*.owl $@; fi; fi
.PRECIOUS: $(MIRRORDIR)/%.owl

$(ONTOLOGYDIR)/%.owl: $(MIRRORDIR)/%.owl
	test -d $(ONTOLOGYDIR) || mkdir -p $(ONTOLOGYDIR)
	cp $< $@

%.db: %.owl
	@rm -f $*.db
	@rm -f .template.db
	@rm -f .template.db.tmp
	@rm -f $*-relation-graph.tsv.gz
	RUST_BACKTRACE=full semsql make $*.db -P config/prefixes.csv
	@rm -f .template.db
	@rm -f .template.db.tmp
	@rm -f $*-relation-graph.tsv.gz
	@test -f $*.db || (echo "Error: File not found!" && exit 1)

.PRECIOUS: %.db

###############################################################
## General rules for generating semantic similarity profiles ##
###############################################################

.PHONY: generate-ontologies
generate-ontologies: $(ONTOLOGYDIR)/phenio-flat.owl $(ONTOLOGYDIR)/phenio-flat.db




generate-ontologies: $(ONTOLOGYDIR)/phenio-release.owl $(ONTOLOGYDIR)/phenio-release.db

mirror-phenio-release:
	mkdir -p $(TMP_DATA)
	if [ $(MIR) = true ]; then curl -L https://github.com/monarch-initiative/phenio/releases/latest/download/phenio.owl.gz --create-dirs -o $(TMP_DATA)/phenio-release-download.owl  --max-time 600 &&\
		$(ROBOT) merge -i $(TMP_DATA)/phenio-release-download.owl convert -o $@.tmp.owl && mv $@.tmp.owl $(TMP_DATA)/$@.owl; fi



generate-ontologies: $(ONTOLOGYDIR)/phenio-equivalent.owl $(ONTOLOGYDIR)/phenio-equivalent.db




generate-ontologies: $(ONTOLOGYDIR)/phenio-monarch.owl $(ONTOLOGYDIR)/phenio-monarch.db




generate-ontologies: $(ONTOLOGYDIR)/upheno1.owl $(ONTOLOGYDIR)/upheno1.db

mirror-upheno1:
	mkdir -p $(TMP_DATA)
	if [ $(MIR) = true ]; then curl -L https://raw.githubusercontent.com/obophenotype/upheno/refs/heads/master/upheno.owl --create-dirs -o $(TMP_DATA)/upheno1-download.owl  --max-time 600 &&\
		$(ROBOT) merge -i $(TMP_DATA)/upheno1-download.owl convert -o $@.tmp.owl && mv $@.tmp.owl $(TMP_DATA)/$@.owl; fi



generate-ontologies: $(ONTOLOGYDIR)/hp.owl $(ONTOLOGYDIR)/hp.db

mirror-hp:
	mkdir -p $(TMP_DATA)
	if [ $(MIR) = true ]; then curl -L http://purl.obolibrary.org/obo/hp.owl --create-dirs -o $(TMP_DATA)/hp-download.owl  --max-time 600 &&\
		$(ROBOT) merge -i $(TMP_DATA)/hp-download.owl convert -o $@.tmp.owl && mv $@.tmp.owl $(TMP_DATA)/$@.owl; fi


$(TMP_DATA)/hp_terms.txt: $(ONTOLOGYDIR)/hp.db
	runoak -i sqlite:$< descendants -p i HP:0000118 -o $@


generate-ontologies: $(ONTOLOGYDIR)/mp.owl $(ONTOLOGYDIR)/mp.db

mirror-mp:
	mkdir -p $(TMP_DATA)
	if [ $(MIR) = true ]; then curl -L http://purl.obolibrary.org/obo/mp.owl --create-dirs -o $(TMP_DATA)/mp-download.owl  --max-time 600 &&\
		$(ROBOT) merge -i $(TMP_DATA)/mp-download.owl convert -o $@.tmp.owl && mv $@.tmp.owl $(TMP_DATA)/$@.owl; fi


$(TMP_DATA)/mp_terms.txt: $(ONTOLOGYDIR)/mp.db
	runoak -i sqlite:$< descendants -p i MP:0000001 -o $@


generate-ontologies: $(ONTOLOGYDIR)/zp.owl $(ONTOLOGYDIR)/zp.db

mirror-zp:
	mkdir -p $(TMP_DATA)
	if [ $(MIR) = true ]; then curl -L http://purl.obolibrary.org/obo/zp.owl --create-dirs -o $(TMP_DATA)/zp-download.owl  --max-time 600 &&\
		$(ROBOT) merge -i $(TMP_DATA)/zp-download.owl convert -o $@.tmp.owl && mv $@.tmp.owl $(TMP_DATA)/$@.owl; fi


$(TMP_DATA)/zp_terms.txt: $(ONTOLOGYDIR)/zp.db
	runoak -i sqlite:$< descendants -p i ZP:0000000 -o $@


generate-ontologies: $(ONTOLOGYDIR)/fbcv.owl $(ONTOLOGYDIR)/fbcv.db

mirror-fbcv:
	mkdir -p $(TMP_DATA)
	if [ $(MIR) = true ]; then curl -L http://purl.obolibrary.org/obo/dpo.owl --create-dirs -o $(TMP_DATA)/fbcv-download.owl  --max-time 600 &&\
		$(ROBOT) merge -i $(TMP_DATA)/fbcv-download.owl convert -o $@.tmp.owl && mv $@.tmp.owl $(TMP_DATA)/$@.owl; fi


$(TMP_DATA)/fbcv_terms.txt: $(ONTOLOGYDIR)/fbcv.db
	runoak -i sqlite:$< descendants -p i FBcv:0001347 -o $@


generate-ontologies: $(ONTOLOGYDIR)/xpo.owl $(ONTOLOGYDIR)/xpo.db

mirror-xpo:
	mkdir -p $(TMP_DATA)
	if [ $(MIR) = true ]; then curl -L http://purl.obolibrary.org/obo/xpo.owl --create-dirs -o $(TMP_DATA)/xpo-download.owl  --max-time 600 &&\
		$(ROBOT) merge -i $(TMP_DATA)/xpo-download.owl convert -o $@.tmp.owl && mv $@.tmp.owl $(TMP_DATA)/$@.owl; fi


$(TMP_DATA)/xpo_terms.txt: $(ONTOLOGYDIR)/xpo.db
	runoak -i sqlite:$< descendants -p i XPO:00000000 -o $@

###############################################################
## General rules for generating semantic similarity profiles ##
###############################################################

run-semsim: generate-ontologies
.PHONY: run-semsim

profiles/%.gz: profiles/%.tsv
	gzip -c $< > $@.tmp && mv $@.tmp $@



run-semsim: profiles/phenio-release-hp-mp.0.7.semsimian.tsv



profiles/phenio-release-hp-mp.0.7.semsimian.tsv: $(ONTOLOGYDIR)/phenio-release.db $(TMP_DATA)/hp_terms.txt $(TMP_DATA)/mp_terms.txt
	test -d profiles || mkdir -p profiles
	runoak --stacktrace -vvv  -i semsimian:sqlite:$< similarity -p i \
	--set1-file $(TMP_DATA)/hp_terms.txt \
	--set2-file $(TMP_DATA)/mp_terms.txt \
 	--min-jaccard-similarity 0.7 \
	-O csv \
	-o $@






  # endif method



run-semsim: profiles/phenio-release-hp-hp.0.7.semsimian.tsv



profiles/phenio-release-hp-hp.0.7.semsimian.tsv: $(ONTOLOGYDIR)/phenio-release.db $(TMP_DATA)/hp_terms.txt $(TMP_DATA)/hp_terms.txt
	test -d profiles || mkdir -p profiles
	runoak --stacktrace -vvv  -i semsimian:sqlite:$< similarity -p i \
	--set1-file $(TMP_DATA)/hp_terms.txt \
	--set2-file $(TMP_DATA)/hp_terms.txt \
 	--min-jaccard-similarity 0.7 \
	-O csv \
	-o $@






  # endif method



run-semsim: profiles/upheno1-hp-zp.0.7.semsimian.tsv



profiles/upheno1-hp-zp.0.7.semsimian.tsv: $(ONTOLOGYDIR)/upheno1.db $(TMP_DATA)/hp_terms.txt $(TMP_DATA)/zp_terms.txt
	test -d profiles || mkdir -p profiles
	runoak --stacktrace -vvv  -i semsimian:sqlite:$< similarity -p i \
	--set1-file $(TMP_DATA)/hp_terms.txt \
	--set2-file $(TMP_DATA)/zp_terms.txt \
 	--min-jaccard-similarity 0.7 \
	-O csv \
	-o $@






  # endif method



run-semsim: profiles/phenio-monarch-hp-hp.0.7.semsimian.tsv



profiles/phenio-monarch-hp-hp.0.7.semsimian.ic.tsv: $(ONTOLOGYDIR)/phenio-monarch.db $(TMP_DATA)/hp_terms.txt $(TMP_DATA)/hp_terms.txt $(TMP_DATA)/phenio_monarch_hp_ic.tsv
	test -d profiles || mkdir -p profiles
	runoak --stacktrace -vvv  -i semsimian:sqlite:$< similarity -p i \
	--set1-file $(TMP_DATA)/hp_terms.txt \
	--set2-file $(TMP_DATA)/hp_terms.txt \
 	--min-jaccard-similarity 0.7 \
	--information-content-file  $(TMP_DATA)/phenio_monarch_hp_ic.tsv \
	-O csv \
	-o $@





  # endif method



run-semsim: profiles/phenio-monarch-hp-mp.0.7.semsimian.tsv



profiles/phenio-monarch-hp-mp.0.7.semsimian.ic.tsv: $(ONTOLOGYDIR)/phenio-monarch.db $(TMP_DATA)/hp_terms.txt $(TMP_DATA)/mp_terms.txt $(TMP_DATA)/phenio_monarch_hp_mp_ic.tsv
	test -d profiles || mkdir -p profiles
	runoak --stacktrace -vvv  -i semsimian:sqlite:$< similarity -p i \
	--set1-file $(TMP_DATA)/hp_terms.txt \
	--set2-file $(TMP_DATA)/mp_terms.txt \
 	--min-jaccard-similarity 0.7 \
	--information-content-file  $(TMP_DATA)/phenio_monarch_hp_mp_ic.tsv \
	-O csv \
	-o $@





  # endif method



run-semsim: profiles/phenio-monarch-hp-zp.0.7.semsimian.tsv



profiles/phenio-monarch-hp-zp.0.7.semsimian.ic.tsv: $(ONTOLOGYDIR)/phenio-monarch.db $(TMP_DATA)/hp_terms.txt $(TMP_DATA)/zp_terms.txt $(TMP_DATA)/phenio_monarch_hp_zp_ic.tsv
	test -d profiles || mkdir -p profiles
	runoak --stacktrace -vvv  -i semsimian:sqlite:$< similarity -p i \
	--set1-file $(TMP_DATA)/hp_terms.txt \
	--set2-file $(TMP_DATA)/zp_terms.txt \
 	--min-jaccard-similarity 0.7 \
	--information-content-file  $(TMP_DATA)/phenio_monarch_hp_zp_ic.tsv \
	-O csv \
	-o $@





  # endif method



run-semsim: profiles/phenio-monarch-hp-xpo.0.4.semsimian.tsv



profiles/phenio-monarch-hp-xpo.0.4.semsimian.ic.tsv: $(ONTOLOGYDIR)/phenio-monarch.db $(TMP_DATA)/hp_terms.txt $(TMP_DATA)/xpo_terms.txt $(TMP_DATA)/phenio_monarch_hp_xpo_ic.tsv
	test -d profiles || mkdir -p profiles
	runoak --stacktrace -vvv  -i semsimian:sqlite:$< similarity -p i \
	--set1-file $(TMP_DATA)/hp_terms.txt \
	--set2-file $(TMP_DATA)/xpo_terms.txt \
 	--min-jaccard-similarity 0.4 \
	--information-content-file  $(TMP_DATA)/phenio_monarch_hp_xpo_ic.tsv \
	-O csv \
	-o $@





  # endif method



run-semsim: profiles/phenio-monarch-hp-hp.0.4.semsimian.tsv



profiles/phenio-monarch-hp-hp.0.4.semsimian.tsv: $(ONTOLOGYDIR)/phenio-monarch.db $(TMP_DATA)/hp_terms.txt $(TMP_DATA)/hp_terms.txt
	test -d profiles || mkdir -p profiles
	runoak --stacktrace -vvv  -i semsimian:sqlite:$< similarity -p i \
	--set1-file $(TMP_DATA)/hp_terms.txt \
	--set2-file $(TMP_DATA)/hp_terms.txt \
 	--min-jaccard-similarity 0.4 \
	-O csv \
	-o $@






  # endif method



run-semsim: profiles/phenio-monarch-hp-mp.0.4.semsimian.tsv



profiles/phenio-monarch-hp-mp.0.4.semsimian.tsv: $(ONTOLOGYDIR)/phenio-monarch.db $(TMP_DATA)/hp_terms.txt $(TMP_DATA)/mp_terms.txt
	test -d profiles || mkdir -p profiles
	runoak --stacktrace -vvv  -i semsimian:sqlite:$< similarity -p i \
	--set1-file $(TMP_DATA)/hp_terms.txt \
	--set2-file $(TMP_DATA)/mp_terms.txt \
 	--min-jaccard-similarity 0.4 \
	-O csv \
	-o $@






  # endif method



run-semsim: profiles/phenio-monarch-hp-zp.0.4.semsimian.tsv



profiles/phenio-monarch-hp-zp.0.4.semsimian.tsv: $(ONTOLOGYDIR)/phenio-monarch.db $(TMP_DATA)/hp_terms.txt $(TMP_DATA)/zp_terms.txt
	test -d profiles || mkdir -p profiles
	runoak --stacktrace -vvv  -i semsimian:sqlite:$< similarity -p i \
	--set1-file $(TMP_DATA)/hp_terms.txt \
	--set2-file $(TMP_DATA)/zp_terms.txt \
 	--min-jaccard-similarity 0.4 \
	-O csv \
	-o $@






  # endif method



run-semsim: profiles/phenio-monarch-hp-xpo.0.4.semsimian.tsv



profiles/phenio-monarch-hp-xpo.0.4.semsimian.tsv: $(ONTOLOGYDIR)/phenio-monarch.db $(TMP_DATA)/hp_terms.txt $(TMP_DATA)/xpo_terms.txt
	test -d profiles || mkdir -p profiles
	runoak --stacktrace -vvv  -i semsimian:sqlite:$< similarity -p i \
	--set1-file $(TMP_DATA)/hp_terms.txt \
	--set2-file $(TMP_DATA)/xpo_terms.txt \
 	--min-jaccard-similarity 0.4 \
	-O csv \
	-o $@






  # endif method



run-semsim: profiles/phenio-monarch-hp-hp.0.7.semsimian.tsv



profiles/phenio-monarch-hp-hp.0.7.semsimian.tsv: $(ONTOLOGYDIR)/phenio-monarch.db $(TMP_DATA)/hp_terms.txt $(TMP_DATA)/hp_terms.txt
	test -d profiles || mkdir -p profiles
	runoak --stacktrace -vvv  -i semsimian:sqlite:$< similarity -p i \
	--set1-file $(TMP_DATA)/hp_terms.txt \
	--set2-file $(TMP_DATA)/hp_terms.txt \
 	--min-jaccard-similarity 0.7 \
	-O csv \
	-o $@






  # endif method



run-semsim: profiles/phenio-monarch-hp-mp.0.7.semsimian.tsv



profiles/phenio-monarch-hp-mp.0.7.semsimian.tsv: $(ONTOLOGYDIR)/phenio-monarch.db $(TMP_DATA)/hp_terms.txt $(TMP_DATA)/mp_terms.txt
	test -d profiles || mkdir -p profiles
	runoak --stacktrace -vvv  -i semsimian:sqlite:$< similarity -p i \
	--set1-file $(TMP_DATA)/hp_terms.txt \
	--set2-file $(TMP_DATA)/mp_terms.txt \
 	--min-jaccard-similarity 0.7 \
	-O csv \
	-o $@






  # endif method



run-semsim: profiles/phenio-monarch-hp-zp.0.7.semsimian.tsv



profiles/phenio-monarch-hp-zp.0.7.semsimian.tsv: $(ONTOLOGYDIR)/phenio-monarch.db $(TMP_DATA)/hp_terms.txt $(TMP_DATA)/zp_terms.txt
	test -d profiles || mkdir -p profiles
	runoak --stacktrace -vvv  -i semsimian:sqlite:$< similarity -p i \
	--set1-file $(TMP_DATA)/hp_terms.txt \
	--set2-file $(TMP_DATA)/zp_terms.txt \
 	--min-jaccard-similarity 0.7 \
	-O csv \
	-o $@






  # endif method



run-semsim: profiles/phenio-monarch-hp-xpo.0.4.semsimian.tsv



profiles/phenio-monarch-hp-xpo.0.4.semsimian.tsv: $(ONTOLOGYDIR)/phenio-monarch.db $(TMP_DATA)/hp_terms.txt $(TMP_DATA)/xpo_terms.txt
	test -d profiles || mkdir -p profiles
	runoak --stacktrace -vvv  -i semsimian:sqlite:$< similarity -p i \
	--set1-file $(TMP_DATA)/hp_terms.txt \
	--set2-file $(TMP_DATA)/xpo_terms.txt \
 	--min-jaccard-similarity 0.4 \
	-O csv \
	-o $@






  # endif method



run-semsim: profiles/phenio-monarch-hp-fbcv.0.4.semsimian.tsv



profiles/phenio-monarch-hp-fbcv.0.4.semsimian.tsv: $(ONTOLOGYDIR)/phenio-monarch.db $(TMP_DATA)/hp_terms.txt $(TMP_DATA)/fbcv_terms.txt
	test -d profiles || mkdir -p profiles
	runoak --stacktrace -vvv  -i semsimian:sqlite:$< similarity -p i \
	--set1-file $(TMP_DATA)/hp_terms.txt \
	--set2-file $(TMP_DATA)/fbcv_terms.txt \
 	--min-jaccard-similarity 0.4 \
	-O csv \
	-o $@






  # endif method



run-semsim: profiles/phenio-flat-hp-hp.0.7.semsimian.tsv



profiles/phenio-flat-hp-hp.0.7.semsimian.tsv: $(ONTOLOGYDIR)/phenio-flat.db $(TMP_DATA)/hp_terms.txt $(TMP_DATA)/hp_terms.txt
	test -d profiles || mkdir -p profiles
	runoak --stacktrace -vvv  -i semsimian:sqlite:$< similarity -p i \
	--set1-file $(TMP_DATA)/hp_terms.txt \
	--set2-file $(TMP_DATA)/hp_terms.txt \
 	--min-jaccard-similarity 0.7 \
	-O csv \
	-o $@






  # endif method



run-semsim: profiles/phenio-flat-hp-mp.0.7.semsimian.tsv



profiles/phenio-flat-hp-mp.0.7.semsimian.tsv: $(ONTOLOGYDIR)/phenio-flat.db $(TMP_DATA)/hp_terms.txt $(TMP_DATA)/mp_terms.txt
	test -d profiles || mkdir -p profiles
	runoak --stacktrace -vvv  -i semsimian:sqlite:$< similarity -p i \
	--set1-file $(TMP_DATA)/hp_terms.txt \
	--set2-file $(TMP_DATA)/mp_terms.txt \
 	--min-jaccard-similarity 0.7 \
	-O csv \
	-o $@






  # endif method



run-semsim: profiles/phenio-flat-hp-zp.0.7.semsimian.tsv



profiles/phenio-flat-hp-zp.0.7.semsimian.tsv: $(ONTOLOGYDIR)/phenio-flat.db $(TMP_DATA)/hp_terms.txt $(TMP_DATA)/zp_terms.txt
	test -d profiles || mkdir -p profiles
	runoak --stacktrace -vvv  -i semsimian:sqlite:$< similarity -p i \
	--set1-file $(TMP_DATA)/hp_terms.txt \
	--set2-file $(TMP_DATA)/zp_terms.txt \
 	--min-jaccard-similarity 0.7 \
	-O csv \
	-o $@






  # endif method



run-semsim: profiles/phenio-equivalent-hp-hp.0.7.semsimian.tsv



profiles/phenio-equivalent-hp-hp.0.7.semsimian.tsv: $(ONTOLOGYDIR)/phenio-equivalent.db $(TMP_DATA)/hp_terms.txt $(TMP_DATA)/hp_terms.txt
	test -d profiles || mkdir -p profiles
	runoak --stacktrace -vvv  -i semsimian:sqlite:$< similarity -p i \
	--set1-file $(TMP_DATA)/hp_terms.txt \
	--set2-file $(TMP_DATA)/hp_terms.txt \
 	--min-jaccard-similarity 0.7 \
	-O csv \
	-o $@






  # endif method



run-semsim: profiles/phenio-equivalent-hp-mp.0.7.semsimian.tsv



profiles/phenio-equivalent-hp-mp.0.7.semsimian.tsv: $(ONTOLOGYDIR)/phenio-equivalent.db $(TMP_DATA)/hp_terms.txt $(TMP_DATA)/mp_terms.txt
	test -d profiles || mkdir -p profiles
	runoak --stacktrace -vvv  -i semsimian:sqlite:$< similarity -p i \
	--set1-file $(TMP_DATA)/hp_terms.txt \
	--set2-file $(TMP_DATA)/mp_terms.txt \
 	--min-jaccard-similarity 0.7 \
	-O csv \
	-o $@






  # endif method



run-semsim: profiles/phenio-equivalent-hp-zp.0.7.semsimian.tsv



profiles/phenio-equivalent-hp-zp.0.7.semsimian.tsv: $(ONTOLOGYDIR)/phenio-equivalent.db $(TMP_DATA)/hp_terms.txt $(TMP_DATA)/zp_terms.txt
	test -d profiles || mkdir -p profiles
	runoak --stacktrace -vvv  -i semsimian:sqlite:$< similarity -p i \
	--set1-file $(TMP_DATA)/hp_terms.txt \
	--set2-file $(TMP_DATA)/zp_terms.txt \
 	--min-jaccard-similarity 0.7 \
	-O csv \
	-o $@






  # endif method



.PHONY: upgrade
upgrade:
	echo "Upgrading dependencies, only use this if absolutely necessary"
	pip install oaklib -U
	pip install semsimian -U

include ./custom.Makefile