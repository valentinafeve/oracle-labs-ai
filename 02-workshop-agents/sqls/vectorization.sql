-- Generar los embeddings para cada chunk de texto utilizando el modelo de Cohere
UPDATE TEST_NEWS
SET EMBED = DBMS_VECTOR_CHAIN.UTL_TO_EMBEDDING(
    CHUNK_DATA, 
    JSON('{
        "provider": "ocigenai",
        "credential_name": "OCI_CRED_AI",
        "url": "https://inference.generativeai.us-chicago-1.oci.oraclecloud.com/20231130/actions/embedText",
        "model": "cohere.embed-multilingual-v3.0"
    }')
);
COMMIT;