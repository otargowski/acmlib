# Typst Machinery for ACM Library

This directory contains the Typst reimplementation of the ACM library documentation pipeline, replacing LuaLaTeX/kactlpkg.

## Files

- `config.typ`: Configuration file defining typography, margins, columns, spacings, and contest metadata.
- `template.typ`: Typst layout functions, custom headers, page setup, table of contents, and entry formatting.
- `wzorki.typ`: Formatted math cheatsheet and formulas translated from `code/math/useful.tex`.
- `build_typst.py`: Python generator that parses C++, raw configs, headers, doc comments, computes KACTL-compatible 6-character hashes via `pdf/kactl-include/hash.sh`, converts LaTeX math descriptions into Typst math format, and produces `content.typ`.
- `main.typ`: Document entry point linking the cover page, multi-column layout, TOC, and content.
- `uw.png`: University logo for the cover page.

## Usage

To generate content and compile to PDF:
```bash
python3 typst-src/build_typst.py
typst compile typst-src/main.typ typst-src/output.pdf
```
Or use the Makefile targets:
```bash
make typst
make typst-build
```

## Compression and Customization

All layout spacings and sizing parameters are in [config.typ](file:///home/pixl/src/acmlib/typst-src/config.typ). Currently the document compiles to **24 pages** (well within the 26-page budget, including the cover page).

If you add more code and need to compress the document into 26 pages, adjust:
- `base-font-size` (default: `7.0pt`)
- `code-font-size` (default: `6.0pt`)
- `par-leading` (default: `0.42em`)
- `col-gutter` (default: `8pt`)
- Spacings: `space-above-chapter`, `space-below-chapter`, `space-above-entry`, `space-below-title`, `space-below-entry`
- Page margins: `page-margin` (`top`, `bottom`, `x`)
