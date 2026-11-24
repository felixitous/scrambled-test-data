# NDS static site

Serves the repo over HTTP so a local LLM agent (e.g. Claude Cowork) can fetch and analyze the lookup index and page text without opening the PDFs.

## Run

```sh
./serve.sh            # foreground, http://localhost:8765
./serve.sh start      # background, logs to serve.log
./serve.sh stop
```

Then tell the agent something like:

> The 2018 NDS and its Supplement are served at http://localhost:8765. Read http://localhost:8765/lookup/README.md first for the file layout, then use fetch/web tools to search the JSONL indexes and read the page text files.

## URLs

| URL | What |
|---|---|
| `/lookup/README.md` | start here — file layout and usage |
| `/lookup/*.jsonl`, `/lookup/documents.json` | search indexes (one JSON record per line) |
| `/lookup/text/{nds-2018,nds-supplement}/pNNN.txt` | page text, `NNN` = pdf page |

Notes: localhost only. `lookup/text/` is excluded from directory listing (292 files); use the indexes to find the pages you want. The `@` extended attributes on the lookup files are macOS provenance tags; they don't affect serving.
