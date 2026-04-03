---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults
layout: home
title: "Software projects"
order: 1
---

{% assign sorted_research_tools = site.research_tools | sort: 'title' %}
{% assign sorted_obsidian_plugins = site.obsidian_plugins | sort: 'title' %}
{% assign sorted_emacs = site.emacs | sort: 'title' %}
{% assign sorted_python_packages = site.python_packages | sort: 'title' %}
{% assign sorted_launchbar_plugins = site.launchbar_plugins | sort: 'title' %}
{% assign sorted_sublime_plugins = site.sublime_plugins | sort: 'title' %}
{% assign sorted_macos_utils = site.macos_utils | sort: 'ranking' %}
{% assign sorted_shell_plugins = site.shell_plugins | sort: 'title' %}

Welcome to Andrea Alberti's personal page. Below, you find a list of projects I have been currently maintaining in my pastime.

## macOS Utilities
{% for project in sorted_macos_utils %}
{% assign repo_name = project.link | split: "/" | last %}
- **[{{ project.title }}]({{ project.link }})** [![Stars](https://img.shields.io/github/stars/{{ site.github_username }}/{{ repo_name }}?style=flat-square&label=%E2%98%85&color=dfb317)]({{ project.link }}/stargazers): {{ project.description }}
{% endfor %}

## Shell Plugins

These are plugins developed to improve the workflow with [Zsh](https://www.zsh.org/) shell and [Tmux](https://github.com/tmux/tmux).

{% for project in sorted_shell_plugins %}
{% assign repo_name = project.link | split: "/" | last %}
- **[{{ project.title }}]({{ project.link }})** [![Stars](https://img.shields.io/github/stars/{{ site.github_username }}/{{ repo_name }}?style=flat-square&label=%E2%98%85&color=dfb317)]({{ project.link }}/stargazers): {{ project.description }}
{% endfor %}

## Obsidian Plugins

These are plugins developed to improve the workflow with [Obsidian](https://obsidian.md/) personal knowledge management system.

{% for project in sorted_obsidian_plugins %}
{% assign repo_name = project.link | split: "/" | last %}
- **[{{ project.title }}]({{ project.link }})** [![Stars](https://img.shields.io/github/stars/{{ site.github_username }}/{{ repo_name }}?style=flat-square&label=%E2%98%85&color=dfb317)]({{ project.link }}/stargazers): {{ project.description }}
{% endfor %}

## Emacs Contributions

These are packages and other types of contributions developed to improve the workflow with [Emacs](https://www.gnu.org/software/emacs/).

{% for project in sorted_emacs %}
{% assign repo_name = project.link | split: "/" | last %}
- **[{{ project.title }}]({{ project.link }})** [![Stars](https://img.shields.io/github/stars/{{ site.github_username }}/{{ repo_name }}?style=flat-square&label=%E2%98%85&color=dfb317)]({{ project.link }}/stargazers): {{ project.description }}
{% endfor %}

## LaunchBar Actions

These are plugins developed to improve the workflow with [LaunchBar](https://www.obdev.at/products/launchbar/index.html) personal knowledge management system.

{% for project in sorted_launchbar_plugins %}
{% assign repo_name = project.link | split: "/" | last %}
- **[{{ project.title }}]({{ project.link }})** [![Stars](https://img.shields.io/github/stars/{{ site.github_username }}/{{ repo_name }}?style=flat-square&label=%E2%98%85&color=dfb317)]({{ project.link }}/stargazers): {{ project.description }}
{% endfor %}

## Python Packages

These are Python packages developed to improve the workflow in scientific computing and scientific automation:

{% for project in sorted_python_packages %}
{% assign repo_name = project.link | split: "/" | last %}
- **[{{ project.title }}]({{ project.link }})** [![Stars](https://img.shields.io/github/stars/{{ site.github_username }}/{{ repo_name }}?style=flat-square&label=%E2%98%85&color=dfb317)]({{ project.link }}/stargazers): {{ project.description }}
{% endfor %}

## Sublime Text Editor Plugins
{% for project in sorted_sublime_plugins %}
{% assign repo_name = project.link | split: "/" | last %}
- **[{{ project.title }}]({{ project.link }})** [![Stars](https://img.shields.io/github/stars/{{ site.github_username }}/{{ repo_name }}?style=flat-square&label=%E2%98%85&color=dfb317)]({{ project.link }}/stargazers): {{ project.description }}
{% endfor %}

## Research Tools
{% for project in sorted_research_tools %}
{% assign repo_name = project.link | split: "/" | last %}
- **[{{ project.title }}]({{ project.link }})** [![Stars](https://img.shields.io/github/stars/{{ site.github_username }}/{{ repo_name }}?style=flat-square&label=%E2%98%85&color=dfb317)]({{ project.link }}/stargazers): {{ project.description }}
{% endfor %}
