# Departamento de Anomalías Domésticas

**Una práctica de Java y Spring Boot donde el problema no es vender productos, sino conseguir que una cocina vuelva a obedecer las leyes de la física.**

El proyecto está vacío de lógica de negocio: incluye la clase de arranque, las dependencias, la conexión a MySQL, el SQL inicial y una página estática con Swagger UI. No hay entidades, repositorios, servicios ni controladores de negocio resueltos. El enunciado está en [PROYECTO.md](PROYECTO.md).

La práctica incluye **DTO, filtros, paginación, manejo global de errores y lógica más allá del CRUD**: reglas de asignación y cierre, cálculo de prioridades y un algoritmo que propone un plan de guardia sin repetir especialistas. Se desarrolla por pasos, con estructura sencilla y sin arquitectura avanzada.

## Tecnologías

- Java 21 y Maven 3.6.3 o superior.
- Spring Boot 3.5.16: Web, Data JPA y Validation.
- MySQL 8.4 en Docker Compose.
- Lombok para reducir código repetitivo (getters, setters y constructores).
- HTML, CSS y JavaScript para Swagger UI y una guía con ejemplos educativos (sin frontend de negocio).
- Sin tests, autenticación ni configuración avanzada de logs.

## Arrancar

Desde PowerShell, con Docker Desktop abierto:

```powershell
cd "$HOME\Documents\t\anomalias-domesticas"
docker compose up -d --wait
mvn spring-boot:run
```

La primera vez se descargarán la imagen de MySQL y las dependencias de Maven. También puedes abrir `pom.xml` en IntelliJ o Eclipse y ejecutar `AnomaliasApplication` una vez arrancado MySQL.

La aplicación escucha en `http://localhost:8080`. Abre esa dirección para ver **Swagger UI en la página raíz**. La consola debe mostrar `Started AnomaliasApplication`.

### Documentación interactiva

La página raíz agrupa las **14 operaciones** del enunciado e incluye parámetros, filtros, paginación, cuerpos JSON, ejemplos, respuestas y errores esperados. Puedes buscar operaciones y ejecutarlas con **Try it out → Execute**.

**Los endpoints de negocio siguen pendientes de implementación:** las peticiones a `/api/**` devolverán 404 hasta que escribas sus controladores. Swagger no simula respuestas. Una vez implementados, los POST y PATCH ejecutados desde la página modificarán la base de datos real de desarrollo.

- `src/main/resources/static/index.html`: página raíz.
- `src/main/resources/static/css/swagger.css`: estilos de la página y ajustes responsive.
- `src/main/resources/static/js/swagger.js`: inicialización de Swagger y servidor de destino.
- `src/main/resources/static/openapi.json`: contrato OpenAPI 3.0.3; disponible en `/openapi.json` y descargable desde la página.

Swagger UI utiliza CSS y JavaScript desde jsDelivr con versión fijada (`5.17.14`), por lo que el navegador necesita acceso a Internet. El contrato y los archivos propios son locales. Las peticiones apuntan al origen de la página, respetando su puerto y context-path; no se envía el contrato a un validador externo.

La documentación es manual: cuando cambies una ruta, un DTO o una regla, actualiza `openapi.json`. No se ha añadido springdoc ni generación automática desde controladores.

### Guía de funcionalidad y ejemplos

Abre `http://localhost:8080/guia.html` o pulsa **Cómo funciona el proyecto** desde Swagger. La guía explica el recorrido de un aviso, las cuatro entidades, las condiciones de asignación, los tres resultados de cierre, la prioridad y el plan de guardia.

Incluye ejemplos de peticiones que puedes copiar, botones para explorar desenlaces y una calculadora educativa de prioridad. **Estas interacciones son locales: no llaman al backend ni modifican MySQL.** La guía funciona sin librerías externas; con JavaScript desactivado sigue mostrando el contenido explicativo y los ejemplos estáticos.

Archivos: `src/main/resources/static/guia.html`, `css/guia.css` y `js/guia.js`. Hay enlaces en ambos sentidos entre Swagger y la guía.

### Lombok

Lombok está configurado en Maven como dependencia y procesador de anotaciones; su versión la gestiona Spring Boot. No se incluye en el JAR ejecutable porque solo se necesita al compilar.

En IntelliJ, si no reconoce los métodos generados, comprueba el soporte/plugin de Lombok y activa **Settings → Build, Execution, Deployment → Compiler → Annotation Processors → Enable annotation processing**. En Eclipse puede ser necesario instalar la integración de Lombok. Después recarga el proyecto Maven.

El uso recomendado de anotaciones para entidades, servicios y DTO está en la sección 7.7 de `PROYECTO.md`.

Para compilar y generar el ejecutable:

```powershell
mvn package
java -jar target/anomalias-domesticas-0.0.1-SNAPSHOT.jar
```

## Base de datos

| Campo | Valor local |
| --- | --- |
| Host | `localhost` |
| Puerto | `3317` |
| Base de datos | `anomalias` |
| Usuario | `anomalias_app` |
| Contraseña | `anomalias_local` |

Estas credenciales son únicamente de desarrollo. MySQL solo se publica en la interfaz local del equipo. No reutilices esta configuración en producción.

`database/01-inicializar.sql` crea **4 tablas** y carga **4 viviendas, 6 especialistas, 8 anomalías y 3 intervenciones**. Docker lo ejecuta automáticamente **solo si el volumen de datos está vacío**. No hace falta importar nada manualmente.

Para consultar los datos desde la terminal:

```powershell
docker compose exec mysql mysql -u anomalias_app -p anomalias
```

Introduce la contraseña anterior y ejecuta, por ejemplo:

```sql
SHOW TABLES;
SELECT id, titulo, peligrosidad, estado FROM anomalias;
```

Hibernate está configurado con `ddl-auto: validate`: cuando escribas las entidades comprobará que coinciden con el SQL, sin crear ni modificar tablas. Fechas de aplicación y base de datos se interpretan en UTC; puedes mapear los `DATETIME` a `LocalDateTime` siguiendo esa convención.

## Parar y reiniciar

Detén Java con `Ctrl+C` y MySQL con:

```powershell
docker compose down
```

Los datos se conservan. Para **borrar todos los datos de este proyecto** y volver a cargar el SQL desde cero, ejecuta deliberadamente:

```powershell
docker compose down -v
docker compose up -d --wait
```

Modificar el SQL y reiniciar el contenedor sin eliminar el volumen **no** vuelve a ejecutar el fichero.

## Estructura inicial

```text
anomalias-domesticas/
├── database/
│   └── 01-inicializar.sql
├── src/main/
│   ├── java/com/example/anomalias/AnomaliasApplication.java
│   └── resources/
│       ├── application.yml
│       └── static/
│           ├── index.html
│           ├── guia.html
│           ├── favicon.svg
│           ├── openapi.json
│           ├── css/
│           │   ├── swagger.css
│           │   └── guia.css
│           └── js/
│               ├── swagger.js
│               └── guia.js
├── compose.yaml
├── pom.xml
├── PROYECTO.md
└── README.md
```

Si el puerto 3317 está ocupado, cambia el puerto publicado en `compose.yaml` y la URL en `application.yml`. Para cambiar solo el puerto de Java, puedes definir `$env:SERVER_PORT = '8081'` antes de arrancar.
