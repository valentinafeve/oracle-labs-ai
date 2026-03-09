```sql
BEGIN DBMS_CLOUD.DROP_CREDENTIAL(credential_name => 'OCI_CRED'); EXCEPTION WHEN OTHERS THEN NULL; END;
/

DECLARE
  jo json_object_t;
BEGIN
  jo := json_object_t();
  jo.put('user_ocid', 'ocid1.user.oc1..aaaaaaaawkcgks5aykamgencpwt7npi5jmtonjbasavbgh75s3l2jfo5bzrq');
  jo.put('tenancy_ocid', 'ocid1.tenancy.oc1..aaaaaaaa2nob7ly6wpz4t4v4oqfruufirexnmo3du3o5hydjvo3c2ctgmsfq');
  jo.put('compartment_ocid', 'ocid1.compartment.oc1..aaaaaaaaosjahglkvoi42xd2mv7bidhdez7fqwttl4thiv7n4yadqy7mtciq');
  jo.put('private_key', q'[MIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQClaUs5GctNJmcg
1Gqhg6gk0XgcFfze8J963EPAcp7XMQu6XQEoWscxz5j3gBeD6YpdyrYsXcS+yYV/
Gvmcjlj0l2mpezsYvSy2pxR/twuGFPGGk2OuRz0h7adA73uy8XiAkX1BJxBasNPb
BWZSAAJZQ8jncDSZ6CLG3pmres51TZpYWZBLh3V6Q14QovQX5eHWLvoq0wptkEcG
79GV6UnDg2WCcmece8j3oPdrsjMYTG3+pC7bXli8R2iaY2srZgOQs9o+RCT3oDpK
0wWvYDWoLduasXdqZTPQziZDe9WWVlLpr5+X6SOWeoYGkH4ayTHk7DKy8hV8dwNl
JY/C+TMHAgMBAAECggEAN/7/MiNjSYjYnKqMNoVFZMFsscVXx3kZ5BOw8/NZhmva
Forpm2mvyVMH67F3RHbJGptHNJnBwvyhrrfJDJC72IFxiahoByXzfxnsvJeQ1SE9
6lr3AcaoEVZMqpToAVnxe0TFbEr3JFx8O8cGLnhGU0W5O3AmvntxWnV8/Cokvlyt
rHZYaLHRenbqMsKet47o5ieqcTsVotrrH/Knw67ZWmtyaZjUwENEH6lBIhQ2g8r6
0LeW50SCD/HJlak+UgEGMblqVpWrZxKihu7asQXQg9sC2uDawO1rCy3iljvdn7M3
uKe7amb5OZAS8f06Df0Yzhu9WbuHBS9HoEDOfSIK4QKBgQDRdy8fZnO//3v1UYGX
lgnwYr2ODrcyg8HIR5y6TWJNbZKCwAba81B0SfPGRDfZB2GII5eIAAkThVSqsoaz
jhefgJVpUQYqOvqaLAEUtxHMj/DjA4Ys09BmWBnNlrTw9G2uU6Cdnjl5cAIf/UIg
77bCmz548ua8nhNfzAG0nbVIbwKBgQDKKKMOwb4WxYXWh9OwKVxdZVAjMn/f99TX
eIZlU/GRub4PK/xhbH99icZiM6ujhaZlgF9vgbrAGQSttiqgo0p3I7dgMglRA/q9
hrj/q/uXHYFdavqUKYOz00vmWNaiOFePhIyMk/Sf94P0YNxQWJ0rDnSFvUPPM9eY
P9kHo9Ea6QKBgHV8qyKqnWvoigecMtrqXiLFz1pZqKmdu1hxyle4xdV2CwJpYK74
YH0JacEgTE7f0/W/OOQgWPbpBwdDYUhe/6MIRUWwG4weTqeg3O5YjJQ3fD5ooJ6O
I8rzyW1GBbFM+CQaZfFiaQxTJe35aFj++3yGBPFkFMVgyK8nxyEegCrjAoGAQh6W
bk4p2RLTmn4kW5q7jgSD+G8c6ekKIUtXUa7p9Mq2ggnV6xtse2fjjdzuh3ZAHTSm
gjcBGLFWGWbafF3MDjmNUZYr++Z8TR7SRTU//YX1+NLzkCAf5mH2kil+UeJxqQwm
WBhQSz3OV9CSXmkNRrbcn51un0eKfU5sspX+33kCgYAXukjrHUrxKdN4sbnOH5sZ
vTYhupcC0q8QtPDMT1poLviiQIeBbLFvsdBlloLix/ZFy+Byox/Cn5/d6F+eFtkK
IQ6lM/M5oSlbkPveZCcRFekYqnO21RwLah+641z33VzYy/RL20YEDhCf5ticj7/Z
7TWf/ZG3SD11ap66NUqXLA==]');
  jo.put('fingerprint', 'c7:b1:a2:50:bc:d7:f4:b1:93:5d:1b:66:b5:0d:e9:a1');
  
  dbms_vector.create_credential(
    credential_name => 'OCI_CRED',
    params => json(jo.to_string)
  );
END;
/
```


[DEFAULT]
user=ocid1.user.oc1..aaaaaaaawkcgks5aykamgencpwt7npi5jmtonjbasavbgh75s3l2jfo5bzrq
fingerprint=c7:b1:a2:50:bc:d7:f4:b1:93:5d:1b:66:b5:0d:e9:a1
tenancy=ocid1.tenancy.oc1..aaaaaaaa2nob7ly6wpz4t4v4oqfruufirexnmo3du3o5hydjvo3c2ctgmsfq
region=us-chicago-1
key_file=<path to your private keyfile> # TODO

ocid1.compartment.oc1..aaaaaaaaosjahglkvoi42xd2mv7bidhdez7fqwttl4thiv7n4yadqy7mtciq