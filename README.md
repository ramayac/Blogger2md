# SrByte Blogger backup

SrByte was a blog I had when blogger was a thing.

This repo and Python script is used to convert Blogger Google Takeout Atom feeds into clean, structured, and individual Markdown files. It parses Blogger posts, pages, and comments, cleans up HTML markup into strict Markdown syntax, formats metadata into YAML frontmatter, and offers options to bundle the resulting files into a single document.

And that's it! curious why I did it and where are these .md files now? well check out my personal blog [ramayac.com](https://ramayac.com) where I have published all the posts from this backup in my own blog engine called [MDBlog](https://github.com/ramayac/mdblog).

Want to use it, still interested? keep reading:

## Features

- **Multi-Format XML/Atom Support**: Works with both classic Blogger export XML files and the newer Google Takeout Blogger 2018 `feed.atom` format. But I'm only supporting the `feed.atom` format for now, since that's what Google Takeout provides.

- **Robust HTML-to-Markdown Parser**:
  - Converts headings (`<h1>` to `<h6>`), lists (`<ul>`, `<ol>`, `<li>`), blockquotes, code blocks (`<pre><code>`), links, images, and iframe/video embeds.
  - Automatically normalizes double/single quotes in captions.
  - Standardizes all image alt tags and handles linked images.
  - Converts all HTTP URLs to HTTPS for secure linking.

- **Smart Footer & Tag Cleanup**:
  - Strips Blogger-specific tags (such as Blogalaxia tag links) and copyleft/copyright notices.
- **YAML Frontmatter Generation**: Generates standard metadata header for each post (title, date, author, tags, draft status, and Blogger post ID).

- **Flexible Exclusions**:
  - Exclude or include draft posts when exporting.
  - Exclude or include comment entries.

- **Markdown Bundler**: Option to concatenate all generated Markdown files into a single large document (e.g., `big.md`) sorted alphabetically by filename, with separate filters to exclude comments and drafts from the bundle.

---

## File Structure

- [srbyte.py](./srbyte.py): The main converter script containing all HTML parsing, XML extraction, and bundling logic.
- `feed.atom`: Input Blogger export files (XML format).
- `blog_posts/`: Default output directory containing individual generated markdown files.
- `big.md`: Optional bundled file containing all generated posts concatenated.

---

## Usage

You can run the script using Python 3.

```bash
python3 srbyte.py [options]
```

### CLI Arguments

| Option | Default | Description |
| :--- | :--- | :--- |
| `--xml` | `feed.atom` | Path to the input Blogger Atom feed. |
| `--out` | `blog_posts` | Output directory where individual Markdown files will be saved. |
| `--include-comments` | *None* | Flag to include comment entries in the output directory. |
| `--export-drafts` | *None* | Flag to export draft posts. If omitted, drafts are skipped by default. |
| `--bundle` | *None* | Flag to bundle all exported `.md` files into a single `.md` file. |
| `--bundle-path` | `big.md` | Path/filename for the bundled Markdown file (if `--bundle` is active). |
| `--include-drafts-in-bundle` | *None* | Flag to include draft posts in the bundled file. |

### Examples

#### 1. Export Published Posts (Default)
Export only published posts (skipping drafts and comments) into the default `blog_posts/` directory:
```bash
python3 srbyte.py --xml feed.atom
```
#### 2. Export and Bundle into a Single File
Export all published posts and generate a single combined `big.md` file:
```bash
python3 srbyte.py --xml feed.atom --bundle --bundle-path my_blog_archive.md
```
