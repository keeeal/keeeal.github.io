---
layout: post
tags: Misc python openscad
---

This post describes a project in which I used OpenSCAD and Python to create a randomly generated puzzle cube.

![puzzle-cube](https://i.imgur.com/PfvlCmF.png)

I wrote this code as an exercise in procedurally generating 3D-printable objects. The algorithm produces six pieces that fit together to form a cube. Since the puzzle is randomly generated, the user is not aware of the solution. This means that even the puzzle's creator can have the satisfaction of solving it for themselves!

## The algorithm

The algorithm begins by creating an array of zeros with the same shape as the completed puzzle. To illustrate, let our puzzle be a 4×4×4 cube, which can be visualised like this:

![puzzle-cube-001](/img/puzzle-cube-001.png)

### Faces values

Each face of the puzzle cube must be numbered. The numbers themselves don't matter as long as they are non-zero and unique. The value of array elements in the centre of each face are set accordingly, since there is only one puzzle piece that they can belong to. Edge and corner elements can be ignored for now. In our visualisation we can use colours to represent each face's value:

![puzzle-cube-002](/img/puzzle-cube-002.png)

Everything described so far can be done (using numpy) with just a few lines of code:

```python
x, y, z = shape
face_values = (1, 2), (3, 4), (5, 6)
array = np.pad(np.zeros((x - 2, y - 2, z - 2)), 1,
    constant_values=face_values)
```

### Edge values

The edges of the puzzle are the interesting part; The way that they fit together is what makes it a puzzle at all! Along each edge of the puzzle, element values must be chosen at random. There are only two possible values that they can take: the values of the faces that meet at the edge.

Since the puzzle is a cube, there are a total of 12 edges to be considered. We can iterate through them by first considering each of the 3 axes (*x*, *y*, and *z*). For each axis, we then consider the index extremes of the other two — denoted in python as 0 and -1 — and iterate through all 4 possible combinations. The final trick is using numpy's random choice function and indexing to give values to each edge all at once! The code for this is provided below:

```python
for axis in range(3):
    ends = 3*[(0, -1)]
    ends[axis] = (slice(None),)
    for idx in product(*ends):
        array[idx] = np.random.choice((
            face_values[axis - 1][idx[axis - 1]],
            face_values[axis - 2][idx[axis - 2]],
        ), shape[axis])
```

After all edge values have been chosen, the array should look something like this:

![puzzle-cube-003](/img/puzzle-cube-003.png)

### Corner values

Finally, we must provide values to the array's corner elements. But hang on, weren't the corners given random values in the last step? Why are those values not good enough? Well, the reason is twofold. The last step only considered the values of two faces that meet at the edge, while at a corner there are three. More importantly, however, it is currently possible for a corner element to be disconnected from its face! Consider the following example:

![puzzle-cube-004](/img/puzzle-cube-004.png)

The element in the top right corner is not connected to the rest of the green-coloured face! To solve this, we must choose the value of each corner randomly from the value of neighbouring elements. This ensures that each corner remains connected to a puzzle piece.

In code, we visit each of the 8 corners by again considering the index extremes of each axis. A delta array provides a way of iterating through all neighbouring elements. A python set is used to ensure that having two neighbours of the same value doesn't double the probabilty of that value being chosen, although this is not strictly necessary. The code is as follows:

```python
for idx in product((0, -1), (0, -1), (0, -1)):
    delta = np.copysign(np.eye(3), idx).astype(np.int)
    array[idx] = np.random.choice(
        list(set(array[tuple(idx + i)] for i in delta)))
```

By this point the array should look like this:

![puzzle-cube-005](/img/puzzle-cube-005.png)

A completed puzzle!

### Getting each face

```python
faces = []
for n, (axis, end) in enumerate(product(range(3), (0, -1))):
    idx = 3*[slice(None)]
    idx[axis] = end
    faces.append(array[tuple(idx)] == n + 1)
```

### Saving each face

```python
def save(obj, name, stl=False):
    scad_render_to_file(obj, name + '.scad')
    if stl:
        call(['openscad', name + '.scad', '-o', name + '.stl'])
        remove(name + '.scad')
```

```python
for n, face in enumerate(faces):
    piece = union()
    for i, row in enumerate(face):
        for j, value in enumerate(row):
            if value:
                piece += translate([10*i, 10*j, 0])(cube([10, 10, 10]))

    save(piece, 'piece_' + str(n), stl=stl)
```
