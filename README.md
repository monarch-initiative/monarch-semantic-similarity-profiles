# monarch-semantic-similarity-profiles


How to convert SEMSIM file to SQL:

```bash
monarch_semsim semsim-to-exomisersql \
    -i semsim_profile.tsv \
    --subject-prefix HP \
    --object-prefix MP \
    -o semsim_profile.sql
```