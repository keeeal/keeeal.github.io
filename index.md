---
layout: default
title: Recent Posts
---

# {{ page.title }}
###### Welcome to my blog.

{% for post in site.posts %}
## <a style="color: inherit" href="{{ post.url }}">{{ post.title }}</a>
<small>{{ post.date | date_to_long_string }}</small>
{{ post.excerpt }}
{% endfor %}
