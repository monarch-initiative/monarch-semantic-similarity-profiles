from pathlib import Path
from tempfile import NamedTemporaryFile

import polars as pl
import pytest

from monarch_semsim.exomiser.exomiserdb import _prepare_rows, semsim_to_exomisersql


@pytest.fixture
def sample_input_file():
    with NamedTemporaryFile(mode='w', delete=False, suffix='.tsv') as f:
        f.write("subject_id\tsubject_label\tobject_id\tobject_label\tjaccard_similarity\tancestor_information_content\tphenodigm_score\tancestor_id\tancestor_label\n")
        f.write("HP:0000001\tAbnormality\tMP:0000001\tMammalian Phenotype\t0.5\t0.8\t0.7\tHP:0000118,MP:0000001\tPhenotypic abnormality\n")
        f.write("HP:0000002\tAbnormality of body height\tMP:0000002\tabnormal body height\t0.6\t0.9\t0.8\tHP:0000118,MP:0000002\tPhenotypic abnormality\n")
    return Path(f.name)

def test_semsim_file_to_sql(sample_input_file):
    output_file = Path("test_output.sql")
    semsim_to_exomisersql(sample_input_file, "HP", "MP", output_file)
    
    assert output_file.exists()
    with open(output_file, 'r') as f:
        content = f.read()
        assert "TRUNCATE TABLE EXOMISER.MP_HP_MAPPINGS;" in content
        assert "INSERT INTO EXOMISER.MP_HP_MAPPINGS" in content
        assert "(1, 'HP:0000001', 'Abnormality', 'MP:0000001', 'Mammalian Phenotype', 0.5, 0.8, 0.7, 'HP:0000118', 'Phenotypic abnormality')" in content
        assert "(2, 'HP:0000002', 'Abnormality of body height', 'MP:0000002', 'abnormal body height', 0.6, 0.9, 0.8, 'HP:0000118', 'Phenotypic abnormality')" in content
    
    output_file.unlink()

def test_prepare_insert_statements():
    batch = pl.DataFrame({
        'subject_id': ['HP:0000001', 'HP:0000002'],
        'subject_label': ['Abnormality', 'Abnormality of body height'],
        'object_id': ['MP:0000001', 'MP:0000002'],
        'object_label': ['Mammalian Phenotype', 'abnormal body height'],
        'jaccard_similarity': [0.5, 0.6],
        'ancestor_information_content': [0.8, 0.9],
        'phenodigm_score': [0.7, 0.8],
        'ancestor_id': ['HP:0000118,MP:0000001', 'HP:0000118,MP:0000002'],
        'ancestor_label': ['Phenotypic abnormality', 'Phenotypic abnormality']
    })
    
    result = _prepare_rows(batch, "HP", "MP", 1)
    
    assert "INSERT INTO EXOMISER.HP_MP_MAPPINGS" in result
    assert "(MAPPING_ID, HP_ID, HP_TERM, MP_ID, MP_TERM, SIMJ, IC, SCORE, LCS_ID, LCS_TERM)" in result
    assert "(1, 'HP:0000001', 'Abnormality', 'MP:0000001', 'Mammalian Phenotype', 0.5, 0.8, 0.7, 'HP:0000118', 'Phenotypic abnormality')" in result
    assert "(2, 'HP:0000002', 'Abnormality of body height', 'MP:0000002', 'abnormal body height', 0.6, 0.9, 0.8, 'HP:0000118', 'Phenotypic abnormality')" in result

def test_semsim_file_to_sql_large_file(tmp_path):
    large_file = tmp_path / "large.tsv"
    with open(large_file, 'w') as f:
        f.write("subject_id\tsubject_label\tobject_id\tobject_label\tjaccard_similarity\tancestor_information_content\tphenodigm_score\tancestor_id\tancestor_label\n")
        for i in range(100000):
            f.write(f"HP:{i:07d}\tLabel{i}\tMP:{i:07d}\tObject{i}\t0.5\t0.8\t0.7\tHP:0000118,MP:0000001\tPhenotypic abnormality\n")
    
    output_file = tmp_path / "large_output.sql"
    semsim_to_exomisersql(large_file, "HP", "MP", output_file)
    
    assert output_file.exists()
    assert output_file.stat().st_size > 0

