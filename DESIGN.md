---
name: EBD Magallanes 2025 — sitio de difusión
description: El Boletín de Estudios Regionales UER-UMAG hecho navegable; cada pregunta se lee como una figura del impreso.
colors:
  noche: "#271743"
  violeta: "#6c4a9e"
  violeta-claro: "#75529d"
  magenta: "#d12c88"
  magenta-sobre-noche: "#ff7cc0"
  turquesa: "#0092a4"
  turquesa-sobre-noche: "#7fd3de"
  ambar: "#e3a847"
  tinta: "#2e2840"
  tinta-2: "#4d4560"
  tinta-3: "#6e6680"
  filete: "#e4dfee"
  papel: "#ffffff"
  lila-pie: "#d9cfeb"
  grafico-nominal-turquesa: "#0092a4"
  grafico-nominal-magenta: "#b0306f"
  grafico-ordinal-1: "#b89ad8"
  grafico-ordinal-2: "#9270bf"
  grafico-ordinal-3: "#6c4a9e"
  grafico-ordinal-4: "#41256f"
  grafico-div-neg-fuerte: "#a14d0c"
  grafico-div-neg: "#e9ac4f"
  grafico-div-neutro: "#dcd9e2"
  grafico-div-pos: "#5bb6c1"
  grafico-div-pos-fuerte: "#00707e"
  grafico-nsnr: "#d5d2dc"
  grafico-rejilla: "#ece8f2"
typography:
  display:
    fontFamily: "Bitter, 'Museo Slab', Georgia, serif"
    fontSize: "clamp(2.3rem, 4.6vw, 4.1rem)"
    fontWeight: 300
    lineHeight: 1.02
    letterSpacing: "-0.01em"
  display-enfasis:
    fontFamily: "Bitter, 'Museo Slab', Georgia, serif"
    fontSize: "clamp(2.3rem, 4.6vw, 4.1rem)"
    fontWeight: 800
    lineHeight: 1.02
    letterSpacing: "-0.015em"
  bajada:
    fontFamily: "Bitter, 'Museo Slab', Georgia, serif"
    fontSize: "clamp(1.08rem, 1.7vw, 1.42rem)"
    fontWeight: 300
    lineHeight: 1.62
  portada:
    fontFamily: "Asap, system-ui, sans-serif"
    fontSize: "clamp(2.5rem, 6.6vw, 5.6rem)"
    fontWeight: 800
    lineHeight: 0.98
    letterSpacing: "-0.01em"
  headline:
    fontFamily: "Asap, system-ui, sans-serif"
    fontSize: "1.62rem"
    fontWeight: 800
    letterSpacing: "-0.005em"
  title:
    fontFamily: "Asap, system-ui, sans-serif"
    fontSize: "1.26rem"
    fontWeight: 700
  cifra:
    fontFamily: "Bitter, 'Museo Slab', Georgia, serif"
    fontSize: "2.15rem"
    fontWeight: 800
    lineHeight: 1
    fontFeature: "tnum"
  cita:
    fontFamily: "Asap, system-ui, sans-serif"
    fontSize: "clamp(1.2rem, 2vw, 1.42rem)"
    fontWeight: 500
    lineHeight: 1.42
  body:
    fontFamily: "Asap, system-ui, sans-serif"
    fontSize: "17.5px"
    fontWeight: 400
    lineHeight: 1.62
  label:
    fontFamily: "Asap, system-ui, sans-serif"
    fontSize: "0.76rem"
    fontWeight: 700
    letterSpacing: "0.1em"
  pie:
    fontFamily: "Asap, system-ui, sans-serif"
    fontSize: "13px"
    fontWeight: 400
rounded:
  ninguno: "0px"
  tooltip: "2px"
  barra: "4px"
  barra-agrupada: "3px"
spacing:
  seccion: "3.6rem"
  subseccion: "2.9rem"
  figura-arriba: "0.85rem"
  figura-abajo: "1.3rem"
  pestanas-gap: "1.5rem"
components:
  apertura:
    backgroundColor: "{colors.noche}"
    textColor: "{colors.papel}"
    typography: "{typography.display}"
    height: "clamp(420px, 64vh, 640px)"
  bajada-barra:
    backgroundColor: "{colors.magenta}"
    textColor: "{colors.papel}"
    typography: "{typography.bajada}"
    padding: "0.06em 0.32em 0.1em"
  navbar:
    backgroundColor: "{colors.noche}"
    textColor: "{colors.papel}"
  figura-pregunta:
    backgroundColor: "{colors.papel}"
    textColor: "{colors.tinta}"
    rounded: "{rounded.ninguno}"
    padding: "0.85rem 0 0"
  pestana:
    textColor: "{colors.tinta-3}"
    typography: "{typography.label}"
    padding: "0.4rem 0 0.45rem"
  pestana-activa:
    textColor: "{colors.noche}"
    typography: "{typography.label}"
  cita:
    textColor: "{colors.magenta}"
    typography: "{typography.cita}"
    padding: "0 0 0 1.4rem"
  indice:
    backgroundColor: "{colors.noche}"
    textColor: "{colors.papel}"
    padding: "4.2rem 0 4.6rem"
  indice-cifra:
    textColor: "{colors.magenta-sobre-noche}"
    typography: "{typography.cifra}"
  portada-franja:
    backgroundColor: "{colors.turquesa}"
    textColor: "{colors.papel}"
    width: "64px"
  ficha:
    textColor: "{colors.tinta}"
    padding: "0.6rem 0"
  footer:
    backgroundColor: "{colors.noche}"
    textColor: "{colors.lila-pie}"
---

# Design System: EBD Magallanes 2025 — sitio de difusión

## Overview

**Creative North Star: "El boletín hecho navegable"**

El sitio es un número del Boletín de Estudios Regionales UER-UMAG (N°1, junio 2025) traducido a la pantalla. Cada sección abre como un artículo del impreso: campo noche violeta, fotografía regional a la derecha, titular slab con una línea liviana y otra negra itálica, bajada en barras magenta y una trama de puntos blancos. Debajo, el cuerpo es blanco, en Asap, y cada pregunta del cuestionario se presenta como una figura impresa: filete superior, enunciado «P:», pestañas de desagregación, gráfico, pie con base y prueba, y línea de fuente.

La densidad es editorial, no de tablero: una columna de lectura de 880px con índice lateral a la izquierda, párrafos de comentario entre figuras, sin tarjetas ni contenedores con fondo. El color se concentra en las aperturas, la portada y el índice (campos noche violeta a sangre); el cuerpo es papel blanco con tinta violeta oscura, turquesa en los encabezados de sección y magenta reservado para lo que señala.

La fotografía proviene de los Boletines N°1 y N°2 y siempre lleva crédito vertical en el borde derecho. El movimiento se limita a un barrido de la barra magenta de la bajada al cargar (0,95s, `cubic-bezier(.16, 1, .3, 1)`), anulado con `prefers-reduced-motion`.

**Key Characteristics:**
- Aperturas a sangre en noche violeta con foto, trama de puntos blancos y bajada sobre barras magenta.
- Cabecera corrida en itálica violeta «BOLETÍN DE ESTUDIOS REGIONALES / UER-UMAG» con filete bajo cada apertura.
- Figuras sin tarjeta: filete noche de 2px arriba, filetes lila finos dentro.
- Bitter (sustituto web de Museo Slab) para titulares, bajadas, rótulos y cifras; Asap para todo lo demás, incluidos los gráficos.
- Magenta como señal, no como relleno: barras de bajada, citas, estados activos, marcador de significancia.
- Gráficos echarts con paletas validadas para daltonismo deutan.

## Colors

Una noche violeta profunda como campo, violetas medios como voz del dato, y tres acentos del impreso (magenta, turquesa, ámbar) cada uno con un oficio fijo.

### Primary
- **Noche violeta** (noche): campo de aperturas, portada, índice, barra de navegación y pie; color de los titulares h3, del filete superior de cada figura y del texto de etiquetas de gráfico.
- **Violeta del boletín** (violeta): color de enlaces y de la barra simple de los gráficos de una serie; términos de la ficha técnica. Contraste 6,6:1 sobre blanco.
- **Violeta claro** (violeta-claro): voz secundaria en itálica: enunciado de la pregunta, cabecera corrida y su filete, título del índice lateral, barra de desplazamiento.

### Secondary
- **Magenta del boletín** (magenta): barras detrás de la bajada, citas destacadas y su filete de 1px, subrayado del enlace activo de la barra de navegación, estado activo de pestañas y del índice lateral, punto de «diferencia significativa», filete superior del tooltip, foco (`outline` de 2px) y selección de texto.
- **Magenta sobre noche** (magenta-sobre-noche): la versión clara del magenta para cifras grandes sobre campo noche (índice de resultados clave), donde el magenta pleno no alcanza contraste.

### Tertiary
- **Turquesa** (turquesa): encabezados de sección (h2) y franja vertical de la portada; también primer color nominal de los gráficos.
- **Turquesa sobre noche** (turquesa-sobre-noche): rótulos de grupo del índice sobre campo noche.
- **Ámbar** (ambar): solo el círculo de acento de la portada y los separadores «/» de la lista de temas.

### Neutral
- **Tinta** (tinta): texto de cuerpo.
- **Tinta 2** (tinta-2): notas de figura y subniveles del índice lateral.
- **Tinta 3** (tinta-3): pestañas inactivas, pie de figura y línea de fuente.
- **Filete lila** (filete): reglas internas de la figura (bajo las pestañas, sobre el pie) y de la ficha técnica.
- **Papel** (papel): fondo de lectura; texto sobre campos noche.
- **Lila de pie** (lila-pie): texto del pie de página sobre noche.

### Paletas de gráfico
- **Nominal de dos grupos** (sexo, territorio): turquesa + magenta profundo (grafico-nominal-turquesa, grafico-nominal-magenta). El magenta pleno se descartó aquí porque falla en deutan contra el turquesa.
- **Ordinal** (edad, GSE): rampa violeta de un tono, de claro a oscuro (grafico-ordinal-1…4; con 3 grupos se usan 1, intermedio #7f5cb0 y 4).
- **Divergente** (escalas de acuerdo/satisfacción): ámbar oscuro y ámbar al lado negativo, gris lila al centro, turquesa claro y turquesa profundo al positivo. NS/NR va en gris (grafico-nsnr). Texto dentro de segmentos claros en noche, en segmentos oscuros en blanco.

### Named Rules
**The Señal Magenta Rule.** El magenta marca lo que el lector debe notar o donde está: bajada, cita, estado activo, significancia. Nunca rellena barras de datos ni superficies.

**The Ámbar↔Turquesa Rule.** Las escalas divergentes van de ámbar (negativo) a turquesa (positivo) con gris al centro. Magenta↔turquesa está descartado por falla deutan.

## Typography

**Display Font:** Bitter (con Museo Slab y Georgia de respaldo)
**Body Font:** Asap (con system-ui)

**Character:** Slab itálica con contraste de peso extremo (300 frente a 800) sobre una sans humanista compacta; es la pareja del impreso, con Bitter en lugar del Museo Slab comercial.

### Hierarchy
- **Display** (Bitter 300 recto + 800 itálica, clamp(2.3rem, 4.6vw, 4.1rem), 1.02): titular de apertura; la parte en `*cursiva*` del título cae a una segunda línea negra itálica.
- **Bajada** (Bitter 300 itálica, clamp(1.08rem, 1.7vw, 1.42rem), 1.62): subtítulo de apertura en blanco sobre barras magenta que se repiten por línea.
- **Portada** (Asap 300 + 800 en mayúsculas, clamp(2.5rem, 6.6vw, 5.6rem), 0.98): solo el titular de tapa; líneas alternas liviana y extra negra.
- **Headline** (Asap 800, 1.62rem): encabezados de sección, en turquesa.
- **Title** (Asap 700, 1.26rem): título de cada pregunta, en noche.
- **Cifra** (Bitter 800 itálica, 2.15rem, cifras tabulares): porcentajes del índice de resultados clave.
- **Cita** (Asap 500 itálica, clamp(1.2rem, 2vw, 1.42rem), 1.42): cita destacada magenta.
- **Body** (Asap 400, raíz 17.5px, 1.62): comentario; máximo 70ch, justificado con guiones desde 768px.
- **Label** (Asap 700, 0.76rem, 0.1em, mayúsculas): pestañas de desagregación.
- **Pie** (Asap 13–13.5px): pie de figura y línea de fuente (esta en itálica).
- **Rótulos verticales** (Bitter 300 itálica 3.1rem magenta «Presentación»; Asap 300 mayúsculas hasta 7.4rem blanco «ÍNDICE»): rótulos de página del impreso, uno por bloque.

### Named Rules
**The Liviano-Negro Rule.** Los titulares grandes contrastan dos pesos extremos (300 y 800) en líneas separadas; nunca un único peso medio.

**The Asap-en-el-Canvas Rule.** Los gráficos echarts usan Asap con la familia entre comillas (`'Asap', system-ui, sans-serif`); sin comillas el canvas cae a 10px.

## Layout

Rejilla de Quarto con índice lateral izquierdo (250px), cuerpo de 880px y margen derecho de 200px. Las aperturas, la portada y el índice de resultados clave van a sangre; todo lo demás vive en la columna de cuerpo.

- **Apertura:** alto clamp(420px, 64vh, 640px); en escritorio la foto ocupa el 62% derecho y un degradado noche cubre el 38–72% izquierdo; el texto se apoya abajo (max 44rem). Bajo 992px la foto cubre todo y el degradado pasa a vertical, oscureciendo hacia abajo.
- **Portada:** alto min(92vh, 860px), rejilla de franja turquesa (64px; 34px bajo 768px) + cuerpo apoyado abajo; trama de puntos y círculo ámbar arriba a la derecha.
- **Índice de resultados clave:** dos columnas (rótulo gigante pegajoso de 10–18rem + lista); filas de cifra (8.4rem) + texto. Bajo 768px todo pasa a una columna.
- **Ritmo vertical:** sección 3.6rem arriba, pregunta 2.9rem (1.3rem si sigue a la sección), figura 0.85rem de aire bajo el filete y 1.3rem tras ella.
- **Gráficos en celular (≤560px de contenedor):** el nombre de cada categoría va encima de su barra y la barra usa todo el ancho; la leyenda se envuelve completa; el alto cambia entre `data-alto` y `data-alto-movil` según el ancho del contenedor.
- **Barra de navegación:** bajo 992px el título se acorta a «EBD Magallanes 2025»; bajo 420px desaparece.

## Elevation & Depth

Plano. La profundidad la dan los campos de color a sangre, los degradados sobre la fotografía y los filetes, no las sombras. La barra de navegación no tiene sombra ni borde.

### Shadow Vocabulary
- **Tooltip de gráfico** (`box-shadow: 0 6px 18px rgba(39,23,67,.16)`): única sombra del sistema, para el tooltip flotante, que además lleva filete superior magenta de 3px.

### Named Rules
**The Filete-no-Sombra Rule.** Las agrupaciones se separan con filetes (2px noche para abrir una figura o ficha; 1px lila adentro), nunca con sombras o fondos de tarjeta.

## Shapes

Esquinas rectas en toda la interfaz: aperturas, figuras, pestañas, ficha, índice. El redondeo existe solo en las marcas de dato (extremo de barra 4px, 3px en barras agrupadas, íconos de leyenda `roundRect`), el tooltip (2px), el punto de significancia y el círculo ámbar de la portada. La geometría recurrente del impreso es la trama de puntos blancos (puntos de ~3px cada 30px) y el texto en vertical (franja de portada, rótulo «Presentación», créditos fotográficos).

## Components

### Navegación
- **Barra:** noche, logo UER blanco (30px de alto), título en lila #cbbfe0 500. Enlaces Asap 600 blancos al 86% de opacidad; hover al 100%; activo con subrayado interior magenta de 3px.
- **Índice lateral:** título «En esta sección» en itálica violeta claro; primer nivel noche 700, subnivel tinta 2; activo en magenta con borde izquierdo magenta.
- **Pie:** noche, texto lila de pie, 0.84rem.

### Apertura de sección
Campo noche + foto + trama de puntos (150×190px, arriba a la derecha) + titular display + bajada en barras magenta con barrido de entrada. Crédito fotográfico vertical en mayúsculas de 11px sobre noche al 72%. Debajo, la cabecera corrida en itálica violeta claro de 13px con filete de 1px.

### Figura de pregunta (signature)
Sin tarjeta. Anatomía fija, en orden:
1. Filete noche de 2px.
2. Enunciado: «**P:**» en noche recta + texto en itálica violeta claro (0.95rem).
3. Pestañas Total / Sexo / Edad / GSE / Territorio: etiquetas en mayúsculas espaciadas, tinta 3; hover noche con subrayado lila; activa noche con subrayado magenta de 3px; filete lila bajo la fila. Flechas izquierda/derecha cambian de pestaña. Los paneles ocultos usan `visibility`, no `display:none`, para que echarts mida el ancho real.
4. Nota opcional (0.86rem, tinta 2).
5. Gráfico.
6. Pie sobre filete lila: «Respuestas: **n**», NS/NR o promedio, y en cruces la prueba Rao-Scott con punto magenta (significativa) o gris #cfc9da (no).
7. Línea de fuente en itálica 13px: «Fuente: UER-UMAG, Encuesta Bienestar y Desarrollo Magallanes 2025.»

### Gráficos
- **Barras horizontales (Total):** violeta, o colores divergentes en escalas; etiquetas de categoría en noche 14px; valor en negrita 13px a la derecha, con coma decimal; sin ejes visibles. NS/NR al final, en gris.
- **Apiladas al 100%:** segmentos separados por 2px blancos; cifra dentro solo si cabe (y si ≥3%); leyenda arriba con cuadros redondeados de 12px.
- **Agrupadas por cruce:** una serie por grupo con paleta nominal u ordinal; eje de valores con rejilla lila #ece8f2.
- **Columnas (escalas 1–7, 1–10):** violeta, valor encima.
- **Tooltip:** blanco, borde lila #d9d3e4, filete superior magenta, nombre en negrita, valor y n.

### Cita destacada
Itálica magenta 500 con filete vertical magenta de 1px a la izquierda; máximo 40rem. Como máximo una por página de sección.

### Portada
Foto en duotono violeta a sangre; franja turquesa vertical «EBD Magallanes / Noviembre 2025»; titular en mayúsculas liviano + extra negro; lista de temas en mayúsculas separados por «/» ámbar, cada tema un enlace con subrayado blanco al 35% (magenta al pasar); logo UER blanco y línea de ficha.

### Índice de resultados clave
Campo noche a sangre; rótulo «ÍN/DI/CE» gigante en Asap 300; grupos con rótulo turquesa claro sobre filete blanco al 55%; filas con cifra Bitter itálica magenta clara + texto lila claro, filete blanco al 18%; hover con velo magenta al 14%. Cada fila enlaza a su figura.

### Ficha técnica
Lista de definiciones en dos columnas (término violeta 700 + valor), filete noche de 2px arriba y lila entre filas; una columna bajo 768px.

## Do's and Don'ts

### Do:
- **Do** abrir cada página de sección con la apertura: foto de los boletines UER, titular con su parte en cursiva, bajada y crédito fotográfico.
- **Do** presentar toda pregunta con la anatomía completa de la figura, incluida la línea de fuente.
- **Do** escribir cifras en es-CL: un decimal, coma decimal, punto de miles, sin signo % cuando el eje ya lo indica.
- **Do** usar la paleta divergente ámbar↔gris↔turquesa para escalas, la rampa violeta para grupos ordinales y turquesa + magenta profundo para dos grupos nominales.
- **Do** dar a cada gráfico su versión de celular (etiqueta sobre la barra, alto móvil) con el mecanismo `media` y `data-alto-movil`.
- **Do** usar la versión clara de magenta o turquesa cuando el texto va sobre campo noche.

### Don't:
- **Don't** convertir figuras o cifras en tarjetas con fondo, sombra o esquinas redondeadas; las figuras se separan con filetes.
- **Don't** usar píldoras para las pestañas; son etiquetas subrayadas.
- **Don't** rellenar barras de datos con magenta pleno #d12c88 ni emparejarlo con turquesa en una escala divergente.
- **Don't** extender el ámbar más allá del círculo de portada, los separadores y el lado negativo de las escalas.
- **Don't** declarar la fuente del canvas sin comillas ni con otra familia que Asap.
