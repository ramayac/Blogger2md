# Blogger2md

Blogger2md was created out of nostalgia. I had a blog called "Sr. Byte" (short for *Señor Byte*) back when Blogger was popular. I eventually lost the domain and archived the blog, but I still remember the posts and content fondly.

So I built this tool to parse Blogger Google Takeout Atom feeds into clean, structured, and individual Markdown files. 

It parses Blogger posts, pages, and comments, cleans up HTML markup into strict Markdown syntax, formats metadata into YAML frontmatter, and offers options to bundle the resulting files into a single document.

Curious about why I did it and where these `.md` files are now? Check out my personal blog at [ramayac.com](https://ramayac.com), where I have published all the posts from this backup using my own blog engine, [MDBlog](https://github.com/ramayac/mdblog).

If you would like to use this tool, keep reading:

## Features

- **Multi-Format XML/Atom Support**: Works with both classic Blogger export XML files and the newer Google Takeout Blogger `feed.atom` format (primarily optimized for the Google Takeout schema).

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

- [blogger2md.py](./blogger2md.py): The main converter script containing all HTML parsing, XML extraction, and bundling logic.
- `feed.atom`: Input Blogger export files (XML format).
- `blog_posts/`: Default output directory containing individual generated markdown files.
- `big.md`: Optional bundled file containing all generated posts concatenated.

---

## Usage

You can run the script using Python 3.

```bash
python3 blogger2md.py [options]
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
| `--replace-domains` | *None* | Comma-separated list of domains to rewrite to relative paths (e.g. `myblog.blogspot.com,olddomain.com`). |

### Examples

#### 1. Export Published Posts (Default)
Export only published posts (skipping drafts and comments) into the default `blog_posts/` directory:
```bash
python3 blogger2md.py --xml feed.atom
```

#### 2. Export and Rewrite Domains to Relative Paths
Replace any absolute links pointing to your old Blogger domains with relative paths:
```bash
python3 blogger2md.py --xml feed.atom --replace-domains "myblog.blogspot.com,myblog.com"
```

#### 3. Export and Bundle into a Single File
Export all published posts and generate a single combined `big.md` file:
```bash
python3 blogger2md.py --xml feed.atom --bundle --bundle-path my_blog_archive.md
```

---

## Makefile

A `Makefile` is included for convenience. The `DOMAINS` variable controls which domains are rewritten to `/` during export and defaults to the srbyte.com family of domains.

```bash
# Export using the default DOMAINS list
make process

# Override the domain list
make process DOMAINS="myblog.blogspot.com,olddomain.com"

# Disable domain rewriting entirely
make process DOMAINS=""

# Fetch the raw XML of a specific post (useful for debugging)
make get-post id=<post_id>
```
