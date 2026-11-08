#import "config.typ": *
#import "template.typ": team-page, layout

#team-page()

#show: doc => layout(doc)

#columns(col-count, gutter: col-gutter)[
  #outline(
    title: "Spis treści",
    depth: 1,
    indent: auto
  )

  #include "content.typ"
]
