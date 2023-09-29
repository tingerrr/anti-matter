#import "/src/lib.typ": anti-matter, anti-front-end, anti-inner-end

#set page("a4", height: auto)
#show heading.where(level: 1): it => pagebreak(weak: true) + it

// add a title page and reset the counter
#[
  #set page(numbering: none)
  #counter(page).update(0)
]

#show: anti-matter

#include "front-matter.typ"
#anti-front-end()

#include "chapters.typ"
#anti-inner-end()

#include "back-matter.typ"
