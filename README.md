# Sitio web de difusión — EBD Magallanes 2025

Sitio estático (Quarto *website*) con los resultados de la encuesta, inspirado en
el formato de [survey.stackoverflow.co/2025](https://survey.stackoverflow.co/2025/):
portada con resultados clave, una página por módulo, índice lateral y un bloque
por pregunta con pestañas **Total / Sexo / Edad / GSE / Territorio**.
Gráficos interactivos con `echarts4r`.

## Renderizar

Desde esta carpeta (Quarto ejecuta R con esta carpeta como directorio de trabajo):

```bash
cd 6_Reportes/Web_Difusion
quarto render          # todo el sitio → _site/
quarto preview         # servidor local con recarga automática
```

El resultado en `_site/` es autocontenido (HTML + `site_libs/`).

## Publicar

Sitio publicado en <https://uer-umag.github.io/ebd-magallanes-2025/>
(repositorio [uer-umag/ebd-magallanes-2025](https://github.com/uer-umag/ebd-magallanes-2025)).

El sitio se renderiza **localmente**: `R/setup_web.R` lee la base interna
(`2_data/processed/`), que no se sube al repositorio. Para actualizar la web:

```bash
quarto publish gh-pages    # renderiza y sube _site/ a la rama gh-pages
git add -A && git commit -m "…" && git push   # fuentes en main
```

El repositorio git vive fuera de Google Drive (`~/git/ebd-magallanes-2025.git`;
el archivo `.git` de esta carpeta apunta ahí) para evitar conflictos de
sincronización.

## Estructura

| Archivo | Contenido |
|---|---|
| `_quarto.yml` | Navegación, tema y grilla |
| `estilos.scss` | Estilos (tipografía Source Sans 3, colores institucionales) |
| `js/tabs.html` | Pestañas de cada bloque y redibujo de gráficos al cargar la fuente |
| `R/setup_web.R` | Datos, estimaciones ponderadas, prueba Rao-Scott y helpers de gráficos |
| `index.qmd` | Portada y resultados clave |
| `perfil.qmd`, `bienestar.qmd`, `hidrogeno.qmd`, `ciencia.qmd`, `democracia.qmd` | Secciones |
| `metodologia.qmd` | Ficha técnica y guía de lectura |
| `datos.qmd` | Descarga de la base pública (R, Stata, SPSS), libro de códigos y cuestionario |
| `descargas/` | Archivos descargables (no editar a mano; ver abajo) |

## Agregar una pregunta

```r
# Respuesta única: tipo "nominal" (por frecuencia), "escala" (divergente) o "numerica"
bloque("a5", texto = "…", tipo = "escala", n_neg = 1, neutral = "Estancada")

# Batería: Total apilado por ítem; cruces con % favorable
bloque_bateria("b5", items = c(b5_a = "Gobierno de Chile", ...),
               n_neg = 2, favorables = c("Bastante confianza", "Mucha confianza"),
               etiqueta_fav = "Bastante o mucha confianza")
```

Las cifras del texto se escriben con `` `r P("a1", c("Satisfecho", "Totalmente satisfecho"))` ``
para que se actualicen solas si cambian los datos.

## Criterios

- Porcentajes ponderados por `pond`; «No aplica» fuera de la base; NS/NR dentro del
  denominador (no se dibuja en barras apiladas).
- Las escalas guardadas de positivo a negativo (`a5`, `a6_*`, `a8_*`, `b6`, `c1`, `c3`)
  se invierten en `setup_web.R` para ordenarlas de negativo a positivo.
- Prueba χ² de Rao-Scott (excluye NS/NR), p < 0,05.

## Diseño

Estética del Boletín de Estudios Regionales N°1 (UER-UMAG). El sistema
(tokens, tipografía, componentes, paletas de gráficos y reglas) está en
`DESIGN.md`; el contexto del producto en `PRODUCT.md`. Las aperturas usan
`title-block-banner` en el YAML de cada página (`title` con `*parte negra*`,
`subtitle` sobre barra magenta). Fotos en `img/fotos/` con su origen
incrustado en los metadatos de cada archivo.

## Datos descargables

`descargas/` se regenera, no se edita a mano. Desde la raíz del proyecto:

```bash
Rscript 4_scripts/05_bases_publicas.R      # bases .rds/.dta/.sav (versión anonimizada)
6_Reportes/Libro_Codigos/compilar.sh       # libro de códigos PDF (se copia a descargas/)
```

El cuestionario (`EBD_Magallanes_2025_cuestionario.pdf`) es copia de
`1_metadatos/Cuestionario/Cuestionario EBD Magallanes 2025.pdf`.
