# Guía especial (Workshop 7): acceso a GenAI en Chicago

Esta guía aplica **solo** para algunos participantes del workshop que no pueden usar su región/tenancy para GenAI.

En este caso especial, debes usar **exactamente** las credenciales compartidas en esta carpeta para conectarte a GenAI en `us-chicago-1`.

## Regla principal

- **No uses OCID de tu tenancy** para esta configuración.
- Usa los OCID de este folder + la llave `oci_key.pem`.

---

## Valores a usar (fijos)

Tomados de `aux_agent_factory_setup_credentials_chicago/config`:

```ini
user=ocid1.user.oc1..aaaaaaaagbsdk72nw6bydzlx24koayr7ejvvunkdcmhhvetr45fwyil6ol5q
fingerprint=14:f6:0b:37:e2:84:c1:93:9a:45:c7:b3:6d:1e:8a:f5
tenancy=ocid1.tenancy.oc1..aaaaaaaawmgrl6cmpuwoy3cqcu3hmimwy7rlkwiais6omfs7oxtwblhf4apq
region=us-chicago-1
compartment=ocid1.compartment.oc1..aaaaaaaaztbtmijprvr2ooneisonmbh7bz2nhg4qfxe7u6aakwdsd3tehzka
```

Nota: en `config` aparece `conpartment` (typo). El valor correcto es `Compartment ID`.

---

## Configuración en Agent Factory (copiar y pegar)

### 1) Modelo de chat

```yaml
Model id: meta.llama-4-maverick-17b-128e-instruct-fp8
Endpoint: https://inference.generativeai.us-chicago-1.oci.oraclecloud.com
Compartment ID: ocid1.compartment.oc1..aaaaaaaaztbtmijprvr2ooneisonmbh7bz2nhg4qfxe7u6aakwdsd3tehzka
User ID: ocid1.user.oc1..aaaaaaaagbsdk72nw6bydzlx24koayr7ejvvunkdcmhhvetr45fwyil6ol5q
Tenancy ID: ocid1.tenancy.oc1..aaaaaaaawmgrl6cmpuwoy3cqcu3hmimwy7rlkwiais6omfs7oxtwblhf4apq
Fingerprint: 14:f6:0b:37:e2:84:c1:93:9a:45:c7:b3:6d:1e:8a:f5
```

### 2) Modelo de embeddings

```yaml
Model id: cohere.embed-multilingual-image-v3.0
Endpoint: https://inference.generativeai.us-chicago-1.oci.oraclecloud.com
Compartment ID: ocid1.compartment.oc1..aaaaaaaaztbtmijprvr2ooneisonmbh7bz2nhg4qfxe7u6aakwdsd3tehzka
User ID: ocid1.user.oc1..aaaaaaaagbsdk72nw6bydzlx24koayr7ejvvunkdcmhhvetr45fwyil6ol5q
Tenancy ID: ocid1.tenancy.oc1..aaaaaaaawmgrl6cmpuwoy3cqcu3hmimwy7rlkwiais6omfs7oxtwblhf4apq
Fingerprint: 14:f6:0b:37:e2:84:c1:93:9a:45:c7:b3:6d:1e:8a:f5
```

---

## Llave privada (archivo)

En Agent Factory Settings, cuando pida la llave privada:

1. Haz clic en **Upload/Browse**.
2. Carga este archivo:

`07-workshop-AI-Database-Agent-Factory/aux_agent_factory_setup_credentials_chicago/oci_key.pem`

3. No pegues texto manualmente; solo carga el archivo.

---

## Checklist rápido

Antes de continuar con el lab:

- Endpoint quedó en `us-chicago-1`.
- User/Tenancy/Compartment/Fingerprint coinciden exactamente con esta guía.
- Se cargó el archivo `oci_key.pem`.
- La prueba de conexión del modelo es exitosa.

---

## Si falla la conexión

1. Revisa que no hayas dejado OCIDs de tu tenancy.
2. Revisa que el endpoint sea exactamente:
   `https://inference.generativeai.us-chicago-1.oci.oraclecloud.com`
3. Vuelve a cargar `oci_key.pem` en Settings.
