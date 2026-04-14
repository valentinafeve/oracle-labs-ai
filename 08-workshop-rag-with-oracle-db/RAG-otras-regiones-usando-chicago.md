## Datos del ambiente donador de Chicago

Estos son los datos que vamos a usar:

```ini
user=ocid1.user.oc1..aaaaaaaawkcgks5aykamgencpwt7npi5jmtonjbasavbgh75s3l2jfo5bzrq
fingerprint=c7:b1:a2:50:bc:d7:f4:b1:93:5d:1b:66:b5:0d:e9:a1
tenancy=ocid1.tenancy.oc1..aaaaaaaa2nob7ly6wpz4t4v4oqfruufirexnmo3du3o5hydjvo3c2ctgmsfq
region=us-chicago-1
compartment_ocid=ocid1.compartment.oc1..aaaaaaaaosjahglkvoi42xd2mv7bidhdez7fqwttl4thiv7n4yadqy7mtciq
```

## Antes de comenzar

Ejecuta todo como `ADMIN` en una `Autonomous Database` 23ai o 26ai. Lo ideal es 26ai, porque es la base sobre la que fue planteado el laboratorio.

Antes de correr los scripts, valida lo siguiente:

1. Tu base tiene acceso de salida HTTPS.
2. Tu base tiene disponibles `DBMS_CLOUD`, `DBMS_VECTOR` y `DBMS_VECTOR_CHAIN`.
3. Tu base tiene acceso al directorio `DATA_PUMP_DIR`.

## Orden recomendado

Sigue exactamente este orden:

1. Crear la credencial OCI.
2. Autorizar salida de red.
3. Probar conexión con GenAI en Chicago.
4. Crear tablas.
5. Descargar el PDF y el modelo ONNX desde Chicago.
6. Cargar el modelo ONNX.
7. Insertar el PDF en la tabla.
8. Generar embeddings.
9. Probar similarity search.
10. Crear la función RAG.
11. Ejecutar la prueba final.

## Paso 1. Crear la credencial OCI usando el ambiente de Chicago

Este script crea la credencial `OCI_CRED` que permitirá:

1. Llamar al endpoint de GenAI en Chicago.
2. Descargar archivos desde `Object Storage` en Chicago.

Ejecuta este bloque completo:

```sql
BEGIN
  DBMS_CLOUD.DROP_CREDENTIAL(credential_name => 'OCI_CRED');
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/

DECLARE
  l_user_ocid        VARCHAR2(2000) := 'ocid1.user.oc1..aaaaaaaawkcgks5aykamgencpwt7npi5jmtonjbasavbgh75s3l2jfo5bzrq';
  l_tenancy_ocid     VARCHAR2(2000) := 'ocid1.tenancy.oc1..aaaaaaaa2nob7ly6wpz4t4v4oqfruufirexnmo3du3o5hydjvo3c2ctgmsfq';
  l_fingerprint      VARCHAR2(200)  := 'c7:b1:a2:50:bc:d7:f4:b1:93:5d:1b:66:b5:0d:e9:a1';
  l_private_key      CLOB := q'[MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC2CfeOfNtUSe2U
TKQIavQ8dOLhB/MKMqPBITVtHQXr6lsYRLSUDRrQWQcO33oGj/AvXJb2lGCqVsjy
vrAAMLt73ujYy3/e/VwhZz2EzN2UC/qPojQ0GX7WJPQ/LODPKagEHq7sVCZjeRgv
L2HWpFCTN+aK8ud04urJ10pCMN1mtnMyXU0IjbERXbZNb/S39ijWrVfKPPtHAQH7
JRd10/W4dPfAX8kF85ctgj6uHOTKH/9InQI2BahuIbEaZA1ZdD2Zg7oidCsB7s2Q
BCWINRsYu+6OeVvsN88tfBQWE5Le2EyCRH48iIwLUL1WvHTY6mlEaPKqO1cIryas
Zfm+MOEHAgMBAAECggEAALq6Vm9DgLzy0iLrG2uvOy4J2zKkLpMDlhQegXBe+C7/
OOWLThSZ6Tot3A0SvAJemXx+G3+rqfTynSj5wYCirpUd3cpR7zqiwkVtSW6r48tQ
2KJuNfYsOuxGzp5FXhjcJwaVWbD4qq5evYGVIGoxwynMo4nLDsklKAcpSpHrVq2r
5onnMU5mTvFZh8LpBniYWqiS0xuwLJC45L9+dnGpRD7rSXqM8bovYLcCFFtYeNZ7
2ZJKCe2WgGarIpeaVIVoqSaWP8KSwdGo+dSaKiUyerZlrTfRPm2GXO53ayDrWcBm
3Zv185c+QB1fKiqcrd6KI+cY3BI9mww90h2B945ALQKBgQDb94IfLT43AsIlOhpC
csFt7QNbjs1f+TpOKssYU7VE5s61e7qSnkfuyHHb480iNtnOStDPMlHK19Nvl36G
1l9qRmjby/c4Cr9RCaCkKBKLukzmcu7sZZvqvzWpZUPcm9RLIv0I/bKQz5N4Askt
NgaI3pEipWq2KIL/XKDd2rc8dQKBgQDT2+vBgiwnpvk6h0TVomisihUJgxr56m44
WWlv3j7RmLmcE0a5j3xSXm/nd3GeDvufJWcKGMwE79ti3wd0QDjwN2x2uGWtwkxP
tYbrxx5xhcdHo6WMqEHfYQ0Va7cXwS2hCkCEbhSTbG5KqX0Rs7B54csabrrdiJyL
jEFQy4MoCwKBgFKk4Je0GO70M1tnRBx5HyGc7ikFMzZ+3iAmRd4i/TUg/sMC9KtH
msElQFoccaMMNrMiOufOARsUEdWYdqpUes7kG1uRe5Xru8vHsTpb7/PdkCz5O7lH
x9ff9VpquJ93UMDWKXmqT9/GjaKGcW1yIexkquT4f2pnOCiXdb1FAplNAoGANinM
fT19cmnC4A7DL2cFIc9vj24AUJJ5uVhKl3oXT1ifY2KeO0SOwTQ5odCssH8eH1Ld
o/ww9LYpvX5Nlo/wvqE8zqFYBXNeNSawpsjSZK2SBCO3aF1/8c8LHEXcmmsd8kT/
t5u5EPOwws/QFN1+qbprRYe3qHmLpDWoYTKWhn8CgYEAzN31qpu5xPeaFOe3g0vT
rMico+sCHfzUpw1MGaa4XJRMmg+cqijyUGm+ab9+b4G+1L+C7ukvcFxVP1ESXPCE
AU+wta1xpUM1EcXeuwL6mRyIYP3TDZL3qfE/UWszRRkqV1ed9eHun8xxkGDPb916
t451mRsOkDVeLs1Ouq6CRys=]';
BEGIN
  DBMS_CLOUD.CREATE_CREDENTIAL(
    credential_name => 'OCI_CRED',
    user_ocid       => l_user_ocid,
    tenancy_ocid    => l_tenancy_ocid,
    private_key     => l_private_key,
    fingerprint     => l_fingerprint
  );
END;
/

```

Cuando termine este paso, la base ya tendrá una credencial para usar recursos del ambiente de Chicago.

## Paso 2. Autorizar salida de red desde la base

Este paso permite que la base haga conexiones HTTPS externas.

Ejecuta:

```sql
BEGIN
  DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE(
    host => '*',
    ace  => xs$ace_type(
      privilege_list => xs$name_list('connect'),
      principal_name => 'ADMIN',
      principal_type => xs_acl.ptype_db
    )
  );
END;
/
```

## Paso 3. Probar que sí puedes llamar GenAI en Chicago

Antes de cargar documentos o embeddings, conviene probar primero la conectividad al modelo.

Ejecuta este bloque:

```sql
SET SERVEROUTPUT ON

DECLARE
  p_region           VARCHAR2(200) := 'us-chicago-1';
  p_endpoint         VARCHAR2(500) := 'https://inference.generativeai.' || p_region || '.oci.oraclecloud.com';
  p_compartment_ocid VARCHAR2(200) := 'ocid1.compartment.oc1..aaaaaaaaosjahglkvoi42xd2mv7bidhdez7fqwttl4thiv7n4yadqy7mtciq';

  resp          DBMS_CLOUD_TYPES.resp;
  json_response CLOB;
BEGIN
  resp := DBMS_CLOUD.SEND_REQUEST(
    credential_name => 'OCI_CRED',
    uri             => p_endpoint || '/20231130/actions/chat',
    method          => 'POST',
    body            => UTL_RAW.CAST_TO_RAW(
      JSON_OBJECT(
        'compartmentId' VALUE p_compartment_ocid,
        'servingMode' VALUE JSON_OBJECT(
          'modelId' VALUE 'meta.llama-4-maverick-17b-128e-instruct-fp8',
          'servingType' VALUE 'ON_DEMAND'
        ),
        'chatRequest' VALUE JSON_OBJECT(
          'messages' VALUE JSON_ARRAY(
            JSON_OBJECT(
              'role' VALUE 'USER',
              'content' VALUE JSON_ARRAY(
                JSON_OBJECT(
                  'type' VALUE 'TEXT',
                  'text' VALUE 'Responde solo: conexion exitosa desde otra region'
                )
              )
            )
          ),
          'apiFormat' VALUE 'GENERIC',
          'maxTokens' VALUE 100,
          'isStream' VALUE FALSE,
          'numGenerations' VALUE 1,
          'frequencyPenalty' VALUE 0,
          'presencePenalty' VALUE 0,
          'temperature' VALUE 0,
          'topP' VALUE 1,
          'topK' VALUE 1
        )
      )
    )
  );

  json_response := DBMS_CLOUD.GET_RESPONSE_TEXT(resp);
  DBMS_OUTPUT.PUT_LINE(json_response);
END;
/
```

Si este paso responde correctamente, ya confirmaste que tu base puede hablar con el servicio de GenAI en Chicago.

## Paso 4. Crear las tablas del laboratorio

Ahora vamos a crear las tablas donde se almacenarán:

1. El documento original.
2. Los chunks.
3. Los vectores generados.

### 4.1 Tabla de documentos

```sql
CREATE TABLE IF NOT EXISTS TB_DATA (
  ID           INTEGER GENERATED BY DEFAULT ON NULL AS IDENTITY
               (START WITH 1 CACHE 20) PRIMARY KEY,
  FILE_NAME    VARCHAR2(900),
  FILE_SIZE    INTEGER,
  FILE_TYPE    VARCHAR2(100),
  FILE_CONTENT BLOB
);
```

### 4.2 Tabla de vectores

```sql
CREATE TABLE IF NOT EXISTS TB_VECTOR_DATA (
  VEC_ID       NUMBER NOT NULL,
  EMBED_ID     NUMBER,
  EMBED_DATA   VARCHAR2(4000 BYTE),
  EMBED_VECTOR VECTOR,
  CONSTRAINT TB_VECTOR_DATA_FK1 FOREIGN KEY (VEC_ID) REFERENCES TB_DATA(ID)
);
```

## Paso 5. Descargar desde Chicago los artefactos del laboratorio

En este paso se reutiliza el `Object Storage` del ambiente donador.

### 5.1 Descargar el PDF de ejemplo

```sql
BEGIN
  DBMS_CLOUD.GET_OBJECT(
    credential_name => 'OCI_CRED',
    object_uri      => 'https://objectstorage.us-chicago-1.oraclecloud.com/n/idi1o0a010nx/b/labs/o/relatorelato-a.pdf',
    directory_name  => 'DATA_PUMP_DIR'
  );
END;
/
```

### 5.2 Descargar el modelo ONNX para embeddings

```sql
BEGIN
  DBMS_CLOUD.GET_OBJECT(
    credential_name => 'OCI_CRED',
    object_uri      => 'https://objectstorage.us-chicago-1.oraclecloud.com/n/idi1o0a010nx/b/labs/o/modeall-MiniLM-L6.onnx',
    directory_name  => 'DATA_PUMP_DIR'
  );
END;
/
```

Cuando termine este paso, ambos archivos deben existir dentro de `DATA_PUMP_DIR`.

## Paso 6. Cargar el modelo ONNX dentro de la base

Aquí es donde habilitas el modelo de embeddings para que la base pueda vectorizar localmente.

Ejecuta:

```sql
BEGIN
  DBMS_VECTOR.LOAD_ONNX_MODEL(
    directory  => 'DATA_PUMP_DIR',
    file_name  => 'modeall-MiniLM-L6.onnx',
    model_name => 'ALL_MINILM_L6',
    metadata   => JSON('{
      "function":"embedding",
      "embeddingOutput":"embedding",
      "input":{"input":["DATA"]}
    }')
  );
END;
/
```

## Paso 7. Insertar el PDF dentro de la tabla `TB_DATA`

Ahora guardamos el documento en la tabla de documentos.

```sql
INSERT INTO TB_DATA (
  FILE_NAME,
  FILE_SIZE,
  FILE_TYPE,
  FILE_CONTENT
)
VALUES (
  'relatorelato-a.pdf',
  DBMS_LOB.GETLENGTH(TO_BLOB(BFILENAME('DATA_PUMP_DIR', 'relatorelato-a.pdf'))),
  'PDF',
  TO_BLOB(BFILENAME('DATA_PUMP_DIR', 'relatorelato-a.pdf'))
);

COMMIT;
```

## Paso 8. Generar embeddings del documento

Este paso:

1. Extrae el texto del PDF.
2. Lo divide en chunks.
3. Aplica el modelo `ALL_MINILM_L6`.
4. Guarda los vectores en `TB_VECTOR_DATA`.

Ejecuta:

```sql
INSERT INTO TB_VECTOR_DATA (
  VEC_ID,
  EMBED_ID,
  EMBED_DATA,
  EMBED_VECTOR
)
SELECT
  id,
  embed_id,
  text_chunk,
  embed_vector
FROM TB_DATA dt
CROSS JOIN TABLE(
  DBMS_VECTOR_CHAIN.UTL_TO_EMBEDDINGS(
    DBMS_VECTOR_CHAIN.UTL_TO_CHUNKS(
      DBMS_VECTOR_CHAIN.UTL_TO_TEXT(dt.file_content),
      JSON('{"by":"words","max":"100","split":"sentence","normalize":"all"}')
    ),
    JSON('{"provider":"database","model":"ALL_MINILM_L6"}')
  )
) t
CROSS JOIN JSON_TABLE(
  t.column_value,
  '$[*]' COLUMNS (
    embed_id     NUMBER         PATH '$.embed_id',
    text_chunk   VARCHAR2(4000) PATH '$.embed_data',
    embed_vector CLOB           PATH '$.embed_vector'
  )
) et
WHERE dt.file_name = 'relatorelato-a.pdf';

COMMIT;
```

Recuerda: en este punto la base ya no depende de un endpoint remoto para vectorizar. El embedding lo está haciendo localmente con el modelo cargado.

## Paso 9. Probar la búsqueda semántica

Antes de crear la función final de RAG, conviene confirmar que la búsqueda vectorial sí funciona.

Ejecuta:

```sql
SELECT embed_data
FROM TB_VECTOR_DATA,
     (SELECT VECTOR_EMBEDDING(ALL_MINILM_L6 USING 'Que le sucedio a la familia Gomez Ramirez' AS data) AS embedding FROM dual) query_vector
ORDER BY VECTOR_DISTANCE(EMBED_VECTOR, query_vector.embedding, COSINE)
FETCH APPROX FIRST 4 ROWS ONLY;
```

Si este query devuelve fragmentos del documento, entonces la parte vectorial del laboratorio ya está funcionando.

## Paso 10. Crear la función RAG final

Esta función hace el flujo completo:

1. Calcula el embedding de la pregunta.
2. Busca los fragmentos más cercanos.
3. Construye el contexto.
4. Envía ese contexto al modelo de GenAI en Chicago.
5. Devuelve la respuesta final en lenguaje natural.

Ejecuta:

```sql
CREATE OR REPLACE FUNCTION GENERATE_TEXT_RESPONSE_GEN (
  p_user_question VARCHAR2
) RETURN CLOB IS
  messages           CLOB := EMPTY_CLOB();
  output_text        CLOB := EMPTY_CLOB();

  p_region           VARCHAR2(200) := 'us-chicago-1';
  p_endpoint         VARCHAR2(500) := 'https://inference.generativeai.' || p_region || '.oci.oraclecloud.com';
  p_compartment_ocid VARCHAR2(200) := 'ocid1.compartment.oc1..aaaaaaaaosjahglkvoi42xd2mv7bidhdez7fqwttl4thiv7n4yadqy7mtciq';

  resp          DBMS_CLOUD_TYPES.resp;
  json_response CLOB;

  l_root     JSON_OBJECT_T;
  l_chat     JSON_OBJECT_T;
  l_choices  JSON_ARRAY_T;
  l_choice0  JSON_OBJECT_T;
  l_message  JSON_OBJECT_T;
  l_content  JSON_ARRAY_T;
  l_part0    JSON_OBJECT_T;
  l_text     VARCHAR2(32767);
BEGIN
  FOR message_cursor IN (
    SELECT embed_data
    FROM TB_VECTOR_DATA,
         (SELECT VECTOR_EMBEDDING(ALL_MINILM_L6 USING p_user_question AS data) AS embedding FROM dual) query_vector
    ORDER BY VECTOR_DISTANCE(EMBED_VECTOR, query_vector.embedding, COSINE)
    FETCH APPROX FIRST 4 ROWS ONLY
  ) LOOP
    messages := messages || '- ' || message_cursor.embed_data || CHR(10) || CHR(10);
  END LOOP;

  messages := messages
              || 'Pregunta del usuario:' || CHR(10)
              || p_user_question;

  resp := DBMS_CLOUD.SEND_REQUEST(
    credential_name => 'OCI_CRED',
    uri             => p_endpoint || '/20231130/actions/chat',
    method          => 'POST',
    body            => UTL_RAW.CAST_TO_RAW(
      JSON_OBJECT(
        'compartmentId' VALUE p_compartment_ocid,
        'servingMode' VALUE JSON_OBJECT(
          'modelId' VALUE 'meta.llama-4-maverick-17b-128e-instruct-fp8',
          'servingType' VALUE 'ON_DEMAND'
        ),
        'chatRequest' VALUE JSON_OBJECT(
          'messages' VALUE JSON_ARRAY(
            JSON_OBJECT(
              'role' VALUE 'USER',
              'content' VALUE JSON_ARRAY(
                JSON_OBJECT(
                  'type' VALUE 'TEXT',
                  'text' VALUE messages
                )
              )
            )
          ),
          'apiFormat' VALUE 'GENERIC',
          'maxTokens' VALUE 4000,
          'isStream' VALUE FALSE,
          'numGenerations' VALUE 1,
          'frequencyPenalty' VALUE 0,
          'presencePenalty' VALUE 0,
          'temperature' VALUE 1,
          'topP' VALUE 1,
          'topK' VALUE 1
        )
      )
    )
  );

  json_response := DBMS_CLOUD.GET_RESPONSE_TEXT(resp);

  l_root    := JSON_OBJECT_T.parse(json_response);
  l_chat    := l_root.get_object('chatResponse');
  l_choices := l_chat.get_array('choices');

  IF l_choices.get_size = 0 THEN
    RETURN TO_CLOB('ERROR: No choices returned by model. Full response: ') || json_response;
  END IF;

  l_choice0 := TREAT(l_choices.get(0) AS JSON_OBJECT_T);
  l_message := l_choice0.get_object('message');
  l_content := l_message.get_array('content');

  IF l_content.get_size = 0 THEN
    RETURN TO_CLOB('ERROR: No content blocks returned by model. Full response: ') || json_response;
  END IF;

  l_part0 := TREAT(l_content.get(0) AS JSON_OBJECT_T);
  l_text  := l_part0.get_string('text');

  output_text := TO_CLOB(l_text);
  RETURN output_text;
END;
/
```

## Paso 11. Ejecutar la prueba final end-to-end

Ya con todo listo, ejecuta:

```sql
SELECT GENERATE_TEXT_RESPONSE_GEN('Que le sucedio a la familia Gomez Ramirez')
FROM dual;
```

Si este query devuelve una respuesta en lenguaje natural, entonces el laboratorio quedó operativo desde tu base, usando el ambiente de Chicago para GenAI y el modelo ONNX para embeddings locales.

## Qué deben entender las personas que van a ejecutar este instructivo

Si alguien te pregunta "¿qué se está reutilizando de Chicago?", la respuesta correcta es esta:

1. El endpoint de `Generative AI` en `us-chicago-1`.
2. El bucket de `Object Storage` donde está el PDF y el modelo ONNX.
3. La credencial OCI asociada al ambiente donador.

Si alguien te pregunta "¿qué se ejecuta en mi propia base?", la respuesta es:

1. La carga del PDF.
2. La carga del modelo ONNX.
3. La generación de embeddings.
4. La búsqueda vectorial.
5. La función SQL que arma el contexto y llama al LLM.

## Script de reinicio de credencial si algo falla

Si en algún momento necesitas recrear la credencial, ejecuta:

```sql
BEGIN
  DBMS_CLOUD.DROP_CREDENTIAL('OCI_CRED');
END;
/
```

Y luego vuelve a correr el Paso 1.

## Resumen 


1. Corre los scripts en su propia Autonomous Database.
2. Usa la credencial del ambiente donador de Chicago.
3. Llama al endpoint GenAI de Chicago.
4. Descarga desde Chicago el modelo ONNX.
5. Genera embeddings localmente en su propia base.
6. Ejecuta el flujo RAG completo desde su región.
