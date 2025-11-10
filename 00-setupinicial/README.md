# 📘 README – Configuración de Entorno para Servicios de AI en Oracle Cloud

## 🧩 Introducción

Este documento describe el proceso completo para **crear un API Key**, **configurar compartimentos**, y **definir políticas** necesarias para habilitar el acceso a los servicios de *Data Science* y *AI Services* en Oracle Cloud Infrastructure (OCI).

La guía está diseñada para usuarios que deseen autenticar servicios de AI, crear un entorno de trabajo seguro y gestionar sus recursos desde la consola OCI.

---

## 🔐 1. Creación de un API Key para la Autenticación

El **API Key** permite autenticar de forma segura las conexiones con los servicios de AI dentro del entorno de Data Science.

### Pasos

1. Abra el ícono del menú en la parte superior izquierda de la consola y seleccione su **perfil de usuario**.
   
   ![Menú Perfil de Usuario](images/api_key_profile.png)

2. Ingrese en la pestaña **Tokens and Keys**.
   
   ![Tokens and Keys](images/api_key_tokens.png)

3. En la sección **API Keys**, haga clic en **Adicionar**.

4. Seleccione **Generar API Key** y descargue los dos archivos que aparecen en la parte inferior de la ventana.
   
   ![Generar API Key](images/api_key_generate.png)

5. Finalmente, haga clic en **ADD** para completar el proceso.

6. Visualice la configuración del archivo generado y **copie la información necesaria**, ya que se utilizará posteriormente en la configuración de acceso.

   ![Generar API Key](images/5preview.png)

---

## 🗂️ 2. Creación de un Compartimiento para el Trabajo

El **compartimiento** (Compartment) permite organizar y aislar los recursos de su entorno de Data Science.

### Pasos

1. En el menú de navegación, seleccione **Identidad y seguridad → Compartimentos**.
   
   ![Menú Compartimentos](images/compartments_menu.png)

2. Haga clic en **Crear compartimento**.
   
   ![Crear Compartimento](images/compartments_create.png)

3. Asigne un nombre al nuevo compartimento, por ejemplo:  
   ```
   AIWORKSHOP
   ```
   y añada una descripción.

4. Presione **Crear compartimento**.

5. Confirme que el nuevo compartimento aparece en la lista.
   
   ![Compartimento creado](images/compartments_list.png)

---

## ⚙️ 3. Creación de Políticas (Policies)

Antes de iniciar sesiones en los blocs de notas de Data Science, es necesario definir políticas de acceso que permitan a los servicios interactuar correctamente.

### Pasos

1. En el menú de navegación, diríjase a **Identidad y seguridad → Políticas**.
   
   ![Menú Políticas](images/policies_menu.png)

2. Haga clic en **Crear política**.

   ![Menú Políticas](images/2crearpolicies.png)

3. Complete los siguientes campos:
   - **Nombre:** `policy`
   - **Descripción:** Política para los usuarios y el servicio de ciencia.
   - **Compartimento:** `root`

4. Seleccione **Mostrar editor manual** e introduzca las siguientes sentencias de política:

   ```text
   Allow group Administrators to manage all-resources in tenancy
   Allow service datascience to use data-science-family in tenancy
   ```

5. Haga clic en **Crear** para guardar la política.
   
   ![Crear Política](images/policies_create.png)

---

## 🧾 Notas Finales

- Guarde sus claves privadas de forma segura.  
- No comparta su archivo `oci_api_key.pem` con terceros.  
- Revise que las políticas estén correctamente aplicadas antes de ejecutar notebooks o scripts en Data Science.

---
