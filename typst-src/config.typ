// Configuration parameters for ACM Library Typst Layout
// Adjust these parameters to compress or expand the document to fit within target page limits (e.g. 26 pages)

#let base-font-size = 7.0pt
#let code-font-size = 6.0pt
#let font-family = ("Ubuntu", "DejaVu Sans", "Liberation Sans")
#let code-font-family = ("Ubuntu Mono", "DejaVu Sans Mono", "Liberation Mono")

// Multi-column parameters
#let col-count = 4
#let col-gutter = 8pt

// Page margins
#let page-margin = (
  x: 4mm,
  top: 9mm,
  bottom: 4mm
)

// Spacings between elements
#let space-above-chapter = 4pt
#let space-below-chapter = 2.5pt
#let space-above-entry = 3pt
#let space-below-title = 1.5pt
#let space-below-entry = 2.5pt

// Paragraph leading (line height)
#let par-leading = 0.42em

// Cover page settings
#let university-logo = "uw.png"
#let university-name = "University of Warsaw"
#let university-short = "University of Warsaw, UW1"
#let team-name = "UW1"
#let team-members = "Waldemar Lamandini, Olaf Targowski, Jakub Koliński"
#let contest-name = "AMPPZ 2025"
#let contest-date = "2025-11-13"
