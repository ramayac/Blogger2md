# Agent Handover Guide (AGENTS.md)

Welcome to the SrByte blog backup project! This document serves as a guide for the next session/agent working on this repository.

## Project Context

SrByte.py is a Blogger XML/Atom export to Markdown converter written in Python. It parses XML feeds, extracts posts/comments, converts HTML to clean Markdown, and formats metadata as YAML frontmatter.

### Completed in Last Session
- **Drafts Excluded by Default**: Modified the XML parser to skip exporting drafts by default.
- **Added `--export-drafts` Flag**: Added a CLI argument `--export-drafts` to allow optional export of draft posts if requested.
- **Verified Functionality**: Ran test exports and confirmed that `0` drafts are exported without the flag, and exactly `32` drafts are exported when the flag is present in the `feed.atom` dataset.

---

## Code Overview

The codebase consists of a single python script: [srbyte.py](./srbyte.py).

### Key Functions

1. **[create_slug(text)](./srbyte.py#L8)**:
   - Converts strings to URL-friendly slugs for filenames. Normalizes whitespace, replaces special characters, and truncates to 50 characters.

2. **[clean_text_to_markdown(text)](./srbyte.py#L38)**:
   - Heavy-duty HTML-to-Markdown converter using Python's standard `re` module.
   - Cleans up structures like code blocks (`<pre>`), headings, links, blockquotes, lists, and paragraphs.
   - Standardizes image alt tags to `![image](url)` and upgrades all HTTP URLs to HTTPS.
   - Strips copyleft/copyright lines and Blogger-specific footers.

3. **[parse_blogger_xml(file_path, output_dir, include_comments, export_drafts)](./srbyte.py#L224)**:
   - The main orchestrator. Detects namespaces and handles both Blogger export XML files and the newer Google Takeout `feed.atom` schemas.
   - Extracts date, title, author, categories (converted to tags), and draft status.
   - Skips comment entries (if `include_comments` is False) and draft entries (if `export_drafts` is False).
   - Writes each entry as a `.md` file with a YAML frontmatter.

4. **[bundle_markdown_files(output_dir, bundle_path, skip_comments, skip_drafts)](./srbyte.py#L389)**:
   - Merges all `.md` files in a folder into a single file (like `big.md`), separated by `---`.

---

## Future Enhancements & Next Steps

If you are continuing development, here are several high-value next steps:

### 1. Implement Unit Tests
- Add a testing suite (`tests/` directory) using `unittest` or `pytest` to test:
  - Markdown cleaning behavior in [clean_text_to_markdown](./srbyte.py#L38) for various HTML tags.
  - Slug generation stability in [create_slug](./srbyte.py#L8).
  - Draft skipping logic under different namespaces.

### 2. Download and Localize Media
- Currently, image URLs point to the original Blogger/Google hostnames.
- Enhancement: Download these images locally to an `images/` folder and rewrite the markdown image references (e.g. `![image](images/some-slug.jpg)`) to make the archive fully self-contained.

### 3. Replace Regex Parser with BeautifulSoup
- The regex-based HTML-to-Markdown parser is lightweight but can be fragile for complex nested HTML tags.
- Consider refactoring [clean_text_to_markdown](./srbyte.py#L38) to use `BeautifulSoup` (`bs4`) for safer HTML tree traversal and conversion.

### 4. Custom Frontmatter Formatting
- Allow passing custom YAML frontmatter templates via command-line options or a config file (e.g., to support different static site generators like Hugo, Jekyll, or Astro).
