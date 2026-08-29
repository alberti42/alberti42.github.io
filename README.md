# Andrea's Personal Page

Please visit [https://alberti42.github.io/](https://alberti42.github.io/) to find out more.

---

The site is built with [Hugo](https://gohugo.io) and the
[Congo](https://github.com/jpanther/congo) theme. Posts are written in Org mode
under `content-org/` and exported to Markdown with
[ox-hugo](https://ox-hugo.scripter.co); the project catalogue on `/projects/`
is generated from the YAML in `data/projects/`.

```sh
make export   # content-org/*.org -> content/*.md
make serve    # live-reloading preview on :1313
make build    # build into public/
make help     # everything else
```

Pushing to `main` builds and deploys via GitHub Actions. Math is rendered at
build time by Hugo's embedded KaTeX, so no JavaScript is shipped to render it.
See [`CLAUDE.md`](CLAUDE.md) for the full architecture notes.

Licensed under the [MIT License](LICENSE).
