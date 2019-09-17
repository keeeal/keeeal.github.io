---
layout: default
---

# Posts
###### Welcome to my blog

{% for post in site.posts %}
## <a href="{{ post.url }}">{{ post.title }}</a>
{{ post.excerpt }}
{% endfor %}
