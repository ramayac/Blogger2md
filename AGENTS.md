# Agent Handover Guide (AGENTS.md)

Welcome to the SrByte blog backup project! This document serves as a guide for the next session/agent working on this repository.

## Project Context

blogger2md.py is a Blogger XML/Atom export to Markdown converter written in Python. It parses XML feeds, extracts posts/comments, converts HTML to clean Markdown, and formats metadata as YAML frontmatter.

Focus only on blogger2md.py and the README.md for now, as they contain the core logic and documentation. The README provides an overview of features, usage instructions, and future enhancement ideas.

Keep it simple, focus on the only purpose of this project: converting Blogger exports to Markdown files. Avoid adding unrelated features or overcomplicating the codebase.

KISS (Keep It Simple, Stupid) is the guiding principle here. The code should be straightforward, easy to understand, and maintainable for future contributors.

Don't assume, don't over-engineer, and don't add unnecessary complexity. The goal is to have a clean, functional script that does one thing well: convert Blogger XML/Atom feeds into Markdown files.

### Completed in Last Session
- **Drafts Excluded by Default**: Modified the XML parser to skip exporting drafts by default.
- **Added `--export-drafts` Flag**: Added a CLI argument `--export-drafts` to allow optional export of draft posts if requested.
- **Verified Functionality**: Ran test exports and confirmed that `0` drafts are exported without the flag, and exactly `32` drafts are exported when the flag is present in the `feed.atom` dataset.
- **Ensure Blank Line Before Images**: Added logic to ensure a blank line is formatted before every `![image](url)` markdown image.


---

## Code Overview

The codebase consists of a single python script: [blogger2md.py](./blogger2md.py).

### Key Functions

1. **[create_slug(text)](./blogger2md.py#L8)**:
   - Converts strings to URL-friendly slugs for filenames. Normalizes whitespace, replaces special characters, and truncates to 50 characters.

2. **[clean_text_to_markdown(text)](./blogger2md.py#L38)**:
   - Heavy-duty HTML-to-Markdown converter using Python's standard `re` module.
   - Cleans up structures like code blocks (`<pre>`), headings, links, blockquotes, lists, and paragraphs.
   - Standardizes image alt tags to `![image](url)` and upgrades all HTTP URLs to HTTPS.
   - Strips copyleft/copyright lines and Blogger-specific footers.

3. **[parse_blogger_xml(file_path, output_dir, include_comments, export_drafts)](./blogger2md.py#L224)**:
   - The main orchestrator. Detects namespaces and handles both Blogger export XML files and the newer Google Takeout `feed.atom` schemas.
   - Extracts date, title, author, categories (converted to tags), and draft status.
   - Skips comment entries (if `include_comments` is False) and draft entries (if `export_drafts` is False).
   - Writes each entry as a `.md` file with a YAML frontmatter.

4. **[bundle_markdown_files(output_dir, bundle_path, skip_comments, skip_drafts)](./blogger2md.py#L389)**:
   - Merges all `.md` files in a folder into a single file (like `big.md`), separated by `---`.

---

## Makefile Targets

A [Makefile](./Makefile) is provided to simplify common tasks:

- **`make process`**: Parses the feed XML file (automatically uses `feed.xml` if present, otherwise falls back to `feed.atom`).
- **`make change-domain`**: Replaces the `srbyte.com` and `www.srbyte.com` domains with relative paths (`/`) inside all generated markdown files.
- **`make get-post id=<post_id>`**: Extracts and outputs the raw XML for a specific post based on its ID parameter (extremely useful for debugging).

