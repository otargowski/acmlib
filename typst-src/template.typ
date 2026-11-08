#import "config.typ": *

// Chapter counter
#let chap-counter = counter("chapter")

#let team-page() = {
  set page(header: none, footer: none, margin: (x: 2cm, y: 1.5cm))
  set align(center)
  
  v(1.5cm)
  if university-logo != none {
    image(university-logo, width: 3.5cm)
    v(0.8cm)
  }
  text(size: 26pt)[#university-name]
  v(0.8cm)
  text(size: 38pt, weight: "bold")[#team-name]
  v(0.8cm)
  text(size: 18pt)[#team-members]
  
  v(1fr)
  text(size: 24pt, weight: "bold")[#contest-name]
  v(0.4cm)
  text(size: 16pt)[#contest-date]
  v(1cm)
  pagebreak()
}

#let layout(doc) = {
  set page(
    paper: "a4",
    flipped: true,
    margin: page-margin,
    header-ascent: 2mm,
    header: context {
      let page-num = here().page()
      if page-num == 1 {
        return none
      }
      
      // Running header: find entries on this page
      let page-items = query(selector(label("header-item"))).filter(it => it.location().page() == page-num)
      let titles = ""
      if page-items.len() > 0 {
        titles = page-items.map(it => it.value).join(" ")
      } else {
        let before-items = query(selector(label("header-item"))).filter(it => it.location().page() < page-num)
        if before-items.len() > 0 {
          titles = before-items.last().value
        }
      }
      
      set text(size: 7pt, font: font-family)
      grid(
        columns: (auto, 1fr, auto),
        align: (left + bottom, center + bottom, right + bottom),
        [#text(weight: "bold")[#university-short]],
        [#text(size: 7pt, weight: "bold")[#titles]],
        [#counter(page).display("1")]
      )
      v(-2pt)
      line(length: 100%, stroke: 0.3pt + luma(180))
    }
  )

  set text(size: base-font-size, font: font-family)
  set par(justify: true, leading: par-leading)
  show raw: set text(font: code-font-family, size: code-font-size)

  // Configure headings
  show heading.where(level: 1): it => {
    v(space-above-chapter)
    block(
      width: 100%,
      stroke: (bottom: 0.7pt + black),
      inset: (bottom: 1.5pt),
      [
        #text(size: 1.35em, weight: "bold")[#it.body]
        #h(4pt)
        #context {
          text(size: 1.15em, weight: "bold")[(#chap-counter.display())]
        }
      ]
    )
    v(space-below-chapter)
  }

  show heading.where(level: 2): it => {
    v(space-above-entry)
    text(size: 1.1em, weight: "bold")[#it.body]
    v(space-below-title)
  }

  show heading.where(level: 3): it => {
    v(space-above-entry * 0.7)
    text(size: 1.0em, weight: "bold")[#it.body]
    v(space-below-title * 0.7)
  }

  doc
}

#let my-chapter(title) = {
  chap-counter.step()
  heading(level: 1, numbering: none)[#title]
}

#let section-header(title) = {
  heading(level: 2, numbering: none)[#title]
}

#let subsection-header(title) = {
  heading(level: 3, numbering: none)[#title]
}

#let code-entry(
  name: "",
  hash: none,
  includes: (),
  opis: none,
  lang: "cpp",
  code: ""
) = {
  // Add metadata for running header
  [#metadata(name) <header-item>]
  
  // Title & hash block
  v(space-above-entry)
  text(size: 1.05em, font: code-font-family, weight: "bold")[#name]
  if hash != none [
    #h(3pt)
    #text(size: 0.9em, fill: rgb("#007000"), font: code-font-family)[\##hash]
  ]
  if includes.len() > 0 [
    #h(2pt)
    #text(size: 0.82em, fill: luma(80))[, includes: #text(font: code-font-family)[#includes.join(", ")]]
  ]
  
  if opis != none and opis != "" [
    #v(1pt)
    #text(size: 0.92em)[#opis]
  ]
  
  v(space-below-title)
  raw(code, lang: lang, block: true)
  v(space-below-entry)
}
