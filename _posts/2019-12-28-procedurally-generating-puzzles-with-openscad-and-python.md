---
layout: post
tags: Misc python openscad
---

This post describes how I used OpenSCAD and Python to create a randomly generated puzzle cube.

![puzzle-cube](https://i.imgur.com/PfvlCmF.png)

I wrote the code for this project as an exercise in procedurally generate 3D-printable objects. The algorithm produces six pieces that fit together to form a cube. The pieces are presented in a disassembled form so the user can have the satisfaction of solving the puzzle!

## The algorithm

The algorithm begins by creating an array oz zeros with the same shape as the completed puzzle. To illustrate, let our puzzle be a 4×4×4 cube:

![puzzle-cube-001](/img/puzzle-cube-001.png)

```
x, y, z = shape
  face_values = (1, 2), (3, 4), (5, 6)
  array = np.pad(np.zeros((x - 2, y - 2, z - 2)), 1,
    constant_values=face_values)
```

Each side is given a value from one to six and non-edge elements are numbered accordingly:

![puzzle-cube-002](/img/puzzle-cube-002.png)

Along each edge, elements are randomly set equal to one of the faces they are adjacent to:

![puzzle-cube-003](/img/puzzle-cube-003.png)

Finally, corner values are chosen randomly from the value of adjacent edge elements. This ensures that each corner remains connected to a puzzle piece.

![puzzle-cube-004](/img/puzzle-cube-004.png)
