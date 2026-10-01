# OmniOpenCon Website

This is the website of the [OmniOpenCon](https://omniopencon.org/) conference.
It is a static site generated with [Hugo](https://gohugo.io/) (extended) from Markdown, YAML and a custom, dependency-free theme that lives in this repository (`layouts/`, `assets/`).

All editions are part of the same site:

| URL | Source |
|-----|--------|
| `/` | Redirects to the current edition (`params.currentEdition` in `hugo.yaml`) |
| `/2026/`, `/2025/`, `/2024/` | `content/<year>/_index.md` + `data/editions/<year>.yaml` |
| `/code-of-conduct/` | `content/code-of-conduct.md` |

## Running Locally

### With Hugo installed

Install [Hugo **extended**](https://gohugo.io/installation/) (0.133 or newer), then:

```console
hugo server
```

Open http://localhost:1313/ (it redirects to the current edition).

### With Docker

```console
docker compose up
```

or

```console
make
```

Both start a live-reloading Hugo server at http://localhost:1313/.

To produce the exact static output that gets deployed, run `make build-site` (output in `public/`), or `make serve` to build and serve it with Python at http://localhost:8000/.

## Editing Content

### Text

* `content/<year>/_index.md` — the "About" text of an edition (Markdown). Its front matter links the page to its data file via `edition: "<year>"`.
* `content/code-of-conduct.md` — the code of conduct (Markdown), shared by all editions.
* `hugo.yaml` — site-wide settings: current edition, contact channels (e-mail, Discord, GitHub, social), organizers, analytics.

### Edition data (`data/editions/<year>.yaml`)

Everything structured about an edition. The main keys:

```yaml
year: 2026
ordinal: 3rd                      # "3rd edition" badge
title: OmniOpenCon 2026
tagline: One sentence shown in the hero.
dates: { start: "2026-10-16", end: "2026-10-17", display: "October 16–17, 2026" }
venue: { name: ..., address: ..., map_query: ..., notes: Markdown }
registration: { label: Register for free, url: https://... }   # hidden once the edition is over
cfs:                              # call for speakers; shown as "closed" after the deadline
  url: https://sessionize.com/...
  deadline: "2026-09-07"
  deadline_display: Monday, September 7, 2026
  # open: true                    # force open/closed regardless of the deadline
format:                           # the "Day 1 · Workshops / Day 2 · Talks" cards
  - { title: ..., when: ..., text: ... }
schedule:
  note: Shown while `days` is empty.
  days:
    - label: Friday
      date: "2026-10-16"
      theme: Workshops
      intro: Markdown
      embed: https://sessionize.com/api/v2/<id>/view/GridSmart   # optional Sessionize grid
      slots:
        - time: "09:00"
          title: Opening
          location: Aula Magna     # optional
          description: Markdown    # optional
          rooms: [B3.1, B3.2]      # optional, informational
          sessions:                # optional; parallel sessions of this slot
            - time: "09:15"        # optional; sessions are grouped by time
              room: B3.1
              title: Explicit title   # defaults to the first speaker's talk title
              speakers: [11, 8]    # speaker ids from `speakers`
              url: https://...     # optional external link (e.g. sign-up)
speakers:                         # rendered as cards, alphabetically
  - id: 11
    name: Ada Lovelace
    photo: img/speakers/ada.lovelace.jpg   # under assets/, optional
    affiliation: ...
    affiliation_url: ...
    linkedin: ...
    github: ...
    site: ...
    type: Talk | Workshop
    title: Talk or workshop title
    description: Abstract
    bio: Short bio
speakers_note: Shown when `speakers` is empty.
sponsors:   [{ name, logo, url }]  # logos under static/img/
partners:   [{ name, logo, url }]
communities: [{ name, logo, url }] # participating projects and communities
# status: past | upcoming         # optional; by default computed from `dates.end`
# hero: photos/2026/opening.jpg   # optional hero photo, defaults to params.heroImage
```

Use `TODO` for information that is not yet known.

### Photos

Drop photos in `assets/photos/<year>/` (JPEG or PNG, any size).
Hugo resizes them at build time; the originals are never served.

* They appear in the "Moments from OmniOpenCon <year>" gallery of that edition.
* An edition without photos shows the photos of previous editions instead.
* The hero image is `params.heroImage` in `hugo.yaml`, or the edition's `hero` key.

Speaker photos go in `assets/img/speakers/`; logos of sponsors, partners and communities go in `static/img/` (`static/img/orgs/` for communities).

### Adding a new edition

1. Copy `data/editions/2026.yaml` to `data/editions/<year>.yaml` and update it.
2. Copy `content/2026/_index.md` to `content/<year>/_index.md`, set `edition: "<year>"` and adapt the text.
3. Set `params.currentEdition` in `hugo.yaml` to the new year.

The "Editions" menu, the footer list and the root redirect update automatically.

## Deployment

Every push to `main` runs `.github/workflows/gh-pages.yml`, which builds the site with Hugo extended and publishes `public/` to the `gh-pages` branch (served at https://omniopencon.org/ via `static/CNAME`).
Pull requests get a build check without deploying.

## Layout of the Repository

```
hugo.yaml            site configuration
content/             Markdown: edition intros, code of conduct
data/editions/       YAML: one file per edition (dates, venue, schedule, speakers, sponsors …)
layouts/             HTML templates (Go templates) of the custom theme
  edition/list.html  the single-page edition template
  partials/edition/  hero, facts, about, cfs, schedule, speakers, venue, partners, gallery, contact
assets/css, assets/js   stylesheet and a small progressive-enhancement script
assets/photos/<year>/   event photos (processed by Hugo)
assets/img/speakers/    speaker photos (processed by Hugo)
static/img/             logos, favicon, social preview image (served as-is)
```
