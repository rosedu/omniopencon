# CLAUDE.md — OmniOpenCon website

Guidance for Claude Code sessions working in this repository.

## What this is

Static website of the OmniOpenCon conference (https://omniopencon.org/), an annual free
open-source/open-everything event in Bucharest organized by POLITEHNICA Bucharest, the Faculty
of Automatic Control and Computers, and ROSEdu. Built with **Hugo extended (0.133.0)** and a
custom theme that lives in this repo (no external theme, no npm, no database).

All editions are one site:

| URL | Source |
|-----|--------|
| `/` | redirect to `params.currentEdition` (`hugo.yaml`) via `layouts/index.html` |
| `/2026/`, `/2025/`, `/2024/` | `content/<year>/_index.md` (About text) + `data/editions/<year>.yaml` (everything structured) |
| `/code-of-conduct/` | `content/code-of-conduct.md` |

## Repository layout

```
hugo.yaml                 site config: currentEdition, contact channels, organizers, GA id
content/<year>/_index.md  front matter `type: edition`, `edition: "<year>"`; body = About text
data/editions/<year>.yaml dates, venue, registration, cfs, format, schedule, speakers,
                          sponsors, partners, communities (schema documented in README.md)
layouts/_default/         baseof.html, single.html, list.html
layouts/edition/list.html the single-page edition template (calls the partials below in order)
layouts/partials/edition/ ctx.html (builds the edition context: data, isPast, isCurrent, cfsOpen,
                          hero, speakersById), hero, facts, about, cfs, schedule, session,
                          avatar, speakers, venue, partners, gallery, conduct, contact, sections
layouts/partials/         nav.html, footer.html, icons/*.svg (inline SVG partials)
assets/css/main.css       the whole stylesheet (design tokens at the top, dark mode via
                          prefers-color-scheme); piped through minify + fingerprint
assets/js/main.js         optional enhancements only: nav state, countdown, lightbox
assets/photos/<year>/     event photos -> gallery + hero (Hugo resizes to WebP at build time)
assets/img/speakers/      speaker photos (processed by Hugo, .Fill with smart crop)
static/img/               logos (sponsors/partners/organizers, orgs/ for communities),
                          favicon, og-image.jpg; static/CNAME for GitHub Pages
.github/workflows/gh-pages.yml  single `hugo --minify` build, deploys public/ to gh-pages
Dockerfile, docker-compose.yml, Makefile  local runs via Docker (extended build)
.prompts/                 historical LLM prompts from earlier tasks; not used by the build
```

## Commands

```console
hugo server --noBuildLock --renderToMemory   # dev server, http://localhost:1313/
hugo --minify                                 # production build into public/
make            # docker: dev server        make serve   # docker: static build + python server
```

Hugo **extended** is required (WebP image processing). If no `hugo` binary is on PATH,
download `hugo_extended_<ver>_linux-amd64.tar.gz` from GitHub releases into the scratchpad
and run it from there (that is what previous sessions did).

Local gotchas: `public/` and `.hugo_build.lock` may be root-owned from old Docker runs, so
build with `--noBuildLock` and `--renderToMemory` or `--destination <scratchpad path>`.
`resources/_gen/` (Hugo image cache) is git-ignored.

## Conventions

- Keep the site Markdown/YAML/text-based and fully static; no databases, no JS frameworks.
- Content editors touch `content/` and `data/editions/`; templates should degrade gracefully
  when data is missing (empty schedule -> "coming soon", no speakers -> note, no photos ->
  previous editions' photos, no registration -> no button). Use `TODO` for unknown facts.
- Past/upcoming state is computed from `dates.end`; call-for-speakers open/closed from
  `cfs.deadline`. Both can be overridden (`status`, `cfs.open`) in the edition YAML.
- Quote clock times in YAML (`"09:00"`) so they are not parsed as sexagesimal numbers.
- Image/logo paths in data are relative to the site root without a leading slash
  (`img/logo-nxp.png`); speaker photos and gallery photos are paths under `assets/`.
- Use `relURL` for internal links so the site works at any base URL (localhost and
  omniopencon.org). `og:image` and canonical links use `absURL`.
- Do not commit or push unless explicitly asked. Never build with `git checkout <tag>` hacks:
  the old per-tag build was replaced by the single-site build.
- Visual checks: headless Chromium (`chromium --headless=new --screenshot=...`) works, but it
  can only write under `~/snap/chromium/common/`, not to hidden dirs or `/tmp`. Google Maps
  iframes render blank in headless mode; that is not a site bug.

## State of the redesign (September 2026)

The redesign (branch `razvand/new-site-format`) replaced the `hugo-conference` theme and the
per-year tag builds. Working tree changes are **uncommitted** by request. The `2024` and
`2025` git tags still point at the old theme's history and are no longer used by the build.

- 2024 data was converted programmatically from the old `config.yml` (52 speakers, full
  timetable, 39 communities). One speaker photo (`andrei.cipu.jpg`) is missing; the avatar
  partial falls back to initials.
- 2025 has the workshop list (Luma links) and the Sessionize grid embed for talks; no
  speaker data is in the repo.
- 2026: schedule and speakers are not yet known (`schedule.days: []`, `speakers: []`).
  The call for speakers closed on 2026-09-07 and renders as closed automatically.
- Only one event photo exists (`assets/photos/2024/stage-keynote.jpg`, also the hero).
  More photos are expected; just add them under `assets/photos/<year>/`.
- Open items to verify in a real browser: the keyless Google Maps embed in the Venue
  section, and the styling clash of the Sessionize embed on the 2025 page.
