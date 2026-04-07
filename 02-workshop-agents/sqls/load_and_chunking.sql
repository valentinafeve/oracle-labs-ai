-- Opcion 1: Insertar datos de MOVII_INFO con el texto formateado manualmente
INSERT INTO MOVII_INFO (DOC_ID, CHUNK_ID, CHUNK_DATA)
SELECT
1 AS DOC_ID,
JSON_VALUE(COLUMN_VALUE, '$.chunk_id' RETURNING NUMBER) AS CHUNK_ID,
JSON_VALUE(COLUMN_VALUE, '$.chunk_data') AS CHUNK_DATA
FROM DBMS_VECTOR_CHAIN.UTL_TO_CHUNKS('
TARIFAS MOVii:
*Tarifas aplicables desde el 08 de marzo de 2026.

ENVIAR Y RECIBIR DINERO:
Enviar dinero a otros usuarios MOVii $0,
Pedir y recibir dinero de otros usuarios MOVii $0.

RECARGAR TU CUENTA:
Recargar tu cuenta MOVii desde redes aliadas $0,
Recargar tu cuenta MOVii con PSE $0.

TU TARJETA MOVii:
Pedir tu Tarjeta MOVii MasterCard $10.000,
Reposición de una nueva tarjeta* $15.000,
Cuota de manejo de tu app MOVii $0,
Cuota de manejo de tu tarjeta MOVii$0,
Comprar con tu tarjeta MOVii MasterCard® $0,
Franquicia Mastercard® $5.000,
*El cobro de reposición de tarjeta aplica para todos los usuarios MOVii con o sin subsidio. 
**Inactividad de más de 3 meses en tarjeta MOVii genera cargo de Franquicia Mastercard de $5.000.

TU CUENTA MOVii:
Inactividad* de 6 a 11 meses..$10.000,
Inactividad de 12 a 23 meses..$30.000,
Inactividad por más de 24 meses $50.000,
Cambio de número** $1.500.

RETIRAR DINERO CON O SIN TARJETA:
Retirar tu subsidio en MOVii (Primer retiro***) $0,
Retirar dinero desde la app en puntos aliados $3.000,
(En Colombia o en el extranjero)

PRODUCTOS BÁSICOS:
Retirar dinero sin tarjeta en cajeros Servibanca Red Verde $6.000,
Retira dinero sin tarjeta en otros cajeros corporativos Servibanca $7.500,
Retirar dinero con tu Tarjeta MOVii en otros cajeros**** (Desde)$6.500,
Recargar tu celular, paquetes de voz y datos $0, 
Pagar tus facturas $0,
Comprar contenidos digitales (Netflix, Spotify, etc.) $0,
*Inactividad significa no haber realizado al menos 1 transacción en los periodos de tiempo mencionados.
**Cada cambio de celular tendrá un valor de $1.500 pesos que se aplicará al momento del cambio exito
so.
***El primer retiro no tiene costo. A partir del segundo, se aplican las tarifas vigentes estándar para todos 
los usuarios.
****El costo del retiro puede variar de acuerdo con la red de cajeros que utilices, te invitamos
a hacer retiro sin tarjeta desde tu App MOVii en cajeros Servibanca. Este valor corresponde al costo de la 
transacción, mas no del producto adquirido.

PRODUCTOS AVANZADOS:
Envía giros internacionales (Desde)$7.500,
Recibir giros internacionales $0,
Cargar la plataforma para hacer apuestas deportivas $0,
Enviar transferencias interbancarias $4.000,
Pagar en comercios con PSE $0,
Enviar dinero a través de Bre-B $0,
Recibir dinero a través de Bre-B $0,
Cobrar con QR $0,
Pagar con QR $0,
Generar QR $0,
*El valor de giro varía según el valor a enviar.
', 
   JSON('{
        "by": "words",
        "max": 30,
        "split": "none",
        "overlap": 10,
        "language": "SPANISH",
        "normalize": "all"
    }')
);

-- Opcion 2: Insertar datos de MOVII_INFO extrayendo el texto de un PDF almacenado en OCI
INSERT INTO MOVII_INFO (DOC_ID, CHUNK_ID, CHUNK_DATA)
SELECT
1 AS DOC_ID,
JSON_VALUE(COLUMN_VALUE, '$.chunk_id' RETURNING NUMBER) AS CHUNK_ID,
JSON_VALUE(COLUMN_VALUE, '$.chunk_data') AS CHUNK_DATA
FROM DBMS_VECTOR_CHAIN.UTL_TO_CHUNKS(
    REGEXP_REPLACE(DBMS_VECTOR_CHAIN.UTL_TO_TEXT(
        TO_BLOB(
            DBMS_CLOUD.GET_OBJECT(
                'OCI_CRED', 
                'https://objectstorage.<region>.oraclecloud.com/n/<namespace>/b/<bucket_name>/o/Tarifario_2026.pdf'
            )
        )
    ),
    '\.{2,}', ' '), 
    JSON('{
        "by": "words",
        "max": 30,
        "split": "none",
        "overlap": 10,
        "language": "SPANISH",
        "normalize": "all"
    }')
);

-- Opcion 3: Insertar datos de MOVII_INFO extrayendo el texto de multiples PDFs almacenados en OCI
CREATE SEQUENCE doc_ids START WITH 1 INCREMENT BY 1;
DROP SEQUENCE doc_ids;
DECLARE
  bucket_base_uri VARCHAR2(4000) := 'https://objectstorage.<region>.oraclecloud.com/n/<namespace>/b/<bucket_name>/o/';
  doc_id NUMBER;
BEGIN
  FOR i IN (
    SELECT object_name
    FROM TABLE(
      DBMS_CLOUD.LIST_OBJECTS(
        credential_name => 'OCI_CRED',
        location_uri => bucket_base_uri
      )
    )
    WHERE LOWER(object_name) LIKE '%.pdf'
  )
  LOOP
    doc_id := doc_ids.NEXTVAL;

    INSERT INTO TEST_NEWS (doc_id, doc_name, chunk_id, chunk_data)
    SELECT
      doc_id,
      i.object_name AS doc_name,
      JSON_VALUE(column_value, '$.chunk_id' RETURNING NUMBER) AS chunk_id,
      JSON_VALUE(column_value, '$.chunk_data') AS chunk_data
    FROM DBMS_VECTOR_CHAIN.UTL_TO_CHUNKS(
      REGEXP_REPLACE(
        DBMS_VECTOR_CHAIN.UTL_TO_TEXT(
          TO_BLOB(
            DBMS_CLOUD.GET_OBJECT(
              credential_name => 'OCI_CRED',
              object_uri      => bucket_base_uri || UTL_URL.ESCAPE(i.object_name, TRUE)
            )
          )
        ),
        '\.{2,}', ' '
      ),
      JSON('{
        "by": "words",
        "max": 30,
        "split": "none",
        "overlap": 10,
        "language": "SPANISH",
        "normalize": "all"
      }')
    );
    COMMIT;
  END LOOP;
END;