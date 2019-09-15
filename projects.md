---
layout: default
---
<!-- <img class="profile-picture" src="/img/projects.jpg"> -->

# Projects
###### Use the links below to read about some of the projects I've been working on.

{% assign projects =
"Beamz: Using deterministic fluids estimation to encode parameters of a radiation beam: I used these inputs to train a neural net to produce Monte Carlo-derived dose-distributions in artificial geometries. This network was then used in a patient sample with moderate success.,
Dosenet: A faster way to radiate: Calculating radiation dose as quickly as Collapsed Cone Convolution, but as accurately as Monte Carlo.,
Koi: There's always a bigger fish: Koi is a project that uses a continuous genetic algorithm to optimise the neural movement-based decision-making of fish in a pond.,
Hyperforest: T,he descent: I heard that you like dimensions, so I put a dimension inside your dimension. Two doesn’t cut it for you?  Have a third. More like three doesn’t cut it. Have a forth. Hyper Forest is a 2D render of a 3D slice of a 4D world. Welcome to the descent.,
Lifebot: I. Have. Decision. Fatigue.: Lifebot was only ever supposed to be a personal project. I tried to turn depression into a technical problem so that I could solve it. Life has a high degree of equifinality. It didn’t matter when I did it so I just didn’t. Now the bot tells me when to do it and now I’m… fine I guess. Full Disclosure: I do not recommend this bot. Just go outside.,
Bendy Men: \*Northern Running Figures: Style can only exist in the context of other styles. I made a bot that compares things and produced a relative special-temporal chronology for indigenous rock art on the basis of indigenous art from the Northern Arnhem Lands.,
AlphaPilot: Let the robot take the wheel: Phase 1: Previous authors have achieved AI piloted flat drone flight - we will replicate this. Phase 2: We will give the AI more directions.,
Stemusicians: Robots CAN make beautiful masterpieces: Pose estimation via videography as an input for a neural net, output to Project Magenta to make some banging tunes.,
ut3: Ultimate tic-tac-toe: Living vicariously through algorithms because I don't have time to play video games anymore."
| split: ",
" %}

{% for project in projects %}
{% assign foo, bar = project | split: ": " %}
## {{ foo[0] }}
{{ foo[1] }}
{% for tag in site.tags %}
{% if tag[0] == foo[0] %}
<ul>
  {% for post in tag[1] %}
    <li><a href="{{ post.url }}">{{ post.title }}</a></li>
  {% endfor %}
</ul>
{% endif %}
{% endfor %}
{% endfor %}
