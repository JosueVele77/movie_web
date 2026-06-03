# CineStore

<p align="center">
  <img src="src/main/webapp/img/logo-cinestore.svg" alt="CineStore" width="130">
</p>

<h3 align="center">Tienda web de peliculas digitales con catalogo TMDB, compras, favoritos, perfiles y panel administrativo.</h3>

<p align="center">
  <img src="https://img.shields.io/badge/Java-Servlets-orange?style=for-the-badge&logo=openjdk&logoColor=white" alt="Java">
  <img src="https://img.shields.io/badge/Jakarta-Servlet%206-blue?style=for-the-badge&logo=jakartaee&logoColor=white" alt="Jakarta Servlet">
  <img src="https://img.shields.io/badge/JSP-Views-red?style=for-the-badge" alt="JSP">
  <img src="https://img.shields.io/badge/PostgreSQL-Database-316192?style=for-the-badge&logo=postgresql&logoColor=white" alt="PostgreSQL">
  <img src="https://img.shields.io/badge/Gradle-Build-02303A?style=for-the-badge&logo=gradle&logoColor=white" alt="Gradle">
</p>

---

## Vista General

**CineStore** es una aplicacion web tipo tienda de peliculas. Permite explorar peliculas desde TMDB, ver detalles, comprar contenido digital, administrar perfil, elegir avatar, guardar favoritos y controlar productos/usuarios desde paneles internos segun el rol del usuario.

El proyecto esta construido como aplicacion **Java Web WAR**, pensada para ejecutarse en **Apache Tomcat** con base de datos **PostgreSQL**.

## Tecnologias Utilizadas

| Tecnologia | Descripcion |
| --- | --- |
| <p align="center"><img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/java/java-original.svg" alt="Java" width="62"><br><strong>Java</strong></p> | Lenguaje principal del backend. Se usa para controladores, modelos, DAO, validadores y acceso a datos. |
| <p align="center"><img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/tomcat/tomcat-original.svg" alt="Tomcat" width="62"><br><strong>Tomcat 10</strong></p> | Servidor recomendado para desplegar el archivo `peliculas.war`. Compatible con Jakarta Servlet 6 y aplicaciones JSP modernas. |
| <p align="center"><img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/postgresql/postgresql-original.svg" alt="PostgreSQL" width="62"><br><strong>PostgreSQL</strong></p> | Base de datos del sistema. Guarda usuarios, roles, productos, compras, favoritos, estados civiles y registros de auditoria. |
| <p align="center"><img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/gradle/gradle-original.svg" alt="Gradle" width="62"><br><strong>Gradle</strong></p> | Gestiona dependencias, compilacion y empaquetado del proyecto como archivo WAR. |
| <p align="center"><img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/bootstrap/bootstrap-original.svg" alt="Bootstrap" width="62"><br><strong>Bootstrap</strong></p> | Framework CSS usado para la interfaz, formularios, botones, modales, grillas responsive e iconografia visual. |
| <p align="center"><img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/javascript/javascript-original.svg" alt="JavaScript" width="62"><br><strong>JavaScript</strong></p> | Controla el catalogo, carrusel, busqueda, consumo de TMDB, favoritos, compra, trailers, tema claro/oscuro y validaciones del cliente. |
| <p align="center"><img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/html5/html5-original.svg" alt="HTML5" width="62"><br><strong>JSP / HTML</strong></p> | Construye las vistas dinamicas de la aplicacion, combinando HTML con datos de sesion y contenido renderizado desde el servidor. |
| <p align="center"><img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/css3/css3-original.svg" alt="CSS3" width="62"><br><strong>CSS3</strong></p> | Define el estilo visual de CineStore: tarjetas, navbar, perfil, checkout, modo claro/oscuro, avatares y animaciones. |
| <p align="center"><img src="https://www.themoviedb.org/assets/2/v4/logos/v2/blue_long_2-9665a782ddf4f9d8b21c8eaa0f8a80b53f8fdf69a4f6c6e2da0c50a46056f8a7.svg" alt="TMDB" width="110"><br><strong>TMDB API</strong></p> | Provee peliculas, categorias, posters, fondos, ratings, sinopsis, duracion y trailers para alimentar el catalogo. |

## Funcionalidades Principales

- Catalogo principal con peliculas recientes, populares, busqueda y carrusel.
- Detalle de pelicula con poster, sinopsis, rating, duracion, trailer y categorias clicables.
- Compra de peliculas con validacion de tarjeta y redireccion a **Mi Contenido**.
- Biblioteca del usuario con peliculas compradas y boton para empezar a ver.
- Favoritos por usuario.
- Registro e inicio de sesion.
- Avatares seleccionables en registro y perfil.
- Perfil editable con compras recientes sincronizadas.
- Modo claro y modo oscuro.
- Panel administrativo para usuarios, productos, auditoria y analisis.
- Roles: **Administrador**, **Empleado** y **Cliente**.
- Validacion de cedula ecuatoriana.

## Modulos Del Sistema

| Modulo | Archivo / Ruta |
| --- | --- |
| Inicio / catalogo | `src/main/webapp/index.jsp` |
| Login | `src/main/webapp/pages/login.jsp` |
| Registro | `src/main/webapp/pages/registro.jsp` |
| Perfil | `src/main/webapp/pages/profile.jsp` |
| Detalle de pelicula | `src/main/webapp/pages/detalle.jsp` |
| Compra | `src/main/webapp/pages/compra.jsp` |
| Mi contenido | `src/main/webapp/pages/my_content.jsp` |
| Favoritos | `src/main/webapp/pages/favorites.jsp` |
| Categorias | `src/main/webapp/pages/category.jsp` |
| Experiencia 3D | `src/main/webapp/pages/3d.jsp` |
| Dashboard admin | `src/main/webapp/pages/dashboard.jsp` |
| Usuarios | `src/main/webapp/pages/usuarios.jsp` |
| Vendedor / productos | `src/main/webapp/pages/vendedor.jsp` |
| Auditoria | `src/main/webapp/pages/auditoria.jsp` |
| Analisis | `src/main/webapp/pages/analisis.jsp` |

## Estructura Del Proyecto

```text
movie_web/
|-- base.sql
|-- build.gradle
|-- settings.gradle
|-- gradlew / gradlew.bat
`-- src/
    `-- main/
        |-- java/io/github/josuevele77/movie_web/
        |   |-- config/       # Conexion PostgreSQL
        |   |-- controller/   # Servlets
        |   |-- dao/          # Acceso a datos
        |   |-- model/        # Modelos
        |   `-- utils/        # Validadores y utilidades
        |-- resources/
        `-- webapp/
            |-- css/
            |-- img/
            |-- js/
            |   `-- utils/
            |-- pages/
            `-- WEB-INF/
```

## Requisitos

- Java JDK 17 o superior.
- Gradle Wrapper incluido en el proyecto.
- Apache Tomcat 10.1 o superior.
- PostgreSQL 16 o compatible.
- Conexion a internet para cargar TMDB, Bootstrap CDN, iconos y assets externos.

## Configuracion De Base De Datos

La conexion esta configurada en:

```java
src/main/java/io/github/josuevele77/movie_web/config/DatabaseConnection.java
```

Valores actuales:

```text
Base de datos: db_producto
Usuario: postgres
Password: root
Puerto: 5432
```

Para preparar la base:

1. Crear la base de datos en PostgreSQL:

```sql
CREATE DATABASE db_producto;
```

2. Ejecutar el script:

```bash
psql -U postgres -d db_producto -f base.sql
```

3. Verificar que existan las tablas principales:

```text
tb_usuario
tb_producto
tb_categoria
tb_compra
tb_detalle_compra
tb_favorito
tb_perfil
tb_estadocivil
auditoria.tb_auditoria
```

## Usuario Inicial

El script `base.sql` incluye un usuario administrador:

```text
Correo: admin@cinestore.com
Clave: admin123
Rol: Administrador
```

## Ejecucion Del Proyecto

Compilar el proyecto:

```bash
./gradlew build
```

En Windows:

```powershell
.\gradlew.bat build
```

El archivo WAR queda en:

```text
build/libs/movie_web-1.0-SNAPSHOT.war
```

Para usar la ruta que maneja la aplicacion en las capturas:

1. Renombrar el WAR a `peliculas.war`.
2. Copiarlo en la carpeta `webapps` de Tomcat.
3. Iniciar Tomcat.
4. Abrir:

```text
http://localhost:8080/peliculas/
```

## API De Peliculas

El catalogo usa **The Movie Database (TMDB)** desde JavaScript:

```text
src/main/webapp/js/script.js
```

La aplicacion obtiene:

- Peliculas tendencia.
- Peliculas populares.
- Busqueda por titulo.
- Detalle de pelicula.
- Posters y backdrops.
- Categorias/generos.
- Trailers disponibles.

## Rutas Backend Importantes

| Servlet | Funcion |
| --- | --- |
| `LoginServlet` | Autenticacion de usuarios |
| `RegistroServlet` | Creacion de cuentas |
| `LogoutServlet` | Cierre de sesion |
| `ActualizarPerfilServlet` | Actualizacion de datos y avatar |
| `CompraServlet` | Registro de compras |
| `FavoritoServlet` | Agregar / quitar favoritos |
| `DashboardServlet` | Panel principal administrativo |
| `UsuariosServlet` | Gestion de usuarios |
| `VendedorServlet` | Gestion de productos para empleado |
| `ActualizarPrecioServlet` | Cambio de precio |
| `OcultarProductoServlet` | Ocultar productos |
| `ReactivarProductoServlet` | Reactivar productos |
| `AuditoriaServlet` | Vista de auditoria |
| `AnalisisServlet` | Vista de analisis |

## Flujo De Compra

1. El usuario selecciona una pelicula desde el catalogo o el detalle.
2. Si no tiene sesion activa, se redirige al login.
3. En `compra.jsp` se validan los datos de tarjeta.
4. `CompraServlet` registra la compra en PostgreSQL.
5. La compra se sincroniza con `Mi Contenido`.
6. El perfil actualiza `Compras recientes`.

## Roles

| Rol | Acceso principal |
| --- | --- |
| Administrador | Dashboard, usuarios, auditoria, analisis y reactivacion de productos |
| Empleado | Gestion de productos, precios y visibilidad |
| Cliente | Catalogo, compras, favoritos, perfil y contenido comprado |

## Comandos Utiles

Compilar:

```bash
./gradlew build
```

Limpiar build:

```bash
./gradlew clean
```

Generar WAR:

```bash
./gradlew war
```

Ver estado de Git:

```bash
git status
```

## Notas Importantes

- La aplicacion usa sesiones HTTP para proteger paginas como perfil, compra, favoritos y paneles internos.
- El contexto usado normalmente es `/peliculas`.
- Si se cambia el nombre del WAR, tambien cambia la ruta final en Tomcat.
- La clave de TMDB esta actualmente en el frontend, dentro de `script.js`.
- La configuracion de PostgreSQL esta fija en `DatabaseConnection.java`; si cambian tus credenciales, actualiza ese archivo.

## Autor

Desarrollado por **Josue Vele** como practica Java Web.

<p align="center">
  <strong>CineStore</strong><br>
  Tu tienda visual de peliculas digitales.
</p>
