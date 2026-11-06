# mengmeiye.github.io

Source of <https://www.mengmeiye.com>: a small [Jekyll](https://jekyllrb.com/) site.
The design comes from the [al-folio](https://github.com/alshedivat/al-folio) theme
(MIT license, see `LICENSE`). The parts of al-folio this site doesn't use were removed.

## What's where

| Path | Contents |
| --- | --- |
| `_pages/*.md` | The pages. This is what you normally edit. |
| `assets/img/`, `assets/pdf/` | Profile photo and papers |
| `_config.yml` | Name, description, footer text |
| `_layouts/`, `_includes/` | HTML templates |
| `_sass/`, `assets/css/main.scss` | Styles |
| `_plugins/` | Three small build helpers: link attributes, cache-busting, stripping HTML comments |
| `.github/workflows/deploy.yml` | Builds and publishes the site on every push to `main` |
| `UnusedPages/` | Drafts; not published |

## Preview locally

You need [Docker Desktop](https://www.docker.com/products/docker-desktop/).

```sh
docker compose up
```

Then open <http://localhost:8080>. When you save a file, the site is rebuilt and the
browser reloads automatically. Press `Ctrl-C` to stop.

- The first run builds a local image (about a minute). Later runs start in seconds.
- Changes to `_config.yml` need a restart (`Ctrl-C`, then `docker compose up`).
- After changing `Gemfile` or `Gemfile.lock`, run `docker compose up --build`.

To check the exact production build that GitHub Actions runs (output goes to `_site/`):

```sh
docker compose run --rm -e JEKYLL_ENV=production jekyll bundle exec jekyll build
```

## Publish

Push to `main`. The **Deploy site** workflow builds the site and publishes it with
GitHub Pages. Pull requests are built but not published.

One-time setting (already done if the site is live): **Settings → Pages → Build and
deployment → Source: GitHub Actions**.

## Common tasks

**Add a page to the menu:** create `_pages/<name>.md` starting with

```yaml
---
layout: page
permalink: /<name>/
title: <Title>
nav: true
---
```

Menu items appear in file-name order, after "Home".

**Change the profile photo:** replace `assets/img/Mengmei_Ye.jpeg`, then recreate the
smaller WebP copies the page serves to most browsers:

```sh
docker run --rm -v "$PWD/assets/img":/img -w /img alpine:3 sh -c \
  'apk add --no-cache imagemagick imagemagick-jpeg imagemagick-webp >/dev/null &&
   for w in 480 800 1400; do magick Mengmei_Ye.jpeg -resize ${w}x -quality 85 Mengmei_Ye-$w.webp; done'
```

(Or delete the `Mengmei_Ye-*.webp` files; the page then uses the JPEG directly.)

## Dependency updates

Dependabot opens at most one grouped PR per month for gems and one for GitHub Actions,
plus security PRs when an advisory is published. Merge them when the **Deploy site**
check on the PR passes.
