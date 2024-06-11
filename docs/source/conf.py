# Configuration file for the Sphinx documentation builder.

# -- Project information

import os
import sys

sys.path.append(os.path.abspath("./_ext"))

project = 'HiFAST'
copyright = '2021-->>>>>>>>>>>, HiFAST developers'
author = 'HiFAST developers'

release = ''
version = ''

# html_logo = "img/logo.svg"
# html_theme_options = {
#     "logo_only": True,
#     "display_version": True,
# }

# -- General configuration

extensions = [
    'sphinx.ext.duration',
    'sphinx.ext.doctest',
    'sphinx.ext.autodoc',
    'sphinx.ext.autosummary',
    'sphinx.ext.intersphinx',
    'dirlist',
    'nbsphinx',
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

# will be put in :/
html_extra_path = ['_files/']
exclude_patterns = ['_build', '_files/**', '**/RAW_data']
# "ln -s _files/files files" for dirlist

# for nbsphinx
html_sourcelink_suffix = ''

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
language = 'en'
locale_dirs = ['locales/']
gettext_uuid = True
gettext_compact = False

html_logo = "_static/img/logo-preview.png"
html_theme_options = {
    'logo_only': True,
    'display_version': True,
}