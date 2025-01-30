# Monarch Semantic Similarity Profiles
- **Profiles Directory**: `profiles`

## Ontologies used


- **Ontology ID**: `phenio-flat`
  

- **Ontology ID**: `phenio-release`
  - **Mirror From**: [https://github.com/monarch-initiative/phenio/releases/latest/download/phenio.owl.gz](https://github.com/monarch-initiative/phenio/releases/latest/download/phenio.owl.gz)
  

- **Ontology ID**: `phenio-equivalent`
  

- **Ontology ID**: `phenio-monarch`
  

- **Ontology ID**: `upheno1`
  - **Mirror From**: [https://raw.githubusercontent.com/obophenotype/upheno/refs/heads/master/upheno.owl](https://raw.githubusercontent.com/obophenotype/upheno/refs/heads/master/upheno.owl)
  

- **Ontology ID**: `hp`
  - **Mirror From**: [http://purl.obolibrary.org/obo/hp.owl](http://purl.obolibrary.org/obo/hp.owl)
  
  - **Parent Term**: `HP:0000118`


- **Ontology ID**: `mp`
  - **Mirror From**: [http://purl.obolibrary.org/obo/mp.owl](http://purl.obolibrary.org/obo/mp.owl)
  
  - **Parent Term**: `MP:0000001`
  

- **Ontology ID**: `zp`
  - **Mirror From**: [http://purl.obolibrary.org/obo/zp.owl](http://purl.obolibrary.org/obo/zp.owl)
  
  - **Parent Term**: `ZP:0000000`
  

- **Ontology ID**: `fbcv`
  - **Mirror From**: [http://purl.obolibrary.org/obo/dpo.owl](http://purl.obolibrary.org/obo/dpo.owl)
  
  - **Parent Term**: `FBcv:0001347`
  

- **Ontology ID**: `xpo`
  - **Mirror From**: [http://purl.obolibrary.org/obo/xpo.owl](http://purl.obolibrary.org/obo/xpo.owl)
  
  - **Parent Term**: `XPO:00000000`
  


## Semantic Similarity Profiles


- **Subset**: `hp-mp`
  - **Method**: `semsimian`
  - **Ontology**: `phenio-release`
  - **Threshold**: `0.7`
  - **Branches**:
    - **Subject**: `UPHENO:0001001`
    - **Object**: `UPHENO:0001001`
  
  - **Prefixes**:
    - **Subject**: `hp`
    - **Object**: `mp`
  
  

- **Subset**: `hp-hp`
  - **Method**: `semsimian`
  - **Ontology**: `phenio-release`
  - **Threshold**: `0.7`
  - **Branches**:
    - **Subject**: `UPHENO:0001001`
    - **Object**: `UPHENO:0001001`
  
  - **Prefixes**:
    - **Subject**: `hp`
    - **Object**: `hp`
  
  

- **Subset**: `hp-zp`
  - **Method**: `semsimian`
  - **Ontology**: `upheno1`
  - **Threshold**: `0.7`
  - **Branches**:
    - **Subject**: `UPHENO:0001001`
    - **Object**: `UPHENO:0001001`
  
  - **Prefixes**:
    - **Subject**: `hp`
    - **Object**: `zp`
  
  

- **Subset**: `hp-hp`
  - **Method**: `semsimian`
  - **Ontology**: `phenio-monarch`
  - **Threshold**: `0.7`
  
  - **Prefixes**:
    - **Subject**: `hp`
    - **Object**: `hp`
  
  
  - **IC**: `phenio_monarch_hp_ic.tsv`
  

- **Subset**: `hp-mp`
  - **Method**: `semsimian`
  - **Ontology**: `phenio-monarch`
  - **Threshold**: `0.7`
  
  - **Prefixes**:
    - **Subject**: `hp`
    - **Object**: `mp`
  
  
  - **IC**: `phenio_monarch_hp_mp_ic.tsv`
  

- **Subset**: `hp-zp`
  - **Method**: `semsimian`
  - **Ontology**: `phenio-monarch`
  - **Threshold**: `0.7`
  
  - **Prefixes**:
    - **Subject**: `hp`
    - **Object**: `zp`
  
  
  - **IC**: `phenio_monarch_hp_zp_ic.tsv`
  

- **Subset**: `hp-xpo`
  - **Method**: `semsimian`
  - **Ontology**: `phenio-monarch`
  - **Threshold**: `0.4`
  
  - **Prefixes**:
    - **Subject**: `hp`
    - **Object**: `xpo`
  
  
  - **IC**: `phenio_monarch_hp_xpo_ic.tsv`
  

- **Subset**: `hp-hp`
  - **Method**: `semsimian`
  - **Ontology**: `phenio-monarch`
  - **Threshold**: `0.4`
  
  - **Prefixes**:
    - **Subject**: `hp`
    - **Object**: `hp`
  
  

- **Subset**: `hp-mp`
  - **Method**: `semsimian`
  - **Ontology**: `phenio-monarch`
  - **Threshold**: `0.4`
  
  - **Prefixes**:
    - **Subject**: `hp`
    - **Object**: `mp`
  
  

- **Subset**: `hp-zp`
  - **Method**: `semsimian`
  - **Ontology**: `phenio-monarch`
  - **Threshold**: `0.4`
  
  - **Prefixes**:
    - **Subject**: `hp`
    - **Object**: `zp`
  
  

- **Subset**: `hp-xpo`
  - **Method**: `semsimian`
  - **Ontology**: `phenio-monarch`
  - **Threshold**: `0.4`
  
  - **Prefixes**:
    - **Subject**: `hp`
    - **Object**: `xpo`
  
  

- **Subset**: `hp-hp`
  - **Method**: `semsimian`
  - **Ontology**: `phenio-monarch`
  - **Threshold**: `0.7`
  
  - **Prefixes**:
    - **Subject**: `hp`
    - **Object**: `hp`
  
  

- **Subset**: `hp-mp`
  - **Method**: `semsimian`
  - **Ontology**: `phenio-monarch`
  - **Threshold**: `0.7`
  
  - **Prefixes**:
    - **Subject**: `hp`
    - **Object**: `mp`
  
  

- **Subset**: `hp-zp`
  - **Method**: `semsimian`
  - **Ontology**: `phenio-monarch`
  - **Threshold**: `0.7`
  
  - **Prefixes**:
    - **Subject**: `hp`
    - **Object**: `zp`
  
  

- **Subset**: `hp-xpo`
  - **Method**: `semsimian`
  - **Ontology**: `phenio-monarch`
  - **Threshold**: `0.4`
  
  - **Prefixes**:
    - **Subject**: `hp`
    - **Object**: `xpo`
  
  

- **Subset**: `hp-fbcv`
  - **Method**: `semsimian`
  - **Ontology**: `phenio-monarch`
  - **Threshold**: `0.4`
  
  - **Prefixes**:
    - **Subject**: `hp`
    - **Object**: `fbcv`
  
  

- **Subset**: `hp-hp`
  - **Method**: `semsimian`
  - **Ontology**: `phenio-flat`
  - **Threshold**: `0.7`
  
  - **Prefixes**:
    - **Subject**: `hp`
    - **Object**: `hp`
  
  

- **Subset**: `hp-mp`
  - **Method**: `semsimian`
  - **Ontology**: `phenio-flat`
  - **Threshold**: `0.7`
  
  - **Prefixes**:
    - **Subject**: `hp`
    - **Object**: `mp`
  
  

- **Subset**: `hp-zp`
  - **Method**: `semsimian`
  - **Ontology**: `phenio-flat`
  - **Threshold**: `0.7`
  
  - **Prefixes**:
    - **Subject**: `hp`
    - **Object**: `zp`
  
  

- **Subset**: `hp-hp`
  - **Method**: `semsimian`
  - **Ontology**: `phenio-equivalent`
  - **Threshold**: `0.7`
  
  - **Prefixes**:
    - **Subject**: `hp`
    - **Object**: `hp`
  
  

- **Subset**: `hp-mp`
  - **Method**: `semsimian`
  - **Ontology**: `phenio-equivalent`
  - **Threshold**: `0.7`
  
  - **Prefixes**:
    - **Subject**: `hp`
    - **Object**: `mp`
  
  

- **Subset**: `hp-zp`
  - **Method**: `semsimian`
  - **Ontology**: `phenio-equivalent`
  - **Threshold**: `0.7`
  
  - **Prefixes**:
    - **Subject**: `hp`
    - **Object**: `zp`
  
  


