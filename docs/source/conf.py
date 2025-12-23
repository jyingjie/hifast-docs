# Configuration file for the Sphinx documentation builder.

# -- Project information

import os
import sys


# more options https://github.com/pydata/pydata-sphinx-theme/blob/main/docs/conf.py

sys.path.append(os.path.abspath("./_ext"))

project = 'HiFAST'
copyright = '2021-->>>>>>>>>>>, HiFAST developers'
author = 'HiFAST developers'

release = 'v1.4'
version = 'v1.4'

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
    'sphinxarg.ext',
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

html_theme = "pydata_sphinx_theme"

html_static_path = ['_static',]

# will be put in :/
html_extra_path = ['_files/']
exclude_patterns = ['_build', '_files/**', '**/RAW_data']
# "ln -s _files/files files" for dirlist

# for nbsphinx
html_sourcelink_suffix = ''
# Fix "Mismatched anonymous define() module" error.
# nbsphinx loads require.js for ipywidgets, which conflicts with D3.js (used by Mermaid).
# Disabling require.js resolves the error but breaks ipywidgets.
# If ipywidgets are needed in the future, remove this line and use an AMD workaround.
nbsphinx_requirejs_path = ''

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

# html_logo = "_static/img/logo-preview.png"
# html_title = "HiFAST"

html_favicon = "_static/img/hifast_logo_only.png"

# Define the json_url for our version switcher.
json_url = "https://hifast.readthedocs.io/en/latest/_static/versions.json"

# Define the version we use for matching in the version switcher.
version_match = os.environ.get("READTHEDOCS_VERSION")
# If it's "latest" → change to "dev" (that's what we want the switcher to call it)
if not version_match or version_match.isdigit() or version_match == "latest":
    # For local development, infer the version to match from the package.
    if "dev" in release or "rc" in release:
        version_match = "dev"
        # We want to keep the relative reference if we are in dev mode
        # but we want the whole url if we are effectively in a released version
        json_url = "_static/versions.json"
    else:
        version_match = release

html_theme_options = {
    "header_links_before_dropdown": 7,
    "show_nav_level": 2,
    "navigation_depth": 4,
    "switcher": {
        "json_url": json_url,
        "version_match": version_match,
    },
    "navbar_start": ["navbar-logo", "version-switcher"],
    "logo": {
        "text": "HiFAST",
        "image_light": "_static/img/hifast_logo_only.png",
        "image_dark": "_static/img/hifast_logo_only.png",
    },
    # "logo_only": False,
    "display_version": True,
}
