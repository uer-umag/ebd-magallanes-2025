# PRODUCT — Sitio de difusión EBD Magallanes 2025

## Producto

Sitio web estático con los resultados de la Encuesta de Bienestar y Desarrollo
Magallanes 2025 (EBD), publicado por la Unidad de Estudios Regionales de la
Universidad de Magallanes (UER-UMAG). Presenta cada pregunta del cuestionario
con su gráfico interactivo, desagregado por sexo, edad, grupo socioeconómico y
territorio, más un comentario breve.

## Lector principal

Público general y prensa: ciudadanía, periodistas y autoridades regionales que
llegan desde redes sociales o notas de prensa y leen mayoritariamente en el
celular. Necesitan entender una cifra y su contexto en segundos y poder citarla.

## Hechos que el trabajo futuro debe preservar

- Datos: 655 entrevistas, ponderador `pond` (sexo, edad, conglomerado);
  terreno 4–26 de noviembre de 2025; error ±3,8 pp (MAS, 95%).
- Porcentajes con 1 decimal, coma decimal y punto de miles (es-CL).
- NS/NR en el denominador; «No aplica» fuera de la base.
- Diferencias entre grupos informadas con prueba Rao-Scott (p < 0,05).
- Fuente obligatoria: «UER-UMAG, Encuesta Bienestar y Desarrollo Magallanes 2025».

## Marca

Identidad editorial del Boletín de Estudios Regionales UER-UMAG (N°1, junio
2025), confirmada por el usuario como referencia visual del sitio. Logos UER en
`img/`. Las fotografías provienen de los Boletines N°1 y N°2 de la UER.

## Plataforma

`web` — Quarto website + R (`echarts4r`); salida estática en `_site/`.
