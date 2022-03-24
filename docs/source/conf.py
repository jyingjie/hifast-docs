# Configuration file for the Sphinx documentation builder.

# -- Project information

project = 'HIFAST'
copyright = '2021, HIFAST'
author = 'HIFAST developers'

release = '1.1'
version = '1.1.0'

# -- General configuration

extensions = [
    'sphinx.ext.duration',
    'sphinx.ext.doctest',
    'sphinx.ext.autodoc',
    'sphinx.ext.autosummary',
    'sphinx.ext.intersphinx',
]

intersphinx_mapping = {
    'python': ('https://docs.python.org/3/', None),
    'sphinx': ('https://www.sphinx-doc.org/en/master/', None),
}
intersphinx_disabled_domains = ['std']

templates_path = ['_templates']

# -- Options for HTML output

html_theme = 'sphinx_rtd_theme'

html_static_path = ['_static',]
html_css_files = [
    'css/custom.css',
]

rst_prolog = """
.. role:: strike
   :class: strike
"""
# usage:
# .. :strike:`test`
# or
# .. container:: strike
#    test


# -- Options for EPUB output
epub_show_urls = 'footnote'


