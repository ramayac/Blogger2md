# Default XML feed file. Fallback to feed.atom if feed.xml is not present.
XML ?= $(shell if [ -f feed.xml ]; then echo feed.xml; else echo feed.atom; fi)

.PHONY: all process change-domain get-post help

all: process

process:
	python3 blogger2md.py --xml $(XML)

change-domain:
	python3 -c "import glob, re; [open(f, 'w', encoding='utf-8').write(re.sub(r'https?://(?:www\.)?(?:srbyte|rodrigoamaya)\.(?:com|blogspot\.com|blogger\.com)/?', '/', c)) for f in glob.glob('blog_posts/*.md') for c in [open(f, 'r', encoding='utf-8').read()]]"



get-post:
	@if [ -z "$(id)" ]; then \
		echo "Error: Please provide an ID parameter, e.g., make get-post id=4730825850824856131"; \
		exit 1; \
	fi
	@python3 -c "import xml.etree.ElementTree as ET, sys; ET.register_namespace('', 'http://www.w3.org/2005/Atom'); ET.register_namespace('blogger', 'http://schemas.google.com/blogger/2018'); ET.register_namespace('app', 'http://purl.org/atom/app#'); tree = ET.parse('$(XML)'); root = tree.getroot(); ns = {'atom': 'http://www.w3.org/2005/Atom'}; posts = [ET.tostring(e, encoding='unicode') for e in root.findall('atom:entry', ns) if e.find('atom:id', ns) is not None and '$(id)' in e.find('atom:id', ns).text]; print(posts[0]) if posts else (print('Post with ID $(id) not found.', file=sys.stderr), sys.exit(1))"


help:
	@echo "Usage:"
	@echo "  make process                 - Process the Atom/XML feed file (defaults to feed.xml if present, else feed.atom)"
	@echo "  make change-domain           - Replace srbyte and rodrigoamaya domains with relative path (/) in generated files"
	@echo "  make get-post id=<post_id>   - Output the raw XML of a single post based on id (useful for debugging)"
