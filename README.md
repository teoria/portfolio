# rodrigocarneiro.com

Personal site: CV, LinkedIn posts, projects and experiments. English at `/`, Portuguese at `/pt/`.
Built with [Hugo](https://gohugo.io/) (no theme), deployed to GitHub Pages by GitHub Actions on every push to `main`.

## Run locally

```bash
hugo server            # http://localhost:1313, live reload
bash scripts/check.sh  # build + assertions on the output, incl. CV PDFs
bash scripts/build.sh  # production build into public/, with cv.pdf and pt/cv.pdf
```

Requires Hugo extended ≥ 0.146, Google Chrome (for the PDFs) and `pdftotext` (poppler, used by `check.sh`).

## Update content

| What | Where |
|------|-------|
| Add a LinkedIn post | Copy `content/posts/example/` to `content/posts/<slug>/`, paste the text into `index.en.md` and `index.pt.md`, set `title`, `date`, `linkedin` (URL of the original post), optional `teaser`, and remove `draft: true`. A post can exist in one language only. |
| CV | `data/cv.yaml`. Fields are either a plain string or `{en: ..., pt: ...}`. The CV page, the homepage sidebar and both PDFs come from this file. |
| Projects / experiments | `data/repos.yaml`: `repo: owner/name`, `kind: project` or `experiment`, optional `blurb: {en, pt}`. Description, language and last update are fetched from the GitHub API at build time; if that fails the build still succeeds. |
| Photo | Drop `assets/img/photo.jpg` (square). Until then the sidebar shows initials. |
| UI strings | `i18n/en.yaml`, `i18n/pt.yaml` |
| Menus, LinkedIn/GitHub links | `hugo.toml` |

Only LinkedIn and GitHub are public contacts. `check.sh` fails the build if an email address or company site shows up in the output.

## Deploy

Push to `main`. `.github/workflows/deploy.yml` runs `scripts/check.sh`, then `scripts/build.sh`, and publishes `public/` to GitHub Pages (custom domain from `static/CNAME`). In CI, `check.sh` also blocks placeholder values (`github.com/OWNER`, `gohugoio/hugo`) from shipping.

## Layout

```
content/      posts, section index pages, cv page stubs (en/pt by filename suffix)
data/         cv.yaml, repos.yaml
layouts/      custom templates; partials/t.html picks the en/pt value of a field
assets/css/   main.css, including @media print rules used for the PDF
scripts/      build.sh, check.sh
docs/         design spec and implementation plan
```
