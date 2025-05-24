-- mod-version:3
local ptm = require 'plugins.ptm'

-- Template Reference
-- ?

-- This module installs several templates:
-- 1. LaTeX, article (line 20)
-- 2. LaTeX, book (line 83)
-- 3. LaTeX, presentation (line )
-- 4. LaTeX, cv (line )

local file_run = [[
pdflatex main.tex
pdflatex main.tex
evince main.pdf
rm -v main.aux main.toc main.log
]]

-- LaTeX, article
local file_article = [[
\documentclass[12pt]{article}

\usepackage[english]{babel} % multilingual support
\usepackage[utf8]{inputenc} % encoding
\usepackage{blindtext} % to insert blind text

% page layout
\usepackage{geometry}
\geometry{a4paper, portrait, scale=1.0, margin=2cm}

% page style
\pagestyle{empty}

% fonts
\usepackage[T1]{fontenc}
\usepackage[default]{cantarell}

% opening
\title{Article}
\author{author}
\date{April 2022}

\begin{document}

\maketitle
\tableofcontents

\begin{abstract}
	Abstract.
\end{abstract}

\section{Prima Sezione}
Prima sezione.

\subsection{Prima Sottosezione}
Prima sottosezione

\end{document}
]]

ptm.add_template() {
  name = "latex-article",
  desc = "A basic latex article",
  files = {
    ["run.sh"] = {
      path = "",
      content = file_run
    },
    ["main.tex"] = {
      path = "",
      content = file_article
    }
  },
  dirs = {},
  ext_libs = {},
  lsp_config_files = {},
  commands = {
    { "chmod", "+x", "run.sh" }
  }
}

-- LaTeX, book

-- LaTeX, presentation

-- LaTeX, cv

