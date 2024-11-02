---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults
layout: home
title: "Projects"
---

{% assign sorted_research_tools = site.research_tools | sort: 'title' %}
{% assign sorted_obsidian_plugins = site.obsidian_plugins | sort: 'title' %}
{% assign sorted_macos_utils = site.macos_utils | sort: 'ranking' %}

Welcome to the personal Andrea's personal page. Below, you find a list of projects I have been currently maintaining in my past time.

## Research Tools
{% for project in site.research_tools %}
- **[{{ project.title }}]({{ project.link }})**: {{ project.description }}
{% endfor %}

## Obsidian Plugins
{% for project in sorted_obsidian_plugins %}
- **[{{ project.title }}]({{ project.link }})**: {{ project.description }}
{% endfor %}

## macOS Utilities
{% for project in sorted_macos_utils %}
- **[{{ project.title }}]({{ project.link }})**: {{ project.description }}
{% endfor %}


