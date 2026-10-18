# Personal Site Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** A bilingual (EN/PT) Hugo site at `rodrigocarneiro.com` that presents Rodrigo Carneiro as a solid data engineer: CV + latest LinkedIn posts first, hand-picked GitHub projects/experiments after.

**Architecture:** Plain Hugo with a small custom layout (no theme). Content is Markdown (posts, translated by filename suffix `.en.md`/`.pt.md`) and YAML data files (`data/cv.yaml`, `data/repos.yaml`). One shell script `scripts/build.sh` builds the site and prints the CV pages to PDF with headless Chrome; GitHub Actions runs that same script and deploys to Pages. One shell script `scripts/check.sh` is the test suite: it builds and greps the output.

**Tech Stack:** Hugo extended ≥ 0.146 (local is 0.159), plain CSS, headless Chrome/Chromium, `pdftotext` (poppler) for checks, GitHub Actions + GitHub Pages.

**Spec:** `docs/superpowers/specs/2026-10-18-personal-site-design.md`

## Global Constraints

- Display name: **Rodrigo Carneiro**. Headline leads with data engineering.
- `baseURL = "https://rodrigocarneiro.com/"`; `static/CNAME` contains `rodrigocarneiro.com`.
- Languages: English default at `/`, Portuguese at `/pt/` (`defaultContentLanguageInSubdir = false`). EN/PT switch in nav.
- Public contact: **LinkedIn (`https://www.linkedin.com/in/rodrigoteoria`) and GitHub only.** No email, no `midiaseducativas.com.br`, nowhere on site or PDF.
- Visual direction C: light, card-based; left sidebar (photo, name, headline, short experience list, stack tags, Download CV) + right feed of latest posts. Nav: Posts · Projects · Experiments · CV · EN/PT. Sidebar collapses above the feed below 760px.
- No theme, no JS framework, no npm. No analytics, comments, contact form.
- CV: data-era roles (Ahgora 2017 → present) in full; pre-2017 roles (Mídias Educativas, Mídias Criativas, Positivo, Politec, S.C.A) condensed into "Earlier career" / "Carreira anterior".
- PDF generated from the site's CV page in CI, one per language: `/cv.pdf` and `/pt/cv.pdf`.

## Review Focus

- **No posts yet** (the real posts aren't written): homepage and `/posts/` must render with an empty-state line, not a blank column or a build error. → Task 3 check.
- **GitHub API unavailable or rate-limited during build:** build must still succeed and cards fall back to `repos.yaml` values. → Task 4 check (`GITHUB_FETCH=false`).
- **Post exists in only one language:** must render in that language without breaking the other; language switch on that page hides or points to the section list. → Task 3 check.
- **Private data leakage:** gmail address or company site sneaking in from the PDF conversion. → Task 2 check greps whole `public/`.
- **PDF printing site chrome** (nav, sidebar, language switch) instead of a clean CV. → Task 5 check via `pdftotext` (no "Experiments" nav word).

---

## File Structure

```
hugo.toml                       site + languages + menus + params
static/CNAME                    custom domain
static/img/photo.jpg            placeholder until owner supplies one
assets/css/main.css             all styles incl. @media print
i18n/en.yaml, i18n/pt.yaml      UI strings
data/cv.yaml                    CV, bilingual fields {en, pt}
data/repos.yaml                 hand-picked repos
layouts/_default/baseof.html    shell: <html lang>, nav, main
layouts/partials/nav.html       menu + language switch
layouts/partials/sidebar.html   profile card from data/cv.yaml
layouts/partials/t.html         picks .en/.pt from a bilingual map
layouts/partials/post-card.html
layouts/partials/repo-card.html GitHub fetch + fallback
layouts/index.html              sidebar + latest posts
layouts/posts/list.html, layouts/posts/single.html
layouts/repos/list.html         shared by projects/ and experiments/
layouts/cv/single.html          full CV
content/_index.{en,pt}.md
content/posts/_index.{en,pt}.md
content/projects/_index.{en,pt}.md   (type: repos, params.kind: project)
content/experiments/_index.{en,pt}.md (type: repos, params.kind: experiment)
content/cv.{en,pt}.md                 (type: cv)
content/posts/example/index.{en,pt}.md  draft: true fixture
scripts/build.sh                hugo + PDF
scripts/check.sh                tests
.github/workflows/deploy.yml
.gitignore                      public/, resources/, .hugo_build.lock, .superpowers/
```

Shared interface: `partial "t.html" (dict "v" $value "lang" site.Language.Lang)` returns `$value` if it's a string, else `index $value $lang`. Every bilingual field in `data/*.yaml` is either a plain string (same in both languages) or a map `{en: ..., pt: ...}`.

---

### Task 1: Skeleton, languages, layout shell, check harness

**Files:**
- Create: `hugo.toml`, `.gitignore`, `static/CNAME`, `i18n/en.yaml`, `i18n/pt.yaml`, `assets/css/main.css`, `layouts/_default/baseof.html`, `layouts/partials/nav.html`, `layouts/partials/t.html`, `layouts/index.html` (placeholder main), `content/_index.en.md`, `content/_index.pt.md`, `scripts/check.sh`

**Interfaces:**
- Produces: `scripts/check.sh` (exit non-zero on first failing assertion; helpers `has FILE PATTERN`, `lacks FILE PATTERN`); `partial "t.html"` as above; `baseof.html` with `block "main"`; i18n keys `posts, projects, experiments, cv, download_cv, latest_posts, see_all_posts, no_posts, earlier_career, experience, education, stack, read_on_linkedin, updated, no_projects, no_experiments`.

- [ ] **Step 1: `git init`, write `scripts/check.sh` with first assertions**

```bash
#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
rm -rf public && hugo --quiet --buildDrafts ${HUGO_ARGS:-} >/dev/null
has()   { grep -qE "$2" "public/$1" || { echo "FAIL: $1 lacks /$2/"; exit 1; }; }
lacks() { ! grep -rqiE "$2" "public/$1" || { echo "FAIL: $1 contains /$2/"; exit 1; }; }
has index.html     '<html lang="en"'
has pt/index.html  '<html lang="pt"'
has index.html     'href="/pt/"'
has CNAME          '^rodrigocarneiro.com$'
echo OK
```

- [ ] **Step 2: Run `bash scripts/check.sh`** — Expected: FAIL (no hugo config).
- [ ] **Step 3: Write config, shell, nav, i18n, CSS tokens, `.gitignore`.** `hugo.toml`: `baseURL`, `defaultContentLanguage = "en"`, `[languages.en]`/`[languages.pt]` with `languageName` `EN`/`PT`, per-language `menus.main`: EN `Posts`, `Projects`, `Experiments`, `CV`; PT `Posts`, `Projetos`, `Experimentos`, `Currículo`, `params.linkedin`, `params.github` (owner's GitHub URL — placeholder `https://github.com/OWNER` until supplied, see Spec "Not yet provided"). Nav language switch iterates `.Translations`; if none, links to the other language's home.
- [ ] **Step 4: Run `bash scripts/check.sh`** — Expected: `OK`.
- [ ] **Step 5: Commit** `feat: hugo skeleton with en/pt and check harness`

### Task 2: CV data (one-time conversion) + CV page + sidebar

**Files:**
- Create: `data/cv.yaml`, `layouts/cv/single.html`, `layouts/partials/sidebar.html`, `content/cv.en.md`, `content/cv.pt.md`, `static/img/photo.jpg` (neutral placeholder)
- Modify: `assets/css/main.css` (CV styles + `@media print` hiding nav/sidebar/lang switch), `scripts/check.sh`

**Interfaces:**
- Consumes: `t.html`, i18n keys.
- Produces: `data/cv.yaml` schema:
  ```yaml
  name: Rodrigo Carneiro
  headline: {en: ..., pt: ...}
  location: {en: Pernambuco, Brazil, pt: Pernambuco, Brasil}
  summary: {en: ..., pt: ...}          # rewritten, data-engineering first
  stack: [Airflow, dbt, Spark, Kafka, Athena, ...]
  experience:   # 2017 → present, newest first
    - {company, role: {en,pt}, start: "2026-03", end: null, location?, bullets: {en: [...], pt: [...]}, tech: [...]}
  earlier_career: {en: ..., pt: ...}   # 1 short paragraph naming the pre-2017 roles
  education: [{school, degree: {en,pt}, years}]
  certifications: [...]
  awards: [{en,pt}]
  publications: [...]
  languages: [{name: {en,pt}, level: {en,pt}}]
  ```
- `partial "sidebar.html" .` renders name, headline, first 3 `experience` entries (company + role), `stack` tags, Download CV link to `{{ relLangURL "cv.pdf" }}`.

- [ ] **Step 1: Add checks to `scripts/check.sh`**

```bash
has cv/index.html     'Serasa Experian'
has cv/index.html     'Earlier career'
has pt/cv/index.html  'Carreira anterior'
has cv/index.html     'Universidade de Pernambuco'
has index.html        'Download CV'
has index.html        'Rodrigo Carneiro'
lacks . 'gmail|midiaseducativas|teoria@'
```

- [ ] **Step 2: Run** — Expected: FAIL `cv/index.html lacks /Serasa Experian/`.
- [ ] **Step 3: Write `data/cv.yaml`** from `/Users/teoria/Downloads/Profile.pdf` (read it). Full entries: Filterbuy, Universidade de Pernambuco (Researcher), Serasa Experian, Incognia, Passei Direto, LeanCompliance, TKSolution, Ahgora Sistemas, Deeep Marketing. Earlier career paragraph: Mídias Educativas (co-founder, 2008–2019), Mídias Criativas, Positivo Tecnologia, Politec, S.C.A Technology. Fix source typos (MondoDB → MongoDB, Kubernets → Kubernetes). Translate every bilingual field. Omit Contact section entirely.
- [ ] **Step 4: Write `layouts/cv/single.html`, `sidebar.html`, CSS; wire sidebar into `layouts/index.html`.**
- [ ] **Step 5: Run** — Expected: `OK`. Open `hugo server` and eyeball `/cv/` and `/pt/cv/`.
- [ ] **Step 6: Commit** `feat: bilingual CV from LinkedIn profile`

### Task 3: Posts + homepage feed

**Files:**
- Create: `layouts/posts/list.html`, `layouts/posts/single.html`, `layouts/partials/post-card.html`, `content/posts/_index.{en,pt}.md`, `content/posts/example/index.en.md` + `index.pt.md` (`draft: true`), `content/posts/only-en/index.en.md` (`draft: true`, EN only)
- Modify: `layouts/index.html`, `scripts/check.sh`, `assets/css/main.css`

**Interfaces:**
- Post front matter: `title`, `date`, `linkedin` (URL), `teaser` (optional; card falls back to `.Summary | plainify | truncate 140`).
- Homepage shows 5 newest from `where site.RegularPages "Section" "posts"`, then "See all posts".

- [ ] **Step 1: Add checks**

```bash
has index.html               'example'            # draft fixture appears with --buildDrafts
has posts/example/index.html 'linkedin.com'       # "Read on LinkedIn" link
has pt/posts/example/index.html '<html lang="pt"'
has posts/only-en/index.html 'only'
# empty state: build without drafts
rm -rf public && hugo --quiet >/dev/null
has index.html 'No posts yet'
has pt/index.html 'Nenhuma publicação ainda'
```

- [ ] **Step 2: Run** — Expected: FAIL.
- [ ] **Step 3: Implement layouts and fixtures.** The "Read on LinkedIn" link renders only when `linkedin` is set.
- [ ] **Step 4: Run** — Expected: `OK`.
- [ ] **Step 5: Commit** `feat: posts section and homepage feed`

### Task 4: Projects & Experiments from hand-picked repos

**Files:**
- Create: `data/repos.yaml`, `layouts/repos/list.html`, `layouts/partials/repo-card.html`, `content/projects/_index.{en,pt}.md`, `content/experiments/_index.{en,pt}.md`
- Modify: `scripts/check.sh`, `assets/css/main.css`

**Interfaces:**
- `data/repos.yaml`:
  ```yaml
  - repo: owner/name         # full slug
    kind: project            # project | experiment
    blurb: {en: ..., pt: ...}   # optional
    description: ...         # optional fallback if fetch fails
  ```
- `repo-card.html`: if `getenv "GITHUB_FETCH"` ≠ `"false"`, `try (resources.GetRemote (printf "https://api.github.com/repos/%s" .repo) $opts)`; on error or nil, use YAML fields only. Sends `Authorization: Bearer` header when `GITHUB_TOKEN` env is set (needs `security.funcs.getenv` to allow `^GITHUB_`). Shows name (link to repo), blurb or description, language, "Updated" month.
- Section `_index` front matter: `type: repos`, `params: {kind: project|experiment}`.
- Seed `repos.yaml` with one public repo the owner names; until then use `gohugoio/hugo` as `kind: experiment` placeholder and flag it in the handoff.

- [ ] **Step 1: Add checks**

```bash
rm -rf public && GITHUB_FETCH=false hugo --quiet >/dev/null
has projects/index.html    'No projects yet'   # seed has no kind: project
has experiments/index.html 'gohugoio/hugo'
has pt/experiments/index.html 'Experimentos'
```

- [ ] **Step 2: Run** — FAIL. **Step 3: Implement.** **Step 4: Run** — `OK`; also run `hugo` with network once and confirm the card shows a language.
- [ ] **Step 5: Commit** `feat: projects and experiments from hand-picked repos`

### Task 5: PDF build + GitHub Actions deploy

**Files:**
- Create: `scripts/build.sh`, `.github/workflows/deploy.yml`
- Modify: `scripts/check.sh`

**Interfaces:**
- `scripts/build.sh`: `hugo --minify`, then serve `public/` on `127.0.0.1:1313` (`python3 -m http.server`), print `/cv/` → `public/cv.pdf` and `/pt/cv/` → `public/pt/cv.pdf` with `"$CHROME" --headless=new --no-pdf-header-footer --print-to-pdf=...`, kill server. `CHROME` defaults to `google-chrome`, falling back to `/Applications/Google Chrome.app/Contents/MacOS/Google Chrome`. Print via local server, not `baseURL`, so it works before DNS exists.
- Workflow: on push to `main` + `workflow_dispatch`; `peaceiris/actions-hugo@v3` (extended, pinned to `0.159.0`), `browser-actions/setup-chrome@v1`, `run: bash scripts/build.sh` with `GITHUB_TOKEN` env, then `actions/upload-pages-artifact@v3` + `actions/deploy-pages@v4`. Permissions `pages: write, id-token: write`.

- [ ] **Step 1: Add checks (run after build)**

```bash
bash scripts/build.sh
pdftotext public/cv.pdf - | grep -q 'Serasa Experian' || { echo "FAIL: cv.pdf"; exit 1; }
pdftotext public/pt/cv.pdf - | grep -q 'Carreira anterior' || { echo "FAIL: pt/cv.pdf"; exit 1; }
! pdftotext public/cv.pdf - | grep -q 'Experiments' || { echo "FAIL: nav printed in PDF"; exit 1; }
```

- [ ] **Step 2: Run** — FAIL. **Step 3: Implement.** **Step 4: Run** — `OK`.
- [ ] **Step 5: Commit** `ci: build CV PDFs and deploy to GitHub Pages`

### Handoff (owner actions, not code)

Create the GitHub repo and push; Settings → Pages → Source: GitHub Actions; set custom domain `rodrigocarneiro.com`; DNS: apex `A` records to GitHub Pages IPs + `www` CNAME → `<user>.github.io`. Supply: photo, GitHub username, repo list, first posts.
