#import "@preview/anti-matter:0.0.1": anti-matter, anti-front-end, anti-back-start

#set page("a4", height: auto)
#show heading.where(level: 1): it => pagebreak(weak: true) + it

// add a title page and reset the counter
#[
  #set page(numbering: none)
  #counter(page).update(0)
]

#show: anti-matter

#include "front-matter.typ"
#anti-front-end

#include "chapters.typ"

#anti-back-start
#include "back-matter.typ"
