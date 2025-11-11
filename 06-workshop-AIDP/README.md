# 📊 Hands On Lab: AI Data Platform (AIDP)
# 📈 Tarea 1

## Introducción

Este laboratorio guía paso a paso la configuración de un entorno de análisis de clientes usando Oracle AI Data Platform (AIDP), cubriendo desde la creación de buckets y clústeres hasta la integración, entrenamiento y despliegue de modelos de análisis de churn de clientes.

Hoy en dia las empresas estan buscando trabajar sobre una arquitectura medallon.

![AIDP Arquitectura Medallon](img/Picture0.png)

## Aprovisionamiento del Servicio AIDP

1. Acceder a Oracle Cloud, buscar la opcion **Analytics AI**<br>

![Analytics AI](img/Picture1.png)

2. Crear el servicio **AI Data Platform** sobre el compartment llamado `AIWORKSHOP`.<p>
Debes ingresar al botón de crear `Create AI Data Platform`. En la primera sección indicar el nombre del servicio “AIDP_DEMO” y una descripción opcional.

![AIDP Arquitectura Medallon](img/Picture2.png)

4. Crear un **workspace** para notebooks, modelos y otros servicios, por ejemplo: `customer_analytics`.En la sección del workspace debes indicar un nombre al espacio de trabajo para los notebooks, modelos y otros servicios de trabajo. Indica el nombre “CUSTOMER_ANALYTICS” y una descripción adicional. En el cual vamos a montar el ejercicio de análisis de clientes.

![AIDP Arquitectura Medallon](img/Picture3.png)

5. Seleccionar las políticas `Standard` durante el aprovisionamiento.En las políticas a generar indicar las políticas “Standard” con lo cual el servicio realiza todos los ajustes necesarios para poder levantar el servicio

![AIDP Arquitectura Medallon](img/Picture4.png)

6. Una vez activo, acceder al servicio y usar la URL para compartir con miembros del equipo. Hacer "click" en el hipervinculo.

![AIDP Arquitectura Medallon](img/Picture5.png)

Luego de algunos minutos el servicio estará activo con nombre “AIDP_DEMO” y solo se necesita darle click en el vinculo del servicio. Dicho servicio se abrirá en una nueva pestana del navegador y esa url podrá ser compartida con otros usuarios del equipo a la hora de trabajar y con SSO pueden ingresar a la plataforma.![AIDP Arquitectura Medallon](img/Picture6.png)

---
## Arquitectura Medallón - Creación de Catálogos
En la opcion Master Catalog se encuentra en blanco y para mantener la logica de una arquitectura medallon vamos a crear 3 catalogos para gobierno de los datos. 
Vamos a darle click en el boton de la derecha superior de `Create Catalog`

![AIDP Arquitectura Medallon](img/Picture7.png)

1. Ir a la opción **Master Catalog**.
2. Crear tres catálogos:
   - **bronze**
   - **silver**
   - **gold**
3. Para cada catálogo, seleccionar la opción `Standard Catalog` y asignar el compartment `AIWORKSHOP`.
   
![AIDP Arquitectura Medallon](img/Picture8.png)

### Creación de esquemas dentro de Bronze

- En el catálogo `bronze`, crear los esquemas:
    - **crm**: que hace alusión a un esquema de base de datos del crm empresarial
    - **historical**: que hace alusión de un esquema con datos históricos de la empresa.
    Vamos a dar click en el botón de create schema

![AIDP Arquitectura Medallon](img/Picture9.png)

- Debes indicar el nombre del esquema y una descripcion.
  
![AIDP Arquitectura Medallon](img/Picture10.png)

---
### Carga de datos en el esquema bronze
Vamos a realizar la carga de 3 tablas en diferentes esquemas.
- **customer** en catalogo `bronze` esquema `crm` de manera local
- **customer_review** en catalogo `bronze` esquema `crm` de manera externa al ir y buscar el archivo en un bucket.
- **labelled_customer** en catalogo `bronze` esquema `historical` de manera local

El archivo `customer_reviews` lo vamos a cargar en un `bucket` o espacio fisico del datalake, esto para probar que podemos cargar archivos tanto de manera local como de archivos que pueden conformar tablas a partir de datos que se encuentran en el `datalake`.
Nos vamos a ir a la opcion del menu de hamburguesa `Storage` y en `Buckets` hacemos click.<br>

![AIDP Arquitectura Medallon](img/Picture10-1.png)<p>

En el bucket de `aiworkshop` vamos a la opcion de objects (Si no existe debemos crear un bucker con el nombre `aiworkshop`).<br>

![AIDP Arquitectura Medallon](img/Picture10-2.png)<p>

Y ahi damos click en el boton de `Upload objects` para cargar el archivo `customer_reviews.csv`.<br>

![AIDP Arquitectura Medallon](img/Picture10-3.png)<p>

Luego de cargar el archivo en el bucket con el siguiente video se muestra como cargar los datos. Vaya a la opcion de `Create table` y siga los pasos para los archivos de customer y customer_reviews.

[![AIDP Arquitectura Medallon](img/black.png)](https://idi1o0a010nx.objectstorage.us-chicago-1.oci.customer-oci.com/n/idi1o0a010nx/b/archivos_publicos/o/Task-I.mp4)

Luego realice el mismo proceso para cargar el catalogo `historical` la tabla de `labelled_customer` con el archivo labelled_customer.csv similar a como cargo la tabla `customer` en el paso anterior, mediante una carga local.<br>

Es importante analizar que podemos cargar diferentes tipos de formatos de archivos como por ejemplo .AVRO o .PARQUET si desea hacer una prueba dejamos otra otros archivos que puede cargar de formato parquet.

---
# 📈 Tarea 2

## 1-Cargar los notebooks en el espacio de trabajo.
Se deben descargar los siguientes archivos y poder moverlos y cargarlos a el espacio de trabajo.

![AIDP Arquitectura Medallon](img/Picture11.png)

Todos los notebooks se deben descargar del git y subirse al AIDP.<p>

En el espacio de trabajo vamos a crear una carpeta nueva `work_area` para solamente guardar aqui el codigo. La logica del area o espacio de trabajo es tener diferentes espacios en los cuales se puedan guardar los codigos de programacion, los agentes, los modelos o cualquier otro proceso.<br>

![AIDP Arquitectura Medallon](img/Picture11-1.png)

En el icono de carga se pueden cargar los archivos al espacio de trabajo.

![AIDP Arquitectura Medallon](img/Picture12.png)

## 2-Creacion del cluster de Spark para ejecutar las tareas

Si abrimos el primer notebook a ejecutar nos daremos cuenta que en la esquena superior derecha, existe esta opción del cluster el cual indica el computo asignado para trabajar los Jobs de spark.<p> 
Al ser la primera vez que vamos a ejecutar un notebook necesitamos crearlo. Dar `click` en el boton de cluster.

![AIDP Arquitectura Medallon](img/Picture13.png)

Primero indicamos que vamos a crear un cluster nuevo sino existe, en caso de existir usar el cluster existente para correr cualquier de los notebooks.

![AIDP Arquitectura Medallon](img/Picture14.png)

Debemos indicar los siguientes elementos
-nombre del cluster “aisparkcluster”
-puedes agregar una descripción
-mantener la versión de spark en 3.5.0
- se necesita un nodo de driver (mantener la configuración incada 2 OCPUs 32 GB RAM)
- se necesita al menos 1 executor (mantener la configuración incada 2 OCPUs 32 GB RAM)
y luego que tengamos las configuraciones procedemos a darle click en el boton de crear cluster 

Nota:`Los tipos de procesadores disponibles serán un elemento de decisión en casos productivos de acuerdo a volumen y necesidad de procesamiento de los datos de las empresas. Para efectos del ejercicio con la configuración básica podemos trabajar este escenario.

![AIDP Arquitectura Medallon](img/Picture15.png)

Ahora Verificamos que el cluster de spark este atachado al notebook para poder ejecutarlo (Esperar a que se ponda en estado en verde y activo).<br>

![AIDP Arquitectura Medallon](img/Picture27.png)<br>
![AIDP Arquitectura Medallon](img/Picture27-1.png)<br>
![AIDP Arquitectura Medallon](img/Picture27-2.png)<br>


## 3-Ejecucion de los notebooks
### 📋 Notebook 01
Vamos a ejecutar la primera celda del notebook del primer notebook, donde ubicaremos en la parte superior derecha de cada celda el icono de play (▶️) y le daremos click para ejecutar el contenido de la celda **01_CleaseHistoricalData.ipynb**<p>En esta celda cargamos las librerias necesarias<p>

![AIDP Arquitectura Medallon](img/Picture16.png)<p>

La siguiente celda vamos leer los datos de la tabla historical.labeled_customers  hacia un dataframe llamado customer.<p>

![AIDP Arquitectura Medallon](img/Picture17.png)<p>

En el siguiente paso solo vamos a indicar algunas columnas con las cuales vamos a trabajar para crear un dataframe con los datos a usar.<p>

![AIDP Arquitectura Medallon](img/Picture18.png)<p>

Vamos a crear un nuevo dataframe filtrado con los datos que indicamos.<p>

![AIDP Arquitectura Medallon](img/Picture19.png)<p>

En el siguiente paso vamos a borrar los valores nulos NA’s dentro de los datos.<p>

![AIDP Arquitectura Medallon](img/Picture20.png)<p>

En el siguiente paso vamos a usar el modelo de meta:  `meta.llama-3.2-90b-vision-instruct` para poder hacer un analisis de sentimientos de los comentarios en reviews historicos que los clientes han realizado de sus servicios. Es importante entender que un tema de churn en las empresas de telecomunicaciones generalmente se dan por mala experiencia con sus servicios contratados.<p>

![AIDP Arquitectura Medallon](img/Picture21.png)<p>

En el paso anterior el resultado del modelo de NPL indicara el resultado en una columna `SentimentScore_str` que es un valor string. Vamos a convertir este valor a un valor entero.<p>

![AIDP Arquitectura Medallon](img/Picture22.png)<p>

Vamos a cambiar el valor de la columna churn (Yes/No) a valores numericos para poder trabajarlos de una manera apropiada en el modelo de ML<br>

![AIDP Arquitectura Medallon](img/Picture23.png)<p>

Finalmente vamos a verificar si en el esquema “silver” existe el esquema silver con los datos ya procesados y limpios. Sino existe va a crear dicha tabla en el esquema de datos ya procesados y trabajados posterior a su limpieza.<p>

![AIDP Arquitectura Medallon](img/Picture24.png)<p>

Luego de escribir los datos en el Catalogo silver vamos a verificar el nuevo esquema historical y la nueva tabla llamada customers (puedes dar click en icono de refrescar para visualizar la información creada) y con esto finaliza el primer laboratorio<br>

![AIDP Arquitectura Medallon](img/Picture25.png)<p>

### 📋 Notebook 02

La tarea del notebook_02 es integrar los datos de  `customers` y `customers_reviews` para integrarlos en el esquema silver.
Vamos a abrir el notebook `02_IntegrateAndCleanseCustomer.ipynb`<p>

![AIDP Arquitectura Medallon](img/Picture26.png)<p>

Verificamos que el cluster de spark este atachado al notebook para poder procesar.<br>
![AIDP Arquitectura Medallon](img/Picture27.png)<br>
![AIDP Arquitectura Medallon](img/Picture27-1.png)<br>
![AIDP Arquitectura Medallon](img/Picture27-2.png)<br>

En el siguiente paso vamos a importar las librerias necesarias<br>

![AIDP Arquitectura Medallon](img/Picture28.png)<p>

En la siguiente celda vamos a leer los datos customer de la capa bronze en el esquema `crm`<br>

![AIDP Arquitectura Medallon](img/Picture29.png)<p>

Despues de leer la tabla **"customer"** vamos a leer la tabla **"customer_reviews"** en la capa bronze del esquema `crm`

![AIDP Arquitectura Medallon](img/Picture30.png)<p>

En el siguiente paso vamos a hacer un join de ambos dataframes usando Spark<br>

![AIDP Arquitectura Medallon](img/Picture31.png)<p>

En el siguiente paso vamos a hacer sub-setting de ciertas columnas<br>

![AIDP Arquitectura Medallon](img/Picture32.png)<p>

En la siguiente celda vamos a limpiar los datos eliminando los registros con valores nulos<br>

![AIDP Arquitectura Medallon](img/Picture33.png)<p>

Luego vamos a hacer un llamado al modelo de `llm` para obtener un analisis de sentimientos **"NPL"** como score de los comentarios de los clientes. En este paso vamos a aprender como hacer llamados a los servicios de GenAI de un modelo indicando inclusive su prompt de la tarea.<br>

![AIDP Arquitectura Medallon](img/Picture34.png)<p>

En el paso anterior el score se retorna en un formato tipo string, vamos a convertirlo a entero y borrar la columna previa del score de sentimientos y dejarla lista para su uso en el entrenamiento del modelo de ML.<br>

![AIDP Arquitectura Medallon](img/Picture35.png)<p>

Vamos a crear el un nuevo esquema `crm` en la capa `silver` para escribir los datos limpios y procesados.<br>

![AIDP Arquitectura Medallon](img/Picture36.png)<p>

Luego de crear el esquema podemos verificar en el catalogo para ver la nueva tabla creada en el esquema silver de crm.<br>

![AIDP Arquitectura Medallon](img/Picture37.png)<p>

Ahora en este ultimo paso  escribimos los datos curados en el esquema `silver`.<br>

![AIDP Arquitectura Medallon](img/Picture38.png)<p>

Si vamos al catalogo `silver` y al esquema `crm` podremos visualizar la tabla procesada.<br>

![AIDP Arquitectura Medallon](img/Picture39.png)<p>

### 📋 Notebook 03
El objetivo de este notebook es crear un modelo para predecir el churn (salida voluntaria) de clientes y guardarlo en el espacio de trabajo para poder hacer predicciones.
Vamos a abrir el **03_TrainCustomerChurnModel.ipynb**.<br>

![AIDP Arquitectura Medallon](img/Picture40.png)<p>

Cuando el notebook se abre verifique que el cluster este atachado.<br>

![AIDP Arquitectura Medallon](img/Picture27.png)<br>
![AIDP Arquitectura Medallon](img/Picture27-1.png)<br>
![AIDP Arquitectura Medallon](img/Picture27-2.png)<br>

Iniciamos importando las librerias requeridas para ejecutar el notebook y entrenar el modelo.

![AIDP Arquitectura Medallon](img/Picture41.png)<p>

Vamos a leer la tabla historica `customer.profiles` de la capa silver y vamos a borrar el year y review para ejecutar el codigo.<br>

![AIDP Arquitectura Medallon](img/Picture42.png)<p>

Ahora vamos a crear una lista **"StringIndexer"** y **"OneHotEncoder"** para hacer las transformaciones de datos categoricos a valores numericos. Asi podemos unir datos categoricos y numericos en un solo dataframe.<br>

![AIDP Arquitectura Medallon](img/Picture43.png)<p>

Ahora vamos a definir un modelo de **"regresion logistica"** con los datos escalados y vamos a construir un **"pipeline"**, en el cual vamos hacer todas las tareas de procesar alistar y entrenar el modelo.<br>

![AIDP Arquitectura Medallon](img/Picture44.png)<p>

Ahora vamos a partir los datos en entrenamiento y prueba del dataset para entrenarlo.<br>

![AIDP Arquitectura Medallon](img/Picture45.png)<p>

Ahora vamos a usar el modelo entrenado para predecir la salida de clientes  con los datos de prueba.<br>

![AIDP Arquitectura Medallon](img/Picture46.png)<p>

Ahora evaluemos el modelo con la extraccion de las predicciones **positivas**  y la **probabilidad** de las predicciones del modelo. Al ser una clasificacion binaria  podemos usar las metricas BinaryClassificationMetrics y finalmente vamos a imprimir la **curva ROC (AUC)**<br>

![AIDP Arquitectura Medallon](img/Picture47.png)<p>

Como ultimo paso vamos a guardar el modelo en el espacio `/workspace/CUSTOMER_ANALYTICS/model/customer_churn/ml_model`.<br>

![AIDP Arquitectura Medallon](img/Picture48.png)<p>

AIDP va a crear una nueva area de trabajo donde guardara los modelos de acuerdo a la ruta indicada. Si te regresas al menu de `CUSTOMER_ANALYTICS` podras observar que existe un folder `model` en el cual fue almacenado el model de Machine Learning entrenado.<br>

![AIDP Arquitectura Medallon](img/Picture49.png)<p>

### 📝 Setup en Autonomous Datawarehouse como capa Gold

Los datos finales podriamos tener la versatilidad de guardarlos como una tabla externa en el **"Lake"** y accesarla o guardarlos en nuetra capa de **"warehouse ADW"**.<br>
Vamos a crear un `usuario` y una `tabla` donde almacenaremos en el ultimo notebook los resultados.

Vamos a ir a la opción de Oracle AI Database<br>

![AIDP Arquitectura Medallon](img/Picture50.png)<p>
![AIDP Arquitectura Medallon](img/Picture50-1.png)<p>

Vamos a abrir la base de datos (que se creo en los prerequisitos) y en la opción de Database Actions abriremos el SQL<br>

![AIDP Arquitectura Medallon](img/Picture51.png)<p>

En el SQL DEVELOPER WEB vamos a ejecutar el siguiente codigo que se encuentra en los archivos `usuario.sql` y `crear_tabla.sql`

Solo debes copiar y pegar el codigo y ejecutarlo. Tambien podrias arrastrar el archivo .sql a la interfaz para ejecutarlo.
- Primero vas a abrir el codigo de `usuario.sql` lo marcas completo y ejecutas el codigo completo.
- Luego vas a abrir el codigo de `crear_tabla.sql` lo marcas completo y ejecutos el codigo de creacion de tabla.<br>

![AIDP Arquitectura Medallon](img/runsql1.png)<p>
![AIDP Arquitectura Medallon](img/runsql2.png)<p>

#### Agregar el catálogo de ADW como uno nuevo en el Master Catalog

Vamos a crear un nuevo catalogo `Create Catalog`<br>

![AIDP Arquitectura Medallon](img/Picture52.png)<p>

- Vamos a indicar el `nombre del catalogo`, indicar una descripción y seleccionar `external catalog`.<br>
- Indicamos que la fuente es un `Oracle Autonomous Data Warehouse`<br>
- Anexamos el `wallet` de la base de datos el cual se descarga en el ADW en la opción 

![AIDP Arquitectura Medallon](img/Picture53.png)<br>

- Debes dar click en la opción `download wallet` y darle un password a la descarga del archivo. Puedes usar la misma clave del usuario que creamos para la base de datos.
`Clave=Oracle1234##`<br>

![AIDP Arquitectura Medallon](img/Picture54.png)<br>

Luego de agregar el wallet en la pantalla de External Catalog podras seleccionar `Service`y se recomienda usar `médium` en el nombre del servicio de los existentes en la lista de servicios.<br>

![AIDP Arquitectura Medallon](img/Picture55.png)<p>
![AIDP Arquitectura Medallon](img/Picture55B.png)<p>

En el boton **Test Conection** puedes probar la conexion a la base de datos y si funciona das **click** en el boton `Create`
Posterior a este paso vamos a poder visualizar el catalogo en el `Master Catalog` como se refleja en la siguiente imagen.<br>

![AIDP Arquitectura Medallon](img/Picture56.png)<p>

### 📋 Notebook 04

La tarea de este ultimo notebook es hacer predicciones con el modelo entrenado y guardarlas en una tabla dentro del datawarehouse ADW.
Vamos a abrir el ultimo notebook **04_PredictCustomerChurn.ipynb**<p>

![AIDP Arquitectura Medallon](img/Picture58.png)<p>

Volvemos a verificar que el cluster este atachado a el notebook.<br>

![AIDP Arquitectura Medallon](img/Picture27.png)<br>
![AIDP Arquitectura Medallon](img/Picture27-1.png)<br>
![AIDP Arquitectura Medallon](img/Picture27-2.png)<br>

Vamos a importar las librerias necesarias para ejecutar el notebook.<br>

![AIDP Arquitectura Medallon](img/Picture59.png)<p>

Ahora vamos a tomar los datos del esquema silver de la tabla customer y lo cargamos como un dataframe.<br>

![AIDP Arquitectura Medallon](img/Picture60.png)<p>

Vamos a borrar la columna `review`<br>

![AIDP Arquitectura Medallon](img/Picture61.png)<p>

Hacemos la carga del modelo entrenado para utilizarlo.<br>

![AIDP Arquitectura Medallon](img/Picture62.png)<p>

Ahora que el modelo ya esta cargado en memoria lo utilizamos para hacer las predicciones de `churn` (salida) como se muestra a continuacion.<br>

![AIDP Arquitectura Medallon](img/Picture63.png)<p>

Ejecutar la siguiente celda para ver los resultados de la **prediccion**.<br>

![AIDP Arquitectura Medallon](img/Picture64.png)<p>

Vamos a unicamente hacer un subset de las columnas que vamos a guardar en `ADW`.<br>

![AIDP Arquitectura Medallon](img/Picture65.png)<p>

Y con la ultima instruccion haremos un **"insert"** de los datos en la tabla del `ADW`.<br>

![AIDP Arquitectura Medallon](img/Picture66-2.png)<p>

