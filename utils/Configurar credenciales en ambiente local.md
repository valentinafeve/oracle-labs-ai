# Configurar credenciales de Oracle Cloud (API Key + archivo `config`)

Este documento explica cómo **crear y descargar un API Key** en Oracle Cloud, y cómo **configurar los archivos locales** en la carpeta `.oci` para que herramientas (CLI, SDKs y notebooks) puedan autenticarse correctamente.

> **Nota importante:** No basta con descargar la llave. En la pantalla de configuración, debes **copiar la configuración al archivo `config` y presionar el botón “Agregar”**. Si no presionas **Agregar**, la llave descargada puede quedar **no válida** o no asociada correctamente.

---

## Requisitos

- Acceso a tu **cuenta de Oracle Cloud**.
- Permisos para crear **API Keys** (Tokens and Keys).
- Acceso a tu computador para crear archivos dentro de la carpeta del usuario.

---

## 1) Ir al perfil del usuario (menú de cuenta)

1. En la consola de Oracle Cloud, ve a la **esquina superior derecha**.
2. Haz clic en el **icono de usuario** (perfil).
3. Selecciona el **correo / cuenta** con la que estás conectado.

![Screenshot: menú de usuario](images/Screenshot%202025-12-21%20at%201.04.26 PM.png)  
<!-- Reemplaza luego por tu screenshot. Deja el link roto si aún no lo pegas -->

---

## 2) Abrir “Tokens and Keys”

1. Dentro del panel de tu usuario, busca la sección **“Tokens and Keys”** (o equivalente según idioma de la consola).
2. Entra a esa sección para administrar llaves y tokens.

![Screenshot: Tokens and Keys](images/Screenshot%202025-12-21%20at%201.04.34 PM.png)

---

## 3) Crear un API Key y descargarlo

1. En **Tokens and Keys**, ubica la opción **API Keys**.
2. Haz clic en **Add API Key** / **Crear API Key**.

![Screenshot: crear y descargar API Key](images/Screenshot%202025-12-21%20at%201.04.37 PM.png)

3. Elige la opción para **generar una nueva llave**.
4. Haz clic en **Download API Key** / **Descargar API Key**.
   - Se descargará un archivo (normalmente con extensión `.pem`), por ejemplo:
     - `oci_api_key.pem`
![Screenshot: crear y descargar API Key](images/Screenshot%202025-12-21%20at%201.04.44 PM.png)


✅ **Resultado esperado:** tendrás un archivo `.pem` descargado en tu computador.

---

## 4) Copiar la configuración y presionar “Agregar” (CRÍTICO)

Después de crear el API Key, Oracle mostrará un bloque de texto con la **configuración sugerida** (por ejemplo, con campos como `user`, `fingerprint`, `tenancy`, `region`, `key_file`).

1. Copia el bloque de configuración que aparece en la consola.
2. **Pégalo** en el archivo local `config` (pasos exactos abajo).
3. En la consola, asegúrate de presionar el botón **“Agregar”**.
![Screenshot: crear y descargar API Key](images/Screenshot%202025-12-21%20at%201.11.47 PM.png)


> ⚠️ Si no presionas **Agregar**, puede suceder que:
> - La llave parezca creada, pero no quede correctamente asociada.
> - La autenticación falle en el notebook/SDK/CLI.

---

## 5) Crear la carpeta `.oci` y el archivo `config`

### Ubicación correcta (según sistema operativo)

#### macOS / Linux
La carpeta `.oci` debe vivir en tu **home**:

- Carpeta: `~/.oci/`
- Archivo: `~/.oci/config`

Ejemplo:
- `/Users/tu_usuario/.oci/config`
- `/home/tu_usuario/.oci/config`

#### Windows
La carpeta `.oci` debe vivir en tu carpeta de usuario:

- Carpeta: `C:\Users\TU_USUARIO\.oci\`
- Archivo: `C:\Users\TU_USUARIO\.oci\config`

---

## 6) Guardar el archivo `.pem` y referenciarlo desde `config`

1. Mueve el archivo descargado (por ejemplo `oci_api_key.pem`) a la carpeta `.oci`.

### Ejemplo (macOS / Linux)

- Llave: `~/.oci/oci_api_key.pem`
- Config: `~/.oci/config`

### Ejemplo (Windows)

- Llave: `C:\Users\TU_USUARIO\.oci\oci_api_key.pem`
- Config: `C:\Users\TU_USUARIO\.oci\config`

---

## 7) Pegar la configuración en `~/.oci/config`

1. Abre (o crea) el archivo `config`.
2. Pega el bloque que Oracle te mostró (el formato suele ser como este):

```ini
[DEFAULT]
user=ocid1.user.oc1..aaaaaaaa...
fingerprint=12:34:56:78:90:ab:cd:ef:...
tenancy=ocid1.tenancy.oc1..aaaaaaaa...
region=us-ashburn-1
key_file=/RUTA/A/.oci/oci_api_key.pem
