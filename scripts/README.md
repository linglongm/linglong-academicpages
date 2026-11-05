# scripts/

Utility scripts for this site.

## `make-og-image.sh`

Generates the social preview image at `images/og-image.png` (1200x630 PNG),
the card shown when someone shares a link to the site. `_includes/seo.html`
uses it via `og_image` in `_config.yml` when a page has no header image of its own.

```
bash scripts/make-og-image.sh
```

To change the wording, colours or menu pills, edit the settings at the top of
the script and run it again, then commit the new `images/og-image.png`.

Requirements:

- ImageMagick 7 (`magick`)
- DejaVu Sans fonts in `/usr/share/fonts/truetype/dejavu`; override the
  directory with the `FONT_DIR` environment variable

The image is committed to the repo, so the site build does not need ImageMagick.
