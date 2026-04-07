-- Crear credenciales para acceder al bucket desde la DB. 
-- Reemplaza los valores de los parámetros con tus propias credenciales de OCI.
BEGIN
    DBMS_CLOUD.CREATE_CREDENTIAL(
        credential_name => 'OCI_CRED',
        user_ocid => 'ocid1.user.oc1..',
        tenancy_ocid => 'ocid1.tenancy.oc1..',
        private_key => '-----BEGIN PRIVATE KEY-----',
        fingerprint => '1a:2b:3c:4d:5e:6f:7g:8h:9i:0j:1k:2l:3m:4n:5o:6p'
    );
END;

-- Crear credenciales para acceder a OCI generative AI desde la DB. 
-- Reemplaza los valores de los parámetros con tus propias credenciales de OCI.
DECLARE
    params JSON_OBJECT_T;
BEGIN
    params := JSON_OBJECT_T();
    params.PUT('user_ocid', 'ocid1.user.oc1..');
    params.PUT('tenancy_ocid', 'ocid1.tenancy.oc1..');
    params.PUT('compartment_ocid', 'ocid1.compartment.oc1..');
    params.PUT('private_key', '-----BEGIN RSA PRIVATE KEY-----');
    params.PUT('fingerprint', '1a:2b:3c:4d:5e:6f:7g:8h:9i:0j:1k:2l:3m:4n:5o:6p');
    DBMS_VECTOR.CREATE_CREDENTIAL(
        credential_name => 'OCI_CRED_AI',
        params => JSON(params.TO_STRING)
    );
END;

--- Crear ACL para permitir que la DB acceda a OCI generative AI
BEGIN
    DBMS_NETWORK_ACL_ADMIN.create_acl(
        acl => 'oci_genai_acl.xml',
        description => 'Permite acceso HTTP a OCI Generative AI',
        principal => 'ADMIN',
        is_grant => TRUE,
        privilege => 'connect',
        start_date => NULL,
        end_date => NULL
    );

    DBMS_NETWORK_ACL_ADMIN.assign_acl(
        acl => 'oci_genai_acl.xml',
        host => 'inference.generativeai.us-chicago-1.oci.oraclecloud.com',
        lower_port => 443,
        upper_port => 443
    );
END;