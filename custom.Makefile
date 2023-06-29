$(ONTOLOGYDIR)/upheno1-equivalent.owl: $(MIRRORDIR)/upheno1-equivalent.owl
	robot merge -i $< -o $@