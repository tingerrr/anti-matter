#import "template.typ": project
#let version = toml("/typst.toml").package.version

#show: project.with(
    title: "anti-matter",
    authors: ("tinger",),
    version: version,
    url: "https://github.com/tingerrr/typst-anti-matter",
    date: datetime.today().display(),
    abstract: [
        This packages allows you to simply mark the end and start of your front matter and back
        matter respectively to change style and value of your page number without manually setting
        and keeping track of inner and outer page counters. Books and theses often number front and
        back matter in a different style than the actual content.
    ]
)

#let codeblocks(body) = {
    show raw.where(block: true): set block(
        width: 100%,
        fill: gray.lighten(50%),
        radius: 5pt,
        inset: 5pt
    )

    show "{{version}}": version

    body
}

#show heading.where(level: 1): it => pagebreak(weak: true) + it

#show outline: set heading(outlined: true)
#outline(indent: auto, depth: 1)

= Introduction
#[
    A document like this:
    #show: codeblocks
    #raw(
        block: true,
        lang: "typst",
        read("example/main.typ").replace(regex("/src/lib.typ"), "@preview/anti-matter:{{version}}")
    )

    Would generate an outline like this:
    #block(fill: gray.lighten(50%), radius: 5pt, inset: 5pt, image("/assets/example.png"))

    The front matter (in this case the outlines) are numbered using `"I"`, the content starts new at
    `"1"` and the back matter (glossary, acknowledgement, etc) are numbered `"I"` again, continuing
    from where the front matter left off.
]

= How it works & caveats
#[
    #show: codeblocks

    `anti-matter` keeps track of it's own inner and outer counter, which are updated in the header
    of a page. Numbering at a given location is resolved by inspecting where this location is
    between the given markers and applying a spec to it. This means that setting a custom page
    header or changing `outline.entry` with a `show` rule can break your setup.

    == The specification
    Most `anti-matter` functions require a `spec`, which is a dictionary detailing how numbering
    across the document should be done. It is a dictionary with three requried keys, `front`,
    `inner`, and `back`. Valid numberings are the same as parameters to various `numbering`
    parameters, as well as `none` to display nothing.
    ```typst
    #let spec = (
        front: "I",
        inner: none,
        back: (..args) => numbering("I", ..args) + [ --- ]
    )
    ```

    The default `spec` is `anti-thesis`, which is equal to:
    ```typst
    #let spec = (front: "I", inner: "1", back: "I")
    ```

    == The markers
    The markers `anti-front-end` and `anti-inner-end` must be placed on the last page of their
    respective matter, a leading `pagebreak` before a marker will result in an incorrect marker
    position. While the marker and numbering location could be compared relative to their page too,
    this would fail to work for page numbering in the header as it would logically infront of the
    marker.

    == Customizing your page header
    The convenience function `anti-header` is provided for this:
    ```typst
    #import "@preview/anti-matter:{{version}}": anti-matter, anti-header //, ...
    #let spec = anti-thesis()
    #show: anti-matter.with(spec: spec)

    // render your own header while retaining the correct counter updates
    #set page(header: anti-header(spec)[...])

    // ...
    ```

    == Customizing your outline entries
    Similarily, when a page should displayed with `anti-matter` styling, `anti-page-at` is used.
    This can be used to customize `outline.entry` and other elements which display the page of a
    query (like):
    ```typst
    #import "@preview/anti-matter:{{version}}": anti-matter, anti-page-at //, ...
    #let spec = anti-thesis()
    #show: anti-matter.with(spec: spec)

    // render your own outline style while retaining the correct page numbering for queried elements
    #show outline.entry: it => {
        it.body
        box(width: 1fr, it.fill)
        anti-page-at(spec, it.element.location())
    }

    // ...
    ```

    In general the prevously mentioned `show` and `set` rules are the only thing to consider when
    customizing your document whiel using `anti-matter`. The `anti-matter` template function simply
    passes the spec passed to those functions and applies these rules for convenience. Setting the
    `spec` may become more convenient in the future with support for
    #link("https://github.com/typst/typst/issues/147")[custom elements].
]

= API-Reference
#{
    import "@preview/tidy:0.1.0"
    let module = tidy.parse-module(read("/src/lib.typ"))
    tidy.show-module(module, style: tidy.styles.default)
}

#set heading(numbering: none)

= Future work
The aim of this package is to be obsolete for a more powerful counter system in typst. Unfortunately
this seems far away currently. In the mean time this should do for the most common case of
alternating page numbering. Bug reports are appreciated, this package was only tested with 2
documents.
