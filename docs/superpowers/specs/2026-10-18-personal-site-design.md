# Personal site — design

Date: 2026-10-18
Owner: Rodrigo Carneiro (LinkedIn handle `rodrigoteoria`)

## Intent

A personal site whose job is to convince **recruiters and tech leads that Rodrigo is a solid data engineer**. The strongest proof he wants seen first is **his latest LinkedIn posts and his CV**. Projects and experiments (GitHub repos) are supporting evidence.

Success: a tech lead landing on the homepage sees within seconds who he is, his stack, his recent thinking (posts), and can grab the CV.

## Goals

- Homepage leads with CV summary + latest LinkedIn posts.
- Full CV page, plus a downloadable PDF.
- Posts, Projects, Experiments sections.
- Bilingual: English and Portuguese, with a language switch.
- Cheap to maintain: adding a post = add Markdown files + push.

## Non-goals

- No automatic LinkedIn sync (LinkedIn has no practical API for this). Posts are pasted manually.
- No automatic listing of all GitHub repos.
- No CMS, comments, analytics, newsletter, or contact form.

## Anti-goals

- Must not read as a gimmick or a generic template — it should look like a senior engineer's profile.
- Must not bury the data-engineering story under the long early-career web/Flash history.

## Decided

**Stack (owner's choice):** Hugo static site, built and deployed by GitHub Actions to GitHub Pages on push to the default branch.

**Visual direction (owner picked "C · Profile + feed"):**
- Light, clean, card-based. Layout on wide screens: left sidebar with photo, name, "Data Engineer" headline, short experience list, stack tags, and a **Download CV** button; right side is the feed of latest posts as cards (title, one-line teaser, date).
- Top nav: Posts · Projects · Experiments · CV · EN/PT switch.
- Mockup reference: `.superpowers/brainstorm/*/content/homepage-direction.html`, option C.

**Posts:**
- Owner pastes each LinkedIn post manually, in **both English and Portuguese**.
- Each post has its own page with full text and a link to the original LinkedIn post.
- Front matter at minimum: title, date, LinkedIn URL, teaser (optional; fall back to Hugo summary).

**CV:**
- Source is the LinkedIn "Save to PDF" export at `/Users/teoria/Downloads/Profile.pdf` (5 pages; in the PDF the section headings and summary are in Portuguese, and the role bullets are mostly in English).
- **One-time conversion** of that PDF into a structured data file (e.g. `data/cv.yaml`, or one per language), with content written in **both EN and PT**. Owner maintains that file afterwards (or hands over a new PDF for re-conversion).
- Sections in the source: contact, headline, summary, top skills, languages, certifications, honors/awards, publications, experience (Filterbuy → S.C.A Technology, 2005–present), education.
- CV page renders the full CV from the data file. The sidebar summary on the homepage uses the same data.
- **Story (owner's decision):** rewrite the headline and summary to lead with data engineering. Keep data-era roles in full (roughly 2017 → present: Ahgora onward). Condense the pre-2017 roles (Mídias Educativas, Positivo, Politec, S.C.A, etc.) into a short "Earlier career" section. The original PDF summary is not reused verbatim.
- **Public contact (owner's decision):** only LinkedIn and GitHub links. No email, no company sites, on the site or in the generated PDF.
- PDF download is **generated from the site's CV page in CI** (headless browser print), so HTML and PDF never drift. The LinkedIn PDF layout is not reused.

**Projects & Experiments:**
- Source is a **hand-picked list** in the repo (e.g. `data/repos.yaml`): repo name, type (`project` | `experiment`), optional blurb in EN and PT.
- At build time Hugo fetches each repo's description, primary language, and last-updated date from the GitHub API (`resources.GetRemote`).
- Project cards lead with the problem, then stack and outcome (from the blurb); experiments are lighter cards.

**Hosting (owner's decision):** GitHub Pages, served at **`rodrigocarneiro.com`** (custom domain: `CNAME` file + DNS records pointing to GitHub Pages; `baseURL = https://rodrigocarneiro.com/`, so no `/repo/` path prefix).

## Calls made by Claude (owner did not explicitly decide)

- CV section headings are translated per language; Claude translates CV entry text to provide both EN and PT versions during the one-time conversion.
- On phones the sidebar collapses into a compact header above the feed.
- Posts list newest first; homepage shows the latest few with a "See all posts" link.
- English is the default language at `/`; Portuguese at `/pt/`.
- Display name is **Rodrigo Carneiro** (as on the PDF and the domain). "Rodrigo Teória" in the mockup was a placeholder.

## Left to the builder

- Hugo theme: write a small custom layout rather than adopting a heavy theme (must match direction C).
- Exact data file schemas, Hugo i18n setup, content directory layout.
- PDF generation tool in CI.
- GitHub API rate limits / caching during builds.
- Styling details within direction C.

## Not yet provided

- GitHub account/repo name that will host the site (also used to fetch repo metadata).
- Whether anything currently runs on `rodrigocarneiro.com` that DNS changes would replace.

- Profile photo.
- The list of repos to feature and their blurbs.
- The LinkedIn posts themselves.
