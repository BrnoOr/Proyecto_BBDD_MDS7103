# MDS7103 - Bases de Datos · Hito 3

Análisis de datos sobre el **Directorio Oficial de Establecimientos Educacionales de Chile (2025)**, aplicando consultas SQL de complejidad variada, optimización mediante índices y visualizaciones de apoyo.

## Descripción del problema

Caracterización de la oferta educacional en Chile a partir del directorio oficial de establecimientos, explorando su distribución territorial (región, provincia, comuna), tipo de sostenedor, niveles de enseñanza y especialidades.

## Datos y modelo relacional

Los datos provienen del Directorio Oficial de Establecimientos Educacionales publicado por el MINEDUC. A partir de la fuente cruda se generó un modelo relacional normalizado con tablas de dimensiones (región, provincia, comuna, sostenedor, nivel educativo, enseñanza, especialidad) y tablas puente para las relaciones muchos-a-muchos con los establecimientos.


## Estructura del repositorio

```
.
├── sql/
│   ├── 01_creacion_tablas.sql    # DDL: creación de tablas del modelo
│   ├── 02_indices.sql            # Índices y vistas materializadas
│   └── 03_consultas.sql          # Consultas del análisis
├── notebooks/
│   └── separacion_datos.ipynb    # Limpieza y separación de la fuente en tablas
|   └── EDA.ipynb                 # Análisis de consultas
├── Datos/
│   ├── ER_Directorio_Oficial_EE_WEB.pdf   # Diagrama entidad-relación
│   └── tablas/                   # CSV procesados listos para poblar la BD
├── .gitignore
└── README.md
```

## Datos fuente (descarga externa)

El archivo crudo del directorio (`20250926_Directorio_Oficial_EE_2025_20250430_WEB.csv`) y el
`Frecuencias_Directorio_Oficial_EE_2025.xlsx`. Para reproducir
el proyecto, descárgalos desde la fuente oficial y colócalos en `Datos/fuente/`:

- Fuente: https://datosabiertos.mineduc.cl/wp-content/uploads/2025/11/Directorio-Oficial-EE-2025.rar

Las tablas ya procesadas (`Datos/tablas/Tabla_*.csv`) sí están incluidas y son suficientes para
poblar la base de datos sin necesidad del archivo crudo.

## Consultas del análisis

El análisis incluye al menos 6 consultas de complejidad variada:

1. Consulta 1 — ¿Los establecimientos que imparten educación técnico-profesional están distribuidos equitativamente entre regiones, o se concentran en la región metropolitana?
2. Consulta 2 — ¿En qué comuna de Santiago se concentran los establecimientos educacionales con un pago de mensualidad de más de \$100.000?
3. Consulta 3 — ¿A medida que un sostenedor concentra más establecimientos, tiende a cobrar más o menos mensualidad a las familias?
4. Consulta 4 — ¿Los establecimientos con programa PACE tienden a tener mayor matrícula en enseñanza media humanista-científica o en técnico-profesional?
5. Consulta 5 — ¿La proporción de establecimientos de orientación evangélica versus católica varía según la ruralidad del establecimiento?
6. Consulta 6 — ¿Los establecimientos que ofrecen tanto enseñanza media jóvenes como enseñanza media adulta en la misma área (por ejemplo humanista-científica en jóvenes y humanista-científica en adultos) tienden a tener mayor matrícula total que los que solo ofrecen una modalidad?

Al menos una consulta es parametrizable y resistente a inyección SQL (uso de consultas
parametrizadas / *prepared statements*).

## Optimizaciones

Los índices y vistas materializadas creadas para asegurar tiempos de ejecución razonables
están en [`sql/02_indices.sql`](sql/02_indices.sql).

<!-- AJUSTAR: mencionar brevemente los índices clave, p. ej. sobre claves foráneas de las tablas puente -->

## Cómo reproducir

1. Descargar los datos fuente (ver sección anterior) y colocarlos en `Datos/fuente/`.
2. Ejecutar el notebook `notebooks/separacion_datos.ipynb` para generar/actualizar los CSV en `Datos/tablas/`. <!-- omitir si ya usas los CSV incluidos -->
3. Crear la base de datos y las tablas: `psql -d nombre_bd -f sql/01_creacion_tablas.sql`. <!-- AJUSTAR motor: psql/mysql/etc. -->
4. Poblar las tablas desde los CSV de `Datos/tablas/`.
5. Crear índices y vistas: `psql -d nombre_bd -f sql/02_indices.sql`.
6. Ejecutar las consultas del análisis: ver `sql/03_consultas.sql` o el notebook.

## Curso

MDS7103 - Bases de Datos · Universidad de Chile · Hito 3
