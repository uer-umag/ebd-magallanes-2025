###########################################################################
# Setup del sitio web de difusión — EBD Magallanes 2025
# autor: Marcelo Miño
# descripción:
#   Datos, estimaciones ponderadas y gráficos echarts (echarts4r) para el
#   sitio Quarto de 6_Reportes/Web_Difusion. Cada página .qmd hace
#   source("R/setup_web.R") y llama a bloque("variable") por pregunta.
#
#   No se usa 4_scripts/02_setup.R porque ese script hace rm(list = ls()),
#   carga ~10 paquetes de gráficos estáticos y fija rutas relativas a la raíz
#   del proyecto. Aquí se replica solo lo necesario: los datos y el ponderador.
# fecha creación: 2026-10-04
###########################################################################

suppressPackageStartupMessages({
  library(dplyr)
  library(forcats)
  library(stringr)
  library(purrr)
  library(htmltools)
  library(echarts4r)
  library(survey)
})

# Datos -----------------------------------------------------------------------
# Ruta relativa a 6_Reportes/Web_Difusion (directorio de render de Quarto).
ebd <- readRDS("../../2_data/processed/ebd_magallanes25_final.rds")

# Variables haven_labelled (p. ej. b3, gse) a factor con etiquetas
ebd <- ebd |>
  mutate(across(where(haven::is.labelled), haven::as_factor))

# Unificar las variantes de NS/NR ("(NO LEER) NS/NR", "(NO LEER) NS/NR)", ...)
ebd <- ebd |>
  mutate(across(
    where(is.factor),
    ~ fct_relabel(.x, function(l) if_else(str_detect(l, "NS/NR"), "NS/NR", l))
  ))

ebd <- ebd |>
  mutate(
    a1 = fct_recode(a1, "Totalmente satisfecho" = "Totalmente Satisfecho"),
    across(starts_with("a2_"), ~ fct_recode(.x, "Totalmente satisfecho" = "Totalmente Satisfecho")),
    a10 = fct_recode(a10, "1" = "1. Muy lento", "10" = "10. Muy rápido"),
    e6 = fct_recode(e6, "Otra situación" = "Otra situación ¿Cuál?"),
    e5 = fct_recode(e5, "Postgrado (máster, doctorado o equivalente)" = "Post grado (Máster, doctorado o equivalente)")
  )

# Escalas guardadas de positivo a negativo: se invierten para que todas
# queden ordenadas de negativo a positivo (requisito de colores_escala())
invertir <- function(x) fct_relevel(fct_rev(x), "NS/NR", after = Inf)
ebd <- ebd |>
  mutate(across(c(a5, starts_with("a6_"), starts_with("a8_"), b6, c1, c3), invertir))

N_TOTAL <- nrow(ebd)

# Diseño para pruebas de independencia (mismo criterio que 02_setup.R:
# ponderado, sin estratos)
diseno <- svydesign(ids = ~1, weights = ~pond, data = ebd)

# Cruces estándar ---------------------------------------------------------------
cruces <- c(sexo = "Sexo", edad2 = "Edad", gse2 = "GSE", conglomerado = "Territorio")

# Paletas (Boletín de Estudios Regionales N°1; validadas con el validador
# de la skill dataviz) ------------------------------------------------------
VIOLETA   <- "#6c4a9e"   # barra simple (violeta del boletín, 6,6:1 sobre blanco)
AZUL      <- VIOLETA     # alias histórico
GRIS_NSNR <- "#d5d2dc"
# Grupos nominales de 2 categorías (sexo, territorio): turquesa + magenta
# profundo (magenta pleno #d12c88 falla CVD deutan contra turquesa)
PAL_NOMINAL <- c("#0092a4", "#b0306f")
# Grupos ordinales (edad, GSE): rampa violeta de un solo tono
PAL_ORDINAL <- list(
  `3` = c("#b89ad8", "#7f5cb0", "#41256f"),
  `4` = c("#b89ad8", "#9270bf", "#6c4a9e", "#41256f")
)
# Divergente ámbar ↔ turquesa con gris al centro (CVD validada)
DIV_NEG2  <- c("#a14d0c", "#e9ac4f")
DIV_POS2  <- c("#5bb6c1", "#00707e")
DIV_NEUTR <- "#dcd9e2"

colores_grupo <- function(var, grupos) {
  k <- length(grupos)
  if (var %in% c("edad2", "gse2") && as.character(k) %in% names(PAL_ORDINAL)) {
    PAL_ORDINAL[[as.character(k)]]
  } else {
    PAL_NOMINAL[seq_len(k)]
  }
}

# Colores de una escala ordenada de negativo a positivo
colores_escala <- function(niveles, n_neg, neutral = NULL) {
  n_pos <- length(niveles) - n_neg - length(neutral)
  neg <- if (n_neg == 1) DIV_NEG2[1] else DIV_NEG2[seq_len(n_neg)]
  pos <- if (n_pos == 1) DIV_POS2[2] else DIV_POS2[seq_len(n_pos)]
  setNames(c(neg, if (!is.null(neutral)) DIV_NEUTR, pos), niveles)
}

# Texto legible sobre cada color de relleno
color_texto <- function(fill) {
  ifelse(fill %in% c(DIV_NEG2[2], DIV_NEUTR, DIV_POS2[1], "#b89ad8", GRIS_NSNR), "#271743", "#ffffff")
}

# Formato es-CL -----------------------------------------------------------------
num <- function(x, d = 1) format(round(x, d), nsmall = d, decimal.mark = ",", big.mark = ".")
pct <- function(x, d = 1) paste0(num(x, d), "%")

fmt_p <- function(p) {
  if (is.na(p)) return(NA_character_)
  if (p < 0.001) "p < 0,001" else paste0("p = ", num(p, 3))
}

# Estimaciones ------------------------------------------------------------------

#' Porcentajes ponderados de `var`, total o por grupo.
#' "No aplica" sale de la base; NS/NR se mantiene en el denominador.
tab_pct <- function(var, by = NULL, data = ebd) {
  d <- data |>
    filter(!is.na(.data[[var]]), as.character(.data[[var]]) != "No aplica")
  if (is.null(by)) {
    d$grupo <- "Total"
  } else {
    d <- d |> filter(!is.na(.data[[by]]))
    d$grupo <- as.character(d[[by]])
  }
  niveles_grupo <- if (is.null(by)) "Total" else levels(droplevels(d[[by]]))
  d |>
    mutate(cat = fct_drop(.data[[var]]) |> fct_drop(only = "No aplica")) |>
    group_by(grupo, cat, .drop = FALSE) |>
    summarise(w = sum(pond), n = n(), .groups = "drop") |>
    group_by(grupo) |>
    mutate(pct = 100 * w / sum(w), base = sum(n)) |>
    ungroup() |>
    mutate(grupo = factor(grupo, levels = niveles_grupo))
}

#' Total + grupos de un cruce, con "Total" como primera fila
tab_pct_cruce <- function(var, by) {
  bind_rows(tab_pct(var), tab_pct(var, by)) |>
    mutate(grupo = factor(as.character(grupo),
                          levels = c("Total", levels(droplevels(ebd[[by]])))))
}

#' Prueba de independencia Rao-Scott (excluye NS/NR y No aplica)
p_cruce <- function(var, by) {
  # Se rehace el diseño sobre la submuestra para eliminar niveles vacíos
  # (un nivel sin casos deja la tabla con ceros y el estadístico en NaN)
  d <- ebd |>
    filter(!is.na(.data[[var]]), !as.character(.data[[var]]) %in% c("NS/NR", "No aplica"),
           !is.na(.data[[by]])) |>
    transmute(v = droplevels(factor(.data[[var]], ordered = FALSE)),
              g = droplevels(factor(.data[[by]], ordered = FALSE)), pond)
  sub <- svydesign(ids = ~1, weights = ~pond, data = d)
  tryCatch(
    suppressWarnings(svychisq(~ v + g, sub, statistic = "F")$p.value[[1]]),
    error = function(e) NA_real_
  )
}

#' Porcentaje (con NS/NR en la base) de las categorías `cats`
pct_de <- function(var, cats, by = NULL) {
  tab_pct(var, by) |>
    group_by(grupo) |>
    summarise(pct = sum(pct[cat %in% cats]), .groups = "drop")
}

#' Promedio ponderado de una escala numérica guardada como factor ("1".."10")
media_escala <- function(var, by = NULL) {
  d <- ebd |>
    filter(!is.na(.data[[var]]), as.character(.data[[var]]) != "NS/NR") |>
    mutate(x = as.numeric(as.character(.data[[var]])))
  if (is.null(by)) d$grupo <- "Total" else d$grupo <- as.character(d[[by]])
  d |>
    group_by(grupo) |>
    summarise(media = weighted.mean(x, pond), n = n(), .groups = "drop")
}

# Gráficos echarts ---------------------------------------------------------------

# Entre comillas: un nombre de familia que contiene un número ("3") sin
# comillas invalida la declaración de fuente del canvas y echarts cae a 10px
FUENTE <- "'Asap', system-ui, sans-serif"

js_pct <- "function(v){return (Math.round(v*10)/10).toFixed(1).replace('.', ',');}"

tooltip_base <- list(
  backgroundColor = "#ffffff", borderColor = "#d9d3e4", borderWidth = 1,
  padding = c(8, 12), textStyle = list(color = "#271743", fontFamily = FUENTE, fontSize = 13),
  extraCssText = "box-shadow:0 6px 18px rgba(39,23,67,.16);border-radius:2px;border-top:3px solid #d12c88;"
)

opt_base <- function() {
  list(
    textStyle = list(fontFamily = FUENTE, color = "#2e2840"),
    animationDuration = 500
  )
}

eje_categorias <- function(cats, ancho = 34) {
  list(
    type = "category", data = as.list(str_wrap(cats, ancho)), inverse = TRUE,
    axisTick = list(show = FALSE),
    axisLine = list(show = FALSE),
    axisLabel = list(color = "#271743", fontSize = 14, lineHeight = 17, margin = 12, interval = 0)
  )
}

eje_valor_oculto <- function(max = NULL) {
  c(list(type = "value", show = FALSE), if (!is.null(max)) list(max = max))
}

eje_pct_visible <- function() {
  list(
    type = "value", max = 100,
    axisLabel = list(formatter = "{value}%", color = "#6e6680"),
    splitLine = list(lineStyle = list(color = "#ece8f2"))
  )
}

# Celular -------------------------------------------------------------------
# En contenedores angostos el nombre de cada categoría va SOBRE su barra
# (la barra usa todo el ancho) y la leyenda se envuelve completa. Se usa el
# mecanismo `media` de echarts; el alto del contenedor lo ajusta js/tabs.html
# leyendo data-alto / data-alto-movil.
ANCHO_MOVIL <- 560

eje_movil <- function(cats, pad) {
  list(
    data = as.list(cats),
    axisLabel = list(
      inside = TRUE, verticalAlign = "bottom", align = "left",
      padding = c(0, 0, pad, 0), margin = 0,
      fontSize = 12.5, lineHeight = 15, width = 300, overflow = "truncate"
    )
  )
}

# Alto aproximado de una leyenda envuelta en ~330 px de ancho
alto_leyenda <- function(nombres, ancho = 330) {
  w <- 12 + 5 + nchar(nombres) * 6.6 + 12
  lineas <- 1; usado <- 0
  for (x in w) {
    if (usado + x > ancho && usado > 0) { lineas <- lineas + 1; usado <- 0 }
    usado <- usado + x
  }
  lineas * 19 + 6
}

ec <- function(opt, alto, movil = NULL, alto_movil = NULL) {
  o <- if (is.null(movil)) opt else
    list(baseOption = opt,
         media = list(list(query = list(maxWidth = ANCHO_MOVIL), option = movil)))
  w <- e_charts(width = "100%", height = alto) |> e_list(o)
  if (is.null(alto_movil)) return(w)
  div(class = "ec-wrap", `data-alto` = alto, `data-alto-movil` = round(alto_movil), w)
}

#' Barras horizontales, una serie (panel Total)
graf_barras <- function(t, colores = NULL, orden = c("frecuencia", "escala", "fijo")) {
  orden <- match.arg(orden)
  t <- t |> filter(pct > 0 | cat != "NS/NR")
  if (orden == "frecuencia") {
    t <- t |>
      mutate(es_ns = cat %in% c("NS/NR", "Otros", "Otros/NS/NR", "Otras/NS/NR", "Otro")) |>
      arrange(es_ns, desc(pct))
  } else if (orden == "escala") {
    # Escala: polo positivo arriba, NS/NR al final
    t <- t |> mutate(es_ns = cat == "NS/NR") |> arrange(es_ns, desc(as.integer(cat)))
  } else {
    t <- t |> mutate(es_ns = cat == "NS/NR") |> arrange(es_ns, cat)
  }
  cats <- as.character(t$cat)
  fill <- if (is.null(colores)) rep(AZUL, length(cats)) else unname(colores[cats])
  fill[is.na(fill)] <- AZUL
  fill[cats == "NS/NR"] <- GRIS_NSNR
  datos <- pmap(list(t$pct, t$n, fill), function(v, n, f) {
    list(value = round(v, 2), n = n, itemStyle = list(color = f))
  })
  opt <- c(opt_base(), list(
    grid = list(left = 8, right = 64, top = 6, bottom = 6, containLabel = TRUE),
    xAxis = eje_valor_oculto(),
    yAxis = eje_categorias(cats),
    tooltip = c(tooltip_base, list(
      trigger = "item",
      formatter = htmlwidgets::JS(paste0(
        "function(p){var f=", js_pct, ";return '<b>'+p.name.replace(/\\n/g,' ')+'</b><br>'+f(p.value)+",
        "'% <span style=\"color:#6e6680\">· n = '+p.data.n+'</span>';}"
      ))
    )),
    series = list(list(
      type = "bar", data = datos, barMaxWidth = 22, barCategoryGap = "28%",
      itemStyle = list(borderRadius = c(0, 4, 4, 0)),
      label = list(
        show = TRUE, position = "right", color = "#271743", fontWeight = "bold",
        fontSize = 13,
        formatter = htmlwidgets::JS(paste0("function(p){var f=", js_pct, ";return f(p.value)+'%';}"))
      ),
      emphasis = list(itemStyle = list(opacity = 0.85))
    ))
  ))
  # Alto por fila según las líneas de su etiqueta (etiquetas de 3 líneas
  # se encimaban con un alto fijo de 32 px)
  lineas <- str_count(str_wrap(cats, 34), "\n") + 1
  alto <- 14 + sum(pmax(32, 19 * lineas + 16))
  movil <- list(
    grid = list(left = 0, right = 52, top = 4, bottom = 4, containLabel = FALSE),
    yAxis = eje_movil(cats, pad = 11),
    series = list(list(barMaxWidth = 14))
  )
  ec(opt, max(alto, 100), movil, 10 + 46 * length(cats))
}

#' Columnas verticales para escalas numéricas (1–7, 1–10)
graf_columnas <- function(t, colores) {
  t <- t |> arrange(cat)
  cats <- as.character(t$cat)
  fill <- unname(colores[cats]); fill[cats == "NS/NR"] <- GRIS_NSNR
  datos <- pmap(list(t$pct, t$n, fill), function(v, n, f) {
    list(value = round(v, 2), n = n, itemStyle = list(color = f))
  })
  opt <- c(opt_base(), list(
    grid = list(left = 8, right = 8, top = 28, bottom = 8, containLabel = TRUE),
    xAxis = list(type = "category", data = as.list(cats), axisTick = list(show = FALSE),
                 axisLine = list(lineStyle = list(color = "#d9d3e4")),
                 axisLabel = list(color = "#271743", fontSize = 13)),
    yAxis = list(type = "value", show = FALSE),
    tooltip = c(tooltip_base, list(
      trigger = "item",
      formatter = htmlwidgets::JS(paste0(
        "function(p){var f=", js_pct, ";return '<b>'+p.name+'</b><br>'+f(p.value)+",
        "'% <span style=\"color:#6e6680\">· n = '+p.data.n+'</span>';}"
      ))
    )),
    series = list(list(
      type = "bar", data = datos, barMaxWidth = 46,
      itemStyle = list(borderRadius = c(4, 4, 0, 0)),
      label = list(
        show = TRUE, position = "top", color = "#271743", fontWeight = "bold", fontSize = 13,
        formatter = htmlwidgets::JS(paste0("function(p){var f=", js_pct, ";return f(p.value);}"))
      )
    ))
  ))
  ec(opt, 300)
}

#' Barras apiladas al 100% (una barra por fila). NS/NR fuera del gráfico,
#' dentro del denominador (convención del proyecto).
#' `t` necesita columnas: fila, cat, pct, n
graf_apilado <- function(t, niveles, colores, ancho_eje = 30, leyenda = TRUE) {
  filas <- levels(t$fila)
  series <- map(niveles, function(nv) {
    sub <- t |> filter(cat == nv)
    vals <- map(filas, function(f) {
      r <- sub |> filter(fila == f)
      if (nrow(r) == 0) list(value = 0, n = 0) else list(value = round(r$pct, 2), n = r$n)
    })
    list(
      name = nv, type = "bar", stack = "total", data = vals, barMaxWidth = 26,
      itemStyle = list(color = unname(colores[nv]), borderColor = "#ffffff", borderWidth = 2),
      label = list(
        show = TRUE, position = "inside", color = color_texto(unname(colores[nv])),
        fontWeight = "bold", fontSize = 12,
        formatter = htmlwidgets::JS(paste0(
          "function(p){var f=", js_pct, ";return p.value>=3?f(p.value):'';}"
        ))
      ),
      # La etiqueta solo se muestra si cabe dentro del segmento (en móvil
      # los segmentos son angostos y las cifras chocaban entre sí)
      labelLayout = htmlwidgets::JS(
        "function(p){return (p.labelRect.width + 6 > p.rect.width) ? {fontSize: 0.01} : {hideOverlap: true};}"
      ),
      emphasis = list(focus = "series")
    )
  })
  opt <- c(opt_base(), list(
    legend = if (leyenda) list(
      top = 0, left = 0, itemWidth = 12, itemHeight = 12, icon = "roundRect",
      textStyle = list(fontSize = 12.5, color = "#2e2840")
    ) else list(show = FALSE),
    grid = list(left = 8, right = 16, top = if (leyenda) 40 else 6, bottom = 6, containLabel = TRUE),
    xAxis = eje_valor_oculto(100),
    yAxis = eje_categorias(filas, ancho_eje),
    tooltip = c(tooltip_base, list(
      trigger = "item",
      formatter = htmlwidgets::JS(paste0(
        "function(p){var f=", js_pct, ";return '<b>'+p.name.replace(/\\n/g,' ')+'</b><br>'+",
        "p.marker+p.seriesName+': <b>'+f(p.value)+'%</b>';}"
      ))
    )),
    series = series
  ))
  n_lineas <- sum(str_count(str_wrap(filas, ancho_eje), "\n"))
  alto <- (if (leyenda) 50 else 14) + 40 * length(filas) + 10 * n_lineas
  h_ley <- if (leyenda) alto_leyenda(niveles) else 0
  movil <- list(
    legend = list(type = "plain"),
    grid = list(left = 0, right = 2, top = h_ley + 22, bottom = 4, containLabel = FALSE),
    yAxis = eje_movil(filas, pad = 14),
    series = map(niveles, ~ list(barMaxWidth = 18))
  )
  ec(opt, alto, movil, h_ley + 26 + 50 * length(filas))
}

#' Barras horizontales agrupadas: una serie por grupo del cruce
graf_agrupado <- function(t, filas, grupos, colores, sufijo = "%", max = NULL, decimales = 1,
                          colores_fila = NULL) {
  js_num <- if (decimales == 1) js_pct else
    "function(v){return v.toFixed(2).replace('.', ',');}"
  una_serie <- length(grupos) == 1
  series <- map2(grupos, colores, function(g, col) {
    sub <- t |> filter(grupo == g)
    vals <- map(filas, function(f) {
      r <- sub |> filter(fila == f)
      if (nrow(r) == 0) list(value = 0, n = 0) else list(value = round(r$valor, 2), n = r$n)
    })
    if (!is.null(colores_fila)) {
      vals <- map2(vals, colores_fila, function(v, cf) c(v, list(itemStyle = list(color = cf))))
    }
    list(
      name = g, type = "bar", data = vals,
      barMaxWidth = if (una_serie) 20 else 14, barGap = "15%",
      itemStyle = list(color = col, borderRadius = c(0, 3, 3, 0)),
      label = list(
        show = TRUE, position = "right", fontSize = if (una_serie) 13 else 11,
        fontWeight = if (una_serie) "bold" else "normal",
        color = if (una_serie) "#271743" else "#4d4560", distance = 4,
        formatter = htmlwidgets::JS(paste0("function(p){var f=", js_num, ";return f(p.value);}"))
      ),
      emphasis = list(focus = "series")
    )
  })
  opt <- c(opt_base(), list(
    legend = if (una_serie) list(show = FALSE) else
      list(top = 0, left = 0, itemWidth = 12, itemHeight = 12, icon = "roundRect",
           textStyle = list(fontSize = 12.5, color = "#2e2840")),
    grid = list(left = 8, right = 40, top = if (una_serie) 8 else 36, bottom = 8, containLabel = TRUE),
    xAxis = c(list(
      type = "value",
      axisLabel = list(formatter = paste0("{value}", sufijo), color = "#6e6680"),
      splitLine = list(lineStyle = list(color = "#ece8f2"))
    ), if (!is.null(max)) list(max = max)),
    yAxis = eje_categorias(filas),
    tooltip = c(tooltip_base, list(
      trigger = "axis", axisPointer = list(type = "shadow", shadowStyle = list(color = "rgba(108,74,158,.07)")),
      formatter = htmlwidgets::JS(paste0(
        "function(ps){var f=", js_num, ";var s='<b>'+ps[0].name.replace(/\\n/g,' ')+'</b>';",
        "ps.forEach(function(p){s+='<br>'+p.marker+p.seriesName+': <b>'+f(p.value)+'", sufijo,
        "</b> <span style=\"color:#6e6680\">· n = '+p.data.n+'</span>';});return s;}"
      ))
    )),
    series = series
  ))
  n_lineas <- sum(str_count(str_wrap(filas, 34), "\n"))
  alto <- 48 + length(filas) * (length(grupos) * 13 + 22) + 6 * n_lineas
  k <- length(grupos)
  h_ley <- if (una_serie) 0 else alto_leyenda(grupos)
  movil <- list(
    grid = list(left = 0, right = 40, top = if (una_serie) 22 else h_ley + 20,
                bottom = 26, containLabel = FALSE),
    yAxis = eje_movil(filas, pad = round(k * 6.5 + 6)),
    series = map(grupos, ~ list(barMaxWidth = 12))
  )
  ec(opt, max(alto, 160), movil, h_ley + 52 + length(filas) * (k * 13 + 40))
}

# Bloques de pregunta ------------------------------------------------------------

#' Contenedor con pestañas (Total / Sexo / Edad / GSE / Territorio)
bloque_tabs <- function(id, paneles, texto = NULL) {
  botones <- imap(paneles, function(pn, i) {
    tags$button(
      class = paste("q-tab", if (i == 1) "activo"), type = "button", role = "tab",
      `aria-selected` = if (i == 1) "true" else "false",
      `data-panel` = paste0(id, "-", i), pn$titulo
    )
  })
  cuerpos <- imap(paneles, function(pn, i) {
    div(
      class = paste("q-panel", if (i == 1) "activo"), id = paste0(id, "-", i), role = "tabpanel",
      if (!is.null(pn$nota)) tags$p(class = "q-nota", HTML(pn$nota)),
      pn$grafico,
      div(class = "q-pie", HTML(pn$pie))
    )
  })
  div(
    class = "q-bloque", id = paste0("q-", id),
    if (!is.null(texto)) tags$p(class = "q-texto", tags$b("P:"), " ", texto),
    if (length(paneles) > 1) div(class = "q-tabs", role = "tablist", `aria-label` = "Desagregación", botones),
    div(class = "q-paneles", cuerpos),
    tags$p(class = "q-fuente", "Fuente: UER-UMAG, Encuesta Bienestar y Desarrollo Magallanes 2025.")
  )
}

pie_base <- function(base, extra = NULL) {
  paste0(
    "<span>Respuestas: <b>", num(base, 0), "</b></span>",
    if (!is.null(extra)) paste0("<span>", extra, "</span>")
  )
}

pie_prueba <- function(var, by) {
  p <- p_cruce(var, by)
  if (is.na(p)) return(NULL)
  sig <- p < 0.05
  paste0(
    "<span class='q-sig ", if (sig) "si" else "no", "'>",
    if (sig) "Diferencia significativa" else "Sin diferencia significativa",
    " (Rao-Scott, ", fmt_p(p), ")</span>"
  )
}

#' Pregunta de respuesta única.
#' tipo: "nominal" (barras ordenadas por frecuencia), "escala" (orden de
#' niveles, colores divergentes), "numerica" (columnas 1..k + promedio)
bloque <- function(var, texto = NULL, tipo = c("nominal", "escala", "numerica"),
                   n_neg = NULL, neutral = NULL, cruzar = names(cruces),
                   top = NULL, orden_fijo = FALSE) {
  tipo <- match.arg(tipo)
  t0 <- tab_pct(var)
  base <- sum(t0$n)
  ns <- t0 |> filter(cat == "NS/NR") |> pull(pct)
  extra_ns <- if (length(ns) && ns > 0) paste0("NS/NR: ", pct(ns)) else NULL
  niveles <- setdiff(levels(t0$cat), c("NS/NR", "No aplica"))

  colores <- switch(tipo,
    nominal  = NULL,
    numerica = setNames(rep(AZUL, length(niveles)), niveles),
    escala   = colores_escala(niveles, n_neg, neutral)
  )

  # Panel Total
  if (tipo == "numerica") {
    m <- media_escala(var)
    g_total <- graf_columnas(t0, colores)
    pie_total <- pie_base(base, paste0("Promedio: <b>", num(m$media, 1), "</b>"))
  } else {
    g_total <- graf_barras(t0, colores,
                           if (tipo == "escala") "escala" else if (orden_fijo) "fijo" else "frecuencia")
    pie_total <- pie_base(base, extra_ns)
  }
  paneles <- list(list(titulo = "Total", grafico = g_total, pie = pie_total))

  # Paneles por cruce
  for (by in cruzar) {
    grupos <- levels(droplevels(ebd[[by]]))
    if (tipo == "escala") {
      t <- tab_pct_cruce(var, by) |> rename(fila = grupo)
      g <- graf_apilado(t, niveles, colores)
      nota <- NULL
    } else if (tipo == "numerica") {
      m <- bind_rows(media_escala(var), media_escala(var, by)) |>
        mutate(fila = grupo, valor = media)
      k <- length(niveles)
      g <- graf_agrupado(
        m |> mutate(grupo = "Promedio"), c("Total", grupos), "Promedio", AZUL,
        sufijo = "", max = k, decimales = 1,
        colores_fila = c(VIOLETA, colores_grupo(by, grupos))
      )
      nota <- paste0("Promedio en la escala 1–", k, ", excluye NS/NR.")
    } else {
      orden <- t0 |>
        filter(!cat %in% c("NS/NR")) |>
        arrange(desc(pct))
      if (orden_fijo) orden <- orden |> arrange(cat)
      if (!is.null(top)) orden <- orden |> slice_head(n = top)
      filas <- as.character(orden$cat)
      t <- tab_pct(var, by) |>
        filter(cat %in% filas) |>
        mutate(fila = as.character(cat), valor = pct, grupo = as.character(grupo))
      g <- graf_agrupado(t, filas, grupos, colores_grupo(by, grupos))
      nota <- if (!is.null(top)) paste0("Se muestran las ", top, " respuestas más frecuentes.") else NULL
    }
    paneles[[length(paneles) + 1]] <- list(
      titulo = cruces[[by]], grafico = g, nota = nota,
      pie = pie_base(base, pie_prueba(var, by))
    )
  }
  bloque_tabs(var, paneles, texto)
}

#' Batería de ítems con la misma escala.
#' Panel Total: barras apiladas por ítem, ordenadas por % favorable.
#' Paneles por cruce: % favorable (categorías `favorables`) por grupo.
bloque_bateria <- function(id, items, n_neg, neutral = NULL, favorables,
                           etiqueta_fav, texto = NULL, cruzar = names(cruces)) {
  vars <- names(items)
  # cat a texto: los ítems pueden diferir en niveles (p. ej. sin NS/NR)
  t_all <- map_dfr(vars, function(v) tab_pct(v) |> mutate(cat = as.character(cat), item = v))
  niveles <- setdiff(levels(ebd[[vars[1]]]), c("NS/NR", "No aplica"))
  colores <- colores_escala(niveles, n_neg, neutral)

  fav <- t_all |>
    group_by(item) |>
    summarise(fav = sum(pct[cat %in% favorables]), base = sum(n), .groups = "drop") |>
    arrange(desc(fav))
  orden_items <- unname(items[fav$item])

  t <- t_all |>
    mutate(fila = factor(unname(items[item]), levels = orden_items))
  g_total <- graf_apilado(t, niveles, colores, ancho_eje = 34)
  bases <- range(fav$base)
  base_txt <- if (bases[1] == bases[2]) num(bases[1], 0) else
    paste0(num(bases[1], 0), "–", num(bases[2], 0))
  pie_total <- paste0(
    "<span>Respuestas por ítem: <b>", base_txt, "</b></span>",
    "<span>Ítems ordenados por ", tolower(etiqueta_fav), "</span>"
  )
  paneles <- list(list(titulo = "Total", grafico = g_total, pie = pie_total))

  for (by in cruzar) {
    grupos <- levels(droplevels(ebd[[by]]))
    tg <- map_dfr(vars, function(v) {
      tab_pct(v, by) |>
        group_by(grupo) |>
        summarise(valor = sum(pct[cat %in% favorables]), n = sum(n), .groups = "drop") |>
        mutate(fila = unname(items[v]), grupo = as.character(grupo))
    })
    n_sig <- sum(map_dbl(vars, ~ p_cruce(.x, by)) < 0.05, na.rm = TRUE)
    g <- graf_agrupado(tg, orden_items, grupos, colores_grupo(by, grupos), max = 100)
    paneles[[length(paneles) + 1]] <- list(
      titulo = cruces[[by]], grafico = g,
      nota = paste0("Porcentaje que responde <b>", etiqueta_fav, "</b>."),
      pie = paste0(
        "<span>Respuestas por ítem: <b>", base_txt, "</b></span>",
        "<span class='q-sig ", if (n_sig > 0) "si" else "no", "'>",
        n_sig, " de ", length(vars), " ítems con diferencia significativa (Rao-Scott, p < 0,05)</span>"
      )
    )
  }
  bloque_tabs(id, paneles, texto)
}

# Cifras para el texto ------------------------------------------------------------

#' % ponderado de categorías (NS/NR en la base), formateado
P <- function(var, cats, by = NULL, grupo = NULL) {
  r <- pct_de(var, cats, by)
  if (!is.null(grupo)) r <- r |> filter(grupo == !!grupo)
  pct(r$pct[1])
}

