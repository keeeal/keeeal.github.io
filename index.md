---
layout: default
---

# Recent Posts
###### Welcome to my blog

{% for post in site.posts %}
## <a style="color: inherit" href="{{ post.url }}">{{ post.title }}</a>
{{ post.excerpt }}
{% endfor %}
