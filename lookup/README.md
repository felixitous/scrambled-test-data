# NDS lookup

Index and extracted page text for the two PDFs one folder up, so a model can find things and read them without opening the PDFs.

| doc id | file | use it for |
|---|---|---|
| `nds-2018` | `NDS-2018.pdf` (206 pp) | equations, adjustment factors, member and connection rules (bolts, lag screws, nails, split rings, rivets), fire design, appendices A-N |
| `nds-supplement` | `NDS_supplement.pdf` (86 pp) | tabulated reference design values by species/grade (Tables 4A-6B), section properties (1A-1D), grading agencies, species combinations |

## How to use
1. Search the index: `grep -i "bolt" lookup/*.jsonl`. One JSON record per line, so a hit is a complete record. Exact lookups: `"id":"12.3"`, `"id":"Appendix E"`, `"label":"Table 12A"`.
2. Read the text: a record's `text` is the file for its first page; read `pdf_start`-`pdf_end` (e.g. `p095.txt` to `p100.txt` in the same folder).
3. Or search the text directly: `grep -rn -i "Douglas Fir-Larch" lookup/text/nds-supplement`. The file name is the pdf page.
4. For questions that need both documents (NDS says how to adjust, the Supplement holds the values), check `crossrefs.jsonl`.
5. For equations, figures, or anything that looks off, check the page itself (see Notes).

`file` and `text` paths are relative to the repo root.

## Page numbers
- `pdf_start`/`pdf_end`: 1-based physical PDF page, inclusive. They name the text files.
- `printed_start`/`printed_end`: number printed on the page (roman in front matter). Use these when citing.
- NDS: printed = pdf - 12 (pdf 13-204). Supplement: printed = pdf - 8 (pdf 9-84). Details in `documents.json`.
- A range's last page can be shared: the next section or table may start part-way down it.

## Files
| file | one record per | fields |
|---|---|---|
| `documents.json` | PDF | id, file, title, pdf_pages, use_for, text, page_numbers |
| `sections.jsonl` | chapter, section, appendix, front/back matter | doc, file, id, type, title, parent, pdf_*, printed_*, text, status (appendices), note |
| `tables.jsonl` | table | doc, file, id, label, part, title, parent, pdf_*, printed_*, text, group, group_title, note |
| `figures.jsonl` | figure | same as tables, without `part` |
| `crossrefs.jsonl` | NDS-to-Supplement link | topic, how, nds {file, cite, sections[]}, supplement {file, tables[]} |
| `text/<doc id>/pNNN.txt` | PDF page | NNN = pdf page, 3 digits (292 files) |

Empty fields are omitted (a top-level entry has no `parent`). `parent` is a section `id` in the same doc. Tables printed in the NDS list as a range (12A-I, 12.2C-E, L1-L7) are one record per table with `group`/`group_title`. Supplement tables have `part`: `table`, `adjustment-factors` (a separate page, read it with the values), `footnotes` or `expanded`.

## Page text format
- First line: `[doc | file | pdf page N | printed page M]`, then the page: header, body, footer.
- Prose is in reading order. Hyphenated line breaks are kept as in the PDF.
- Tables are rebuilt as aligned columns from word positions (a blank cell shows as a gap). Rotated tables are laid out as they read with the page turned. Rotated column headings appear in a `[text in another orientation]` line, left to right, separated by `|`.
- Symbol-font glyphs are decoded (≤ ≥ ⊥ ∥ θ λ φ Δ ′ °). The script ℓ, capital I and ∥ that the NDS draws as images are put back. Nothing else is altered (no OCR).

## Notes
- Page text was compared character by character with each PDF's own text layer: nothing lost or added except the decoded and restored glyphs above.
- Equations come out flattened: numerators, denominators and subscripts sit on separate rows or positions, and fraction bars and drawn figures are not text. Check equations against the page image. Claude Code's Read tool opens PDF pages with `pages: "95-100"` (max 20 per call) and needs poppler (`brew install poppler`).
- Index data comes from each PDF's outline and printed list of tables/figures, re-checked against the pages. Corrected from the source: bookmarks for NDS 12.3 (p96 -> p95) and 12.4/12.5 (p102 -> p101) were off by one and 12.6 had none (now p105). The NDS list of tables gives a stale page for Table 13A (now p133) and prints 14.2.1E twice (the second is 14.2.1F). There is no Table 12O.
- Tables 12A-12T and 14.2.1A-14.2.2B sit after their chapter's text, so the ranges for 12.6 and 14.3 stop before them.
- `text/` is extracted from AWC's copyrighted PDFs (copying is switched off in the files and the EULA forbids reproduction). Keep it local; do not publish it or commit it to a public repo.
