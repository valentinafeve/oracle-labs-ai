# Lab 02 Uso de Servicio DataScience y Modelos de IA Generativa
## Tarea 1 Despliegue Servicio
Dentro del menú principal de OCI vamos a la opción Analytics & AI y buscamos la opción en **"Machine Learning"** y damos click en la opción de Data Science.<br>

![Menú Principal](images/imagen1.png)<p>
Seleccionas el compartment (creado previamente) donde dejaremos el proyecto y luego que ingresas a la opción de Data Science debes darle click en `Create Project`<br>

![Data Science](images/imagen2.png)<p>
Indicar el compartment y nombre del proyecto `AIWORKSHOP`

![Data Science](images/imagen3.png)<p>

Dentro del proyecto vamos a crear un notebook de Data Science.
Dar click en el botón `Create notebook session`<br>
Debes hacer los siguientes pasos:
- Indicar un nombre para el **notebook**
- Cambiar la configuración del `Shape de Cómputo (agregar 2 OCPUs y 32 RAM)`
- En el campo Block Storage indicar `100 GB`
- Mantener las otras opciones tal cual vienen y dar click en el botón `Create`<br>

![Data Science](images/imagen4.png)<p>

Luego que la maquina esta provisionada darle `click` en el hiperviculo para trabajar con DataScience.

![Data Science](images/imagen5.png)<p>

Y dentro de esta opción vamos a ver un boton en la parte superior de `OPEN` que abre el notebook de Jupyter, donde te pedira que te autentiques para poder acceder a los servicios.<br>

![Data Science](images/imagen6.png)<p>

Cuando se abre una nueva pestaña en su navegador el servicio se muestra como un notebook de jupyter de la siguiente manera.<br>

![Data Science](images/imagen7.png)<p>

## Copia Archivos
- De los archivos que se encuentran en este lab en el git, con extension *.ipynb y con prefijo ## debes descargarlos a tu computador.
    - 01_notebook
    - 02_notebook
    - 03_notebook
    - imagen(unico archivo)
- Luego de tenerlo en tu PC vas a cargarlos al servicio de Datascience tomando los archivos y los arrastras a la zona indicada en la siguiente imagen.<p>

![Data Science](images/imagen8.png)<p>

---
## Copia del archivo .pem
La llave privada generada en el setup inical que se guardo el archivo .pem.<br>Tambien de cargarse de la mimsa manera que con los notebooks.
El archivo debe tener el siguiente nombre dentro de DataScience para poder usarlo  `oci_api_key.pem`. Puedes renombrarlo antes de subir dicho archivo al servicio.<br>
