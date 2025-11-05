# Servidor MCP de Oracle SQLcl con Oracle AI Database

## Introducción

En este laboratorio aprenderás a configurar y utilizar el **servidor MCP SQLcl** con un agente de IA en **VS Code**.  
El servidor MCP SQLcl permite conectar tu base de datos **Oracle AI** a asistentes de IA como **Copilot, Cline, Claude Desktop** u otros que admitan el protocolo **MCP (Model Context Protocol)**.

El servidor MCP actúa como un puente entre la base de datos y las herramientas de IA, permitiendo usar **lenguaje natural** para interactuar con tus datos, ejecutar consultas SQL y comandos de base de datos.

> 💡 En lugar de escribir SQL manualmente, puedes describir lo que deseas y dejar que el asistente de IA maneje los detalles técnicos.

Este laboratorio utiliza **VS Code** con **Copilot**, pero los pasos también aplican a otros agentes compatibles con MCP.

**Tiempo estimado del laboratorio:** 20 minutos.

---

## 🎯 Objetivos

Al finalizar este laboratorio podrás:

- Descargar y configurar **SQLcl** (con soporte MCP)
- Instalar y configurar las extensiones **SQL Developer** y **Cline** para VS Code
- Conectarte a **Oracle AI Database** mediante una **cartera (wallet)**
- Configurar los valores MCP en VS Code
- Usar el **servidor MCP SQLcl** con un agente de IA para:
  - Mostrar conexiones
  - Ejecutar SQL
  - Crear una tabla para un juego de trivia

---

## 🧩 Requisitos previos

Debes tener instalado y disponible:

- **Oracle Java 17 o 21**
- Acceso a una base de datos **Oracle AI** (FreeSQL, LiveSQL o autónoma con cartera)
- **Credenciales Oracle**
- **VS Code** instalado
- **Conexión a Internet**

---

## 🧾 Tarea 1: Descargar la cartera (wallet)

Una **cartera** es un archivo seguro que contiene credenciales y certificados para acceder a Oracle Autonomous Database.  
Asegura que la conexión esté **cifrada y autenticada**.

### 🔹 Pasos:

1. En la página inicial de tu base de datos autónoma, haz clic en **Database Connection** y selecciona **Download Wallet**.  
2. Asigna una contraseña. Ejemplo:  
   ```
   OracleAIworld2025
   ```
3. Descarga el archivo `.zip` (cartera).  
   Verifica que se haya guardado correctamente en tu carpeta de **Descargas**.

---

## 🧩 Tarea 2: Instalar la extensión SQL Developer en VS Code

### 🔹 Qué hace

Permite trabajar con bases de datos **Oracle AI** y gestionar conexiones directamente desde VS Code.

### 🔹 Pasos

1. Abre VS Code y dirígete a **Extensiones (Ctrl+Shift+X)**.  
2. Busca **Oracle SQL Developer** e instálalo desde Marketplace.  
3. Abre la extensión y haz clic en **Create Connection**.  
4. Completa los campos:

   ```
   Connection name: AIWorld-HOL
   User: ADMIN
   Password: [tu contraseña]
   Connection type: Cloud Wallet
   ```

5. Selecciona el archivo de cartera descargado y **prueba la conexión**.  
6. Guarda la conexión.

> ✅ Si la conexión falla, revisa las credenciales y la ruta del archivo de cartera.

---

## 🤖 Tarea 3: Instalar la extensión Cline

**Cline** es un agente de codificación de IA de código abierto.

1. En VS Code, busca **Cline** en las extensiones e instálalo.  
2. Abre **Cline** desde la barra de actividades.  
3. Configura el proveedor de IA:
   - Servicio gratuito de Cline → *Click en “Introducción gratuita”*
   - O usa tu **propia clave API** (OpenAI, Anthropic, etc.)
4. Configura el modelo de IA desde el ícono ⚙️ → *Configuración de API*.

---

## 🧠 Tarea 4: Instalar SQLcl

**SQLcl** es la interfaz moderna de línea de comandos para bases de datos Oracle, con soporte para **MCP**.

> ⚠️ Necesitas la versión **25.2 o posterior**.

### Opción 1: Descarga directa (recomendada)

- Descarga SQLcl desde el sitio oficial de Oracle.
- Descomprime la carpeta (por ejemplo, en **Descargas**).

### Opción 2: Homebrew (usuarios de Mac)

```bash
brew install --cask sqlcl
```

Verifica que la instalación esté disponible en tu sistema (`sql -v`) y anota la ruta de instalación.

---

## 🔧 Tarea 5: Configurar Cline con el servidor MCP SQLcl

Este paso conecta **Cline** con **SQLcl** para ejecutar comandos SQL de forma segura mediante MCP.

1. En VS Code, abre la extensión Cline.  
2. Haz clic en el ícono **MCP Servers** → **Configurar servidores MCP**.  
3. En el archivo JSON, reemplaza la ruta de SQLcl con la tuya:

```json
{
  "mcpServers": {
    "sqlcl": {
      "command": "/Users/yourname/Downloads/sqlcl/bin/sql",
      "args": ["-mcp"]
    }
  }
}
```

Ejemplo para instalación con Homebrew:
```json
{
  "command": "/opt/homebrew/bin/sql",
  "args": ["-mcp"]
}
```

> ⚠️ Si aparece un mensaje solicitando Java, instálalo antes de continuar.

4. Guarda el archivo.  
   SQLcl debería aparecer en la lista **Installed MCP Servers**.

5. Verifica que SQLcl funcione correctamente desde la terminal:
   ```bash
   sql -v
   ```

---

## 🧪 Tarea 6: Usar el servidor MCP

Una vez configurado, podrás interactuar con la base de datos mediante lenguaje natural.

### Modo de Cline
- **Plan Mode** → muestra un plan antes de ejecutarlo (recomendado)
- **Act Mode** → ejecuta directamente (con precaución)

> ⚠️ **Desactiva “Aprobación automática”** para evitar ejecuciones no revisadas.

---

### 🔹 Ejemplo 1: Mostrar conexiones

En el área de entrada de Cline, escribe:

```
Usando el servidor mcp sqlcl, muestre mis conexiones a la base de datos.
```

Cline solicitará permiso para ejecutar `list-connections`.  
Aprueba la solicitud y verás tus conexiones disponibles (por ejemplo, **AIWorld-HOL**).

---

### 🔹 Ejemplo 2: Crear una tabla de trivia

Crea un archivo `trivia-data.sql` con el siguiente contenido:

```sql
DROP TABLE IF EXISTS trivia_questions CASCADE CONSTRAINTS;

CREATE TABLE trivia_questions (
   id NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
   question_text VARCHAR2(500) NOT NULL,
   answer_text VARCHAR2(200) NOT NULL,
   categoria VARCHAR2(50) DEFAULT 'Oracle History',
   dificultad VARCHAR2(20) DEFAULT 'Medium'
);

INSERT INTO trivia_questions (question_text, answer_text, dificultad) VALUES
('¿En qué año se fundó Oracle?', '1977', 'Medium'),
('¿Qué versión principal de Oracle Database introdujo PL/SQL?', 'Oracle 6', 'Medium'),
('¿Qué versión introdujo Real Application Clusters (RAC)?', 'Oracle 9i', 'Medium'),
('Oracle 10g hizo hincapié en qué modelo de computación?', 'Grid computing', 'Easy'),
('Oracle 12c introdujo qué arquitectura?', 'Multitenant (CDB/PDB)', 'Easy'),
('¿Qué empresa adquirió Oracle en 2010?', 'Sun Microsystems', 'Easy'),
('¿En qué década debutó Exadata?', '2000s (2008)', 'Medium'),
('¿Cuándo se anunció la base de datos autónoma?', '2017', 'Medium');
COMMIT;
```

Luego, pide a Cline ejecutar el script:

```
Usa run-sqlcl para cargar @/trivia-data.sql en la conexión AIWorld-HOL
```

Aprobar el plan para ejecutar la carga de datos.

---

### 🔹 Ejemplo 3: Crear aplicación web simple

Pide a Cline:

```
Créame una aplicación web de trivia simple con los datos de la tabla trivia_questions.
```

Cline generará un plan para construir un sitio estático con las preguntas de trivia.

---

### 🔹 Ejemplo 4: Consulta directa con IA

```
Respóndeme la siguiente pregunta:
Which release introduced Real Application Clusters (RAC)?
```

El asistente debe responder:  
> “Oracle 9i”

---

### 🔹 Cierre seguro

Cuando termines, desconéctate:

```
Desconéctese de la conexión a la base de datos.
```

> El servidor MCP SQLcl registra todas las operaciones en la tabla:
> ```
> DBTOOLS$MCP_LOG
> ```
> Puedes consultarla para revisar el historial de ejecución.

---

### 🛡️ Nota final

> **Confidential – Oracle Internal**

Este laboratorio es propiedad de Oracle y se utiliza exclusivamente con fines educativos y de demostración.

---

**Autor:** Oracle AI Team  
**Fecha:** 2025  
**Versión:** 1.0
