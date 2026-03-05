# Laboratorio: Construcción de un agente a partir de datos de partidos

Los datos son uno de los activos más valiosos de cualquier organización, pero acceder a ellos de forma ágil e intuitiva sigue siendo un reto para muchos equipos. 🤔 En este laboratorio vas a construir un agente de análisis de datos sobre estadísticas de jugadores de la Premier League** ⚽ — un agente que entiende preguntas en lenguaje natural, las traduce automáticamente a consultas SQL y te devuelve respuestas, tablas y visualizaciones al instante, sin que tengas que escribir una sola línea de código. 🚀

---


## Paso 1: Carga de los datos en la base de datos

> Carga de datos Premier League de forma automática. 
> Ingresa a la base de datos y ejecuta el siguiente script.

<details>
<summary>📸 Creación y Cargas de datos PREMIER LEAGUE de forma automática </summary>

```sql
-- Script para Autonomous Database ejecutado con usuario ADMIN
-- Ejecutar con F5

SET DEFINE OFF;

PROMPT === Eliminando tablas si existen ===

BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE EVENT PURGE';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE != -942 THEN
      RAISE;
    END IF;
END;
/

BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE MATCH PURGE';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE != -942 THEN
      RAISE;
    END IF;
END;
/

BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE PREDICT_BY_ANGLE PURGE';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE != -942 THEN
      RAISE;
    END IF;
END;
/

BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE XG_MATRIX PURGE';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE != -942 THEN
      RAISE;
    END IF;
END;
/

BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE PLAYER_STATS PURGE';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE != -942 THEN
      RAISE;
    END IF;
END;
/

PROMPT === Creando tablas ===

CREATE TABLE EVENT
(
  ID                            NUMBER(38,0),
  MATCH_ID                      VARCHAR2(26 BYTE),
  EVENT_ID                      NUMBER(38,0),
  TYPE_ID                       NUMBER(38,0),
  PERIOD_ID                     NUMBER(38,0),
  TIME_MIN                      NUMBER(38,0),
  TIME_SEC                      NUMBER(38,0),
  MATCH_DATE                    DATE,
  TEAM_ID                       VARCHAR2(26 BYTE),
  X                             NUMBER(38,1),
  Y                             NUMBER(38,1),
  PLAYER_ID                     VARCHAR2(26 BYTE),
  PLAYER_NAME                   VARCHAR2(26 BYTE),
  PENALTY                       VARCHAR2(26 BYTE),
  HEAD                          VARCHAR2(26 BYTE),
  RIGHT_FOOTED                  VARCHAR2(26 BYTE),
  OTHER_BODY_PART               VARCHAR2(26 BYTE),
  REGULAR_PLAY                  VARCHAR2(26 BYTE),
  FAST_BREAK                    VARCHAR2(26 BYTE),
  SET_PIECE                     VARCHAR2(26 BYTE),
  FROM_CORNER                   VARCHAR2(26 BYTE),
  FREE_KICK                     VARCHAR2(26 BYTE),
  OWN_GOAL                      VARCHAR2(26 BYTE),
  ASSISTED                      VARCHAR2(26 BYTE),
  LEFT_FOOTED                   VARCHAR2(26 BYTE),
  TARGETED_LOW_LEFT             VARCHAR2(26 BYTE),
  TARGETED_HIGH_LEFT            VARCHAR2(26 BYTE),
  TARGETED_LOW_CENTER           VARCHAR2(26 BYTE),
  TARGETED_HIGH_CENTER          VARCHAR2(26 BYTE),
  TARGETED_LOW_RIGHT            VARCHAR2(26 BYTE),
  TARGETED_HIGH_RIGHT           VARCHAR2(26 BYTE),
  BLOCKED                       VARCHAR2(26 BYTE),
  TARGETED_CLOSE_LEFT           VARCHAR2(26 BYTE),
  TARGETED_CLOSE_RIGHT          VARCHAR2(26 BYTE),
  TARGETED_CLOSE_HIGH           VARCHAR2(26 BYTE),
  TARGETED_CLOSE_LEFT_AND_HIGH  VARCHAR2(26 BYTE),
  TARGETED_CLOSE_RIGHT_AND_HIGH VARCHAR2(26 BYTE),
  PROJECTED_GOAL_MOUTH_Y        VARCHAR2(26 BYTE),
  PROJECTED_GOAL_MOUTH_Z        VARCHAR2(26 BYTE),
  DEFLECTION                    VARCHAR2(26 BYTE),
  HIT_WOODWORK                  VARCHAR2(26 BYTE),
  BIG_CHANCE                    VARCHAR2(26 BYTE),
  INDIVIDUAL_CHANCE             VARCHAR2(26 BYTE),
  HIT_RIGHT_POST                VARCHAR2(26 BYTE),
  HIT_LEFT_POST                 VARCHAR2(26 BYTE),
  HIT_BAR                       VARCHAR2(26 BYTE),
  OUT_ON_SIDELINE               VARCHAR2(26 BYTE),
  KICKOFF                       VARCHAR2(26 BYTE),
  FIRST_TOUCH                   VARCHAR2(26 BYTE),
  NOT_ASSISTED                  VARCHAR2(26 BYTE),
  EVENT_TYPE_NAME               VARCHAR2(10 BYTE),
  TEAM_NAME                     VARCHAR2(50 BYTE),
  IS_GOAL                       VARCHAR2(1 BYTE),
  GOAL_CNT                      NUMBER(1,0),
  RESULT                        VARCHAR2(20 BYTE),
  TEAM_SIDE                     VARCHAR2(4 BYTE),
  X_REL_PC                      NUMBER,
  Y_REL_PC                      NUMBER,
  X_REL_M                       NUMBER,
  Y_REL_M                       NUMBER,
  X_REL_M_TEAM                  NUMBER,
  Y_REL_M_TEAM                  NUMBER,
  DISTANCE                      NUMBER,
  DISTANCE_BUCKET               NUMBER,
  EVENT_COUNT                   NUMBER,
  FOOTBALL_PITCH_CELL           VARCHAR2(10 BYTE)
);

CREATE TABLE MATCH
(
  MATCH_ID       VARCHAR2(26 BYTE),
  MATCH_DATE     DATE,
  MATCH_TIME     VARCHAR2(26 BYTE),
  TEAM_HOME_ID   VARCHAR2(26 BYTE),
  TEAM_HOME_NAME VARCHAR2(26 BYTE),
  TEAM_AWAY_ID   VARCHAR2(26 BYTE),
  TEAM_AWAY_NAME VARCHAR2(26 BYTE),
  VENUE          VARCHAR2(128 BYTE),
  STATUS         VARCHAR2(26 BYTE),
  WINNER         VARCHAR2(26 BYTE),
  SCORE_HOME     NUMBER(38,0),
  SCORE_AWAY     NUMBER(38,0),
  NAME           VARCHAR2(100 BYTE),
  NAME_DATE      VARCHAR2(100 BYTE)
);

CREATE TABLE PREDICT_BY_ANGLE
(
  ID             NUMBER,
  ANGLE          NUMBER,
  PREDICTED_GOAL VARCHAR2(1 BYTE),
  XG             NUMBER
);

CREATE TABLE XG_MATRIX
(
  ID                 NUMBER,
  X                  NUMBER,
  Y                  NUMBER,
  ANGLE              NUMBER,
  HEAD               VARCHAR2(1 BYTE),
  FAST_BREAK         VARCHAR2(1 BYTE),
  PREDICTED_GOAL     VARCHAR2(1 BYTE),
  XG                 NUMBER,
  FOOTBALL_PITCH_CELL VARCHAR2(10 BYTE)
);

CREATE TABLE PLAYER_STATS
(
  PLAYER_ID   VARCHAR2(26 BYTE),
  PLAYER_NAME VARCHAR2(26 BYTE),
  TEAM_NAME   VARCHAR2(50 BYTE),
  TOTAL_XG    NUMBER,
  GOALS       NUMBER,
  SHOT_COUNT  NUMBER,
  XG_PER_SHOT NUMBER
);

-- Tabla de staging para EVENT (el CSV trae MATCH_DATE al final)
CREATE TABLE EVENT_RAW
(
  ID                            VARCHAR2(100 BYTE),
  MATCH_ID                      VARCHAR2(26 BYTE),
  EVENT_ID                      VARCHAR2(100 BYTE),
  TYPE_ID                       VARCHAR2(100 BYTE),
  PERIOD_ID                     VARCHAR2(100 BYTE),
  TIME_MIN                      VARCHAR2(100 BYTE),
  TIME_SEC                      VARCHAR2(100 BYTE),
  TEAM_ID                       VARCHAR2(26 BYTE),
  X                             VARCHAR2(100 BYTE),
  Y                             VARCHAR2(100 BYTE),
  PLAYER_ID                     VARCHAR2(26 BYTE),
  PLAYER_NAME                   VARCHAR2(26 BYTE),
  PENALTY                       VARCHAR2(26 BYTE),
  HEAD                          VARCHAR2(26 BYTE),
  RIGHT_FOOTED                  VARCHAR2(26 BYTE),
  OTHER_BODY_PART               VARCHAR2(26 BYTE),
  REGULAR_PLAY                  VARCHAR2(26 BYTE),
  FAST_BREAK                    VARCHAR2(26 BYTE),
  SET_PIECE                     VARCHAR2(26 BYTE),
  FROM_CORNER                   VARCHAR2(26 BYTE),
  FREE_KICK                     VARCHAR2(26 BYTE),
  OWN_GOAL                      VARCHAR2(26 BYTE),
  ASSISTED                      VARCHAR2(26 BYTE),
  LEFT_FOOTED                   VARCHAR2(26 BYTE),
  TARGETED_LOW_LEFT             VARCHAR2(26 BYTE),
  TARGETED_HIGH_LEFT            VARCHAR2(26 BYTE),
  TARGETED_LOW_CENTER           VARCHAR2(26 BYTE),
  TARGETED_HIGH_CENTER          VARCHAR2(26 BYTE),
  TARGETED_LOW_RIGHT            VARCHAR2(26 BYTE),
  TARGETED_HIGH_RIGHT           VARCHAR2(26 BYTE),
  BLOCKED                       VARCHAR2(26 BYTE),
  TARGETED_CLOSE_LEFT           VARCHAR2(26 BYTE),
  TARGETED_CLOSE_RIGHT          VARCHAR2(26 BYTE),
  TARGETED_CLOSE_HIGH           VARCHAR2(26 BYTE),
  TARGETED_CLOSE_LEFT_AND_HIGH  VARCHAR2(26 BYTE),
  TARGETED_CLOSE_RIGHT_AND_HIGH VARCHAR2(26 BYTE),
  PROJECTED_GOAL_MOUTH_Y        VARCHAR2(26 BYTE),
  PROJECTED_GOAL_MOUTH_Z        VARCHAR2(26 BYTE),
  DEFLECTION                    VARCHAR2(26 BYTE),
  HIT_WOODWORK                  VARCHAR2(26 BYTE),
  BIG_CHANCE                    VARCHAR2(26 BYTE),
  INDIVIDUAL_CHANCE             VARCHAR2(26 BYTE),
  HIT_RIGHT_POST                VARCHAR2(26 BYTE),
  HIT_LEFT_POST                 VARCHAR2(26 BYTE),
  HIT_BAR                       VARCHAR2(26 BYTE),
  OUT_ON_SIDELINE               VARCHAR2(26 BYTE),
  KICKOFF                       VARCHAR2(26 BYTE),
  FIRST_TOUCH                   VARCHAR2(26 BYTE),
  NOT_ASSISTED                  VARCHAR2(26 BYTE),
  EVENT_TYPE_NAME               VARCHAR2(10 BYTE),
  TEAM_NAME                     VARCHAR2(50 BYTE),
  IS_GOAL                       VARCHAR2(1 BYTE),
  GOAL_CNT                      VARCHAR2(100 BYTE),
  RESULT                        VARCHAR2(20 BYTE),
  TEAM_SIDE                     VARCHAR2(4 BYTE),
  X_REL_PC                      VARCHAR2(100 BYTE),
  Y_REL_PC                      VARCHAR2(100 BYTE),
  X_REL_M                       VARCHAR2(100 BYTE),
  Y_REL_M                       VARCHAR2(100 BYTE),
  X_REL_M_TEAM                  VARCHAR2(100 BYTE),
  Y_REL_M_TEAM                  VARCHAR2(100 BYTE),
  DISTANCE                      VARCHAR2(100 BYTE),
  DISTANCE_BUCKET               VARCHAR2(100 BYTE),
  EVENT_COUNT                   VARCHAR2(100 BYTE),
  FOOTBALL_PITCH_CELL           VARCHAR2(10 BYTE),
  MATCH_DATE_TXT                VARCHAR2(30 BYTE)
);

PROMPT === Cargando datos con DBMS_CLOUD.COPY_DATA ===

BEGIN
  DBMS_CLOUD.COPY_DATA(
    credential_name => NULL,
    table_name      => 'EVENT_RAW',
    file_uri_list   => 'https://objectstorage.us-chicago-1.oraclecloud.com/p/JdLwvG46w3Kjs8e0gieB6mKUZdZhGOo6KcNTZGTThF-0JAzRc7eOqGl4510aPgOO/n/idajmumkp9ca/b/labs-git/o/event.csv',
    format          => '{"type":"csv","skipheaders":1,"delimiter":",","quote":"\"","characterset":"WE8MSWIN1252","blankasnull":true}'
  );

  INSERT INTO EVENT (
    ID, MATCH_ID, EVENT_ID, TYPE_ID, PERIOD_ID, TIME_MIN, TIME_SEC, MATCH_DATE,
    TEAM_ID, X, Y, PLAYER_ID, PLAYER_NAME, PENALTY, HEAD, RIGHT_FOOTED, OTHER_BODY_PART,
    REGULAR_PLAY, FAST_BREAK, SET_PIECE, FROM_CORNER, FREE_KICK, OWN_GOAL, ASSISTED,
    LEFT_FOOTED, TARGETED_LOW_LEFT, TARGETED_HIGH_LEFT, TARGETED_LOW_CENTER, TARGETED_HIGH_CENTER,
    TARGETED_LOW_RIGHT, TARGETED_HIGH_RIGHT, BLOCKED, TARGETED_CLOSE_LEFT, TARGETED_CLOSE_RIGHT,
    TARGETED_CLOSE_HIGH, TARGETED_CLOSE_LEFT_AND_HIGH, TARGETED_CLOSE_RIGHT_AND_HIGH,
    PROJECTED_GOAL_MOUTH_Y, PROJECTED_GOAL_MOUTH_Z, DEFLECTION, HIT_WOODWORK, BIG_CHANCE,
    INDIVIDUAL_CHANCE, HIT_RIGHT_POST, HIT_LEFT_POST, HIT_BAR, OUT_ON_SIDELINE, KICKOFF,
    FIRST_TOUCH, NOT_ASSISTED, EVENT_TYPE_NAME, TEAM_NAME, IS_GOAL, GOAL_CNT, RESULT, TEAM_SIDE,
    X_REL_PC, Y_REL_PC, X_REL_M, Y_REL_M, X_REL_M_TEAM, Y_REL_M_TEAM, DISTANCE,
    DISTANCE_BUCKET, EVENT_COUNT, FOOTBALL_PITCH_CELL
  )
  SELECT
    TO_NUMBER(ID DEFAULT NULL ON CONVERSION ERROR),
    MATCH_ID,
    TO_NUMBER(EVENT_ID DEFAULT NULL ON CONVERSION ERROR),
    TO_NUMBER(TYPE_ID DEFAULT NULL ON CONVERSION ERROR),
    TO_NUMBER(PERIOD_ID DEFAULT NULL ON CONVERSION ERROR),
    TO_NUMBER(TIME_MIN DEFAULT NULL ON CONVERSION ERROR),
    TO_NUMBER(TIME_SEC DEFAULT NULL ON CONVERSION ERROR),
    TO_DATE(TRIM(MATCH_DATE_TXT) DEFAULT NULL ON CONVERSION ERROR, 'DD-MON-RR'),
    TEAM_ID,
    TO_NUMBER(X DEFAULT NULL ON CONVERSION ERROR),
    TO_NUMBER(Y DEFAULT NULL ON CONVERSION ERROR),
    PLAYER_ID, PLAYER_NAME, PENALTY, HEAD, RIGHT_FOOTED, OTHER_BODY_PART,
    REGULAR_PLAY, FAST_BREAK, SET_PIECE, FROM_CORNER, FREE_KICK, OWN_GOAL, ASSISTED,
    LEFT_FOOTED, TARGETED_LOW_LEFT, TARGETED_HIGH_LEFT, TARGETED_LOW_CENTER, TARGETED_HIGH_CENTER,
    TARGETED_LOW_RIGHT, TARGETED_HIGH_RIGHT, BLOCKED, TARGETED_CLOSE_LEFT, TARGETED_CLOSE_RIGHT,
    TARGETED_CLOSE_HIGH, TARGETED_CLOSE_LEFT_AND_HIGH, TARGETED_CLOSE_RIGHT_AND_HIGH,
    PROJECTED_GOAL_MOUTH_Y, PROJECTED_GOAL_MOUTH_Z, DEFLECTION, HIT_WOODWORK, BIG_CHANCE,
    INDIVIDUAL_CHANCE, HIT_RIGHT_POST, HIT_LEFT_POST, HIT_BAR, OUT_ON_SIDELINE, KICKOFF,
    FIRST_TOUCH, NOT_ASSISTED, EVENT_TYPE_NAME, TEAM_NAME, IS_GOAL,
    TO_NUMBER(GOAL_CNT DEFAULT NULL ON CONVERSION ERROR),
    RESULT, TEAM_SIDE,
    TO_NUMBER(X_REL_PC DEFAULT NULL ON CONVERSION ERROR),
    TO_NUMBER(Y_REL_PC DEFAULT NULL ON CONVERSION ERROR),
    TO_NUMBER(X_REL_M DEFAULT NULL ON CONVERSION ERROR),
    TO_NUMBER(Y_REL_M DEFAULT NULL ON CONVERSION ERROR),
    TO_NUMBER(X_REL_M_TEAM DEFAULT NULL ON CONVERSION ERROR),
    TO_NUMBER(Y_REL_M_TEAM DEFAULT NULL ON CONVERSION ERROR),
    TO_NUMBER(DISTANCE DEFAULT NULL ON CONVERSION ERROR),
    TO_NUMBER(DISTANCE_BUCKET DEFAULT NULL ON CONVERSION ERROR),
    TO_NUMBER(EVENT_COUNT DEFAULT NULL ON CONVERSION ERROR),
    FOOTBALL_PITCH_CELL
  FROM EVENT_RAW;

  DBMS_CLOUD.COPY_DATA(
    credential_name => NULL,
    table_name      => 'MATCH',
    file_uri_list   => 'https://objectstorage.us-chicago-1.oraclecloud.com/p/bwcwEtC52h5gfON0nYqVOhDqPrH3hZT8Ck58bPmCKECLKHRrM5xY4265r1EOaz20/n/idajmumkp9ca/b/labs-git/o/match.csv',
    format          => '{"type":"csv","skipheaders":1,"delimiter":",","quote":"\"","characterset":"WE8MSWIN1252","dateformat":"DD-MON-RR","blankasnull":true}'
  );

  DBMS_CLOUD.COPY_DATA(
    credential_name => NULL,
    table_name      => 'PLAYER_STATS',
    file_uri_list   => 'https://objectstorage.us-chicago-1.oraclecloud.com/p/GSZXJEJkuXJjqhlHXxnm04kWX4OlnISgWVqtrVxxKLVm8pD36XO2oUj6h7unKLtw/n/idajmumkp9ca/b/labs-git/o/player_stats.csv',
    format          => '{"type":"csv","skipheaders":1,"delimiter":",","quote":"\"","characterset":"WE8MSWIN1252","blankasnull":true}'
  );

  DBMS_CLOUD.COPY_DATA(
    credential_name => NULL,
    table_name      => 'PREDICT_BY_ANGLE',
    file_uri_list   => 'https://objectstorage.us-chicago-1.oraclecloud.com/p/HIHoQBesfjAFk2Ekrq279NoBnrMozXvkTFxjtLXyVJlNx1zXapjX93X4t0y-REL-/n/idajmumkp9ca/b/labs-git/o/predict_by_angle.csv',
    format          => '{"type":"csv","skipheaders":1,"delimiter":",","quote":"\"","characterset":"WE8MSWIN1252","blankasnull":true}'
  );

  DBMS_CLOUD.COPY_DATA(
    credential_name => NULL,
    table_name      => 'XG_MATRIX',
    file_uri_list   => 'https://objectstorage.us-chicago-1.oraclecloud.com/p/nBNu_bNLWfWpha7W92NQnqo7AIcMuatbtiIbGfJe9i5sytXEXC9mq4xbpDFaHO2Q/n/idajmumkp9ca/b/labs-git/o/xg_matrix.csv',
    format          => '{"type":"csv","skipheaders":1,"delimiter":",","quote":"\"","characterset":"WE8MSWIN1252","blankasnull":true}'
  );
END;
/

PROMPT === Validar errores de carga (si existen) ===
SELECT * FROM USER_LOAD_OPERATIONS ORDER BY ID DESC FETCH FIRST 10 ROWS ONLY;

DROP TABLE EVENT_RAW PURGE;

COMMIT;

PROMPT === Carga finalizada ===

```


</details>



## Paso 2: Creación de un agente para análisis de datos

Ingresa a la plataforma **Database Private Agent Factory (DPAF)**, que ya fue desplegada previamente. En el panel de navegación izquierdo, selecciona la opción **Data Source**.

Crea un nuevo Data Source de tipo **Database** completando el formulario con los siguientes campos:

- **Nombre:** un nombre descriptivo para identificar la conexión
- **Descripción:** una breve descripción del propósito de esta fuente de datos
- **Tipo de conexión:** carga la Wallet que descargaste al crear la base de datos
- **Usuario:** `ADMIN`
- **Contraseña:** la contraseña que definiste al crear la base de datos

![Formulario de configuración del Data Source](./AI%20Private%20Agent%20Factory/dpaf_image12.png)

Una vez completado el formulario, haz clic en **Test Connection** para validar que la conexión sea exitosa. Si la prueba es exitosa, presiona el botón **Add Database Source** para guardar la fuente de datos.

### Verificación del Data Source creado

Si la configuración fue correcta, el nuevo Data Source aparecerá listado en el panel de **Data Source** del menú izquierdo.

### Creación del agente de análisis

Vuelve al menú de navegación izquierdo y haz clic en **Data Analysis Agents**. Luego presiona el botón **Create Agent** para iniciar la configuración del agente.

![Panel de Data Analysis Agents](./AI%20Private%20Agent%20Factory/dpaf_image13.png)


### Selección de la base de datos

En el formulario de creación del agente, selecciona la base de datos que acabas de configurar como fuente de datos.

### Selección de tablas

Utiliza la barra de búsqueda para encontrar y seleccionar las tablas que el agente utilizará. El nombre de cada tabla corresponde al nombre del archivo CSV o tabla cargado en el Paso 1.

Escribe en el buscador la palabra ``player`` y selecciona la tabla `ADMIN.PLAYER_STATS`

#### Datos para el agente.

- Agente name: 

```text
Agente de análisis de rendimiento ofensivo de jugadores (xG)
```
- Description:
```text
Este agente analiza la tabla `player_stats` para responder consultas de rendimiento ofensivo por jugador y equipo, usando xG, goles, cantidad de tiros y eficiencia por disparo para comparar, rankear y detectar sobre/infra rendimiento.
```
- Help description:

```text
La tabla contiene estadísticas agregadas por jugador y equipo con las columnas:
- `PLAYER_ID`: identificador único del jugador.
- `PLAYER_NAME`: nombre del jugador.
- `TEAM_NAME`: nombre del equipo.
- `TOTAL_XG`: goles esperados acumulados.
- `GOALS`: goles anotados.
- `SHOT_COUNT`: total de remates.
- `XG_PER_SHOT`: calidad promedio de remate (`TOTAL_XG / SHOT_COUNT`).

### Reglas de respuesta
1. Responde con datos concretos y verificables de la tabla, 
1.1. siempre responde en ingles.
2. Si piden “mejores” o “top”, aclara el criterio usado (ej. más goles, más xG, mayor xG por tiro).
3. Para comparativas, muestra al menos:
   - valor de cada jugador,
   - diferencia absoluta,
   - y, si aplica, porcentaje.
4. Cuando sea útil, incluye métricas derivadas:
   - **Diferencia goles vs xG** = `GOALS - TOTAL_XG`.
   - **Conversión aproximada** = `GOALS / SHOT_COUNT`.
5. Si hay empates en ranking, desempata por `SHOT_COUNT` y luego por `PLAYER_NAME`.
6. Si el usuario no especifica filtros (equipo, top N, umbral de tiros), asume consulta global y acláralo.

### Buenas prácticas analíticas
- Evita conclusiones causales fuertes; presenta hallazgos descriptivos.
- Interpreta `XG_PER_SHOT` con cuidado en muestras pequeñas.
- Señala posibles limitaciones de calidad de texto (nombres con codificación especial).

### Formato de salida recomendado
- **Resumen breve** (1–2 líneas).
- **Tabla o lista ordenada** con métricas clave.
- **Insight final** con interpretación accionable.

### Ejemplos de consultas que debe resolver
- “Top 10 jugadores por goles.”
- “¿Quiénes sobre-rinden más respecto a su xG?”
- “Compara a dos jugadores por xG, goles y eficiencia.”
- “Top por xG por disparo con mínimo 20 tiros.”
- “Promedio de xG por equipo (agregado desde jugadores).”
```



<details>

<summary>📸📸 Paso a paso crear el agente 📸📸 </summary>


![Configuracion-agente-visualizacion.png](AI%20Private%20Agent%20Factory/Configuracion-agente-visualizacion.png)

</details>


### Acceso al agente publicado

Una vez publicado, el agente aparecerá listado en el panel de **Data Analysis Agents** del menú izquierdo. Haz clic en **Open Agent** para acceder a él y comenzar a utilizarlo.

---

## Paso 3 — Uso del agente para análisis de datos

### Apertura del agente

Al hacer clic en **Open Agent**, se abrirá el panel principal del agente, desde donde puedes interactuar con los datos cargados.

![Panel principal del agente](./AI%20Private%20Agent%20Factory/dpaf_image21.png)

### Exploración automática de los datos

Haz clic en el botón **Execute Exploration** para que el agente analice automáticamente los datos. Según los tipos de datos detectados en cada columna, el agente generará distintas visualizaciones y gráficas que te permitirán entender la distribución y estructura del dataset.

![Exploración de datos con gráficas](./AI%20Private%20Agent%20Factory/dpaf_image22.png)

### Consulta de datos en lenguaje natural

Puedes hacerle preguntas al agente directamente en lenguaje natural. El agente interpretará tu pregunta, generará una consulta SQL sobre la base de datos y te devolverá la respuesta.

> **Ejemplo:** si preguntas *"¿Cuántos equipos participaron?"*, el agente consultará la base de datos y responderá con el número de equipos.

### Visualización de la consulta SQL generada

Para ver la consulta SQL que el agente ejecutó para responder tu pregunta, haz clic en el botón **SQL**. Esto te permite auditar y entender cómo el agente traduce las preguntas a consultas sobre la base de datos.

---

<!-- PASO 4 — CONTINÚA AQUÍ -->
