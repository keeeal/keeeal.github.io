---
layout: default
title: "Temporal difference learning for ultimate tic-tac-toe"
tags: temporal difference, ultimate tic-tac-toe
---

[repo]: https://github.com/keeeal/temporal-ut3

# Temporal difference learning for ultimate tic-tac-toe
###### 4 June 2019

In this post I will describe an implementation of temporal difference learning that can be found [here][repo]. This amazingly simple algorithm is able to learn entirely through self-play without *any* human knowledge at all, except the rules of the game. By way of example, we will be training the algorithm to play [ultimate tic-tac-toe](https://en.wikipedia.org/wiki/Ultimate_tic-tac-toe), but the same algorithm can be applied to almost any other game with varying degrees of success. This post will assume some familiarity with machine learning and reinforcement learning concepts, and should be accessible if you understand the basics of supervised learning with neural networks.

## What is ultimate tic-tac-toe?

Let's start with the game. You probably know the original version of [tic-tac-toe](https://en.wikipedia.org/wiki/Tic-tac-toe). Well ultimate tic-tac-toe is similar, except that each of the nine squares contain another smaller game of tic-tac-toe! We'll call the big game the "macro game" and the smaller games "micro games". A player must win micro games to claim corresponding squares in the macro game, the goal being to win three micro games in a row. Simple, right?

Not so fast, there is a catch! The most important rule of ultimate tic-tac-toe is the following: The small square you pick dictates the next micro game your opponent must play in. Specifically, whichever row and column you choose to play in a micro game, your opponent is forced to play in the corresponding row and column of the macro game. So for example, if you are first to move and you choose the middle square in any one of the micro games, your opponent must then play in the middle of the macro game. If this is confusing, take a look at Figure 1. Highlighted squares indicate where the current player is permitted to play.

![ultimate tic-tac-toe gif](/img/ut3.gif)
###### Figure 1: A game of ultimate tic-tac-toe in progress. [[source]](https://playground.riddles.io/competitions/ultimate-tic-tac-toe/how-to-play)

But what happens if your opponent sends you to a micro game that has already been won, or is full? Then you are in luck! If this happens you are allowed to place your next move on any empty square on the entire board.

That's it. The game is won when three micro games are won in a row, either horizontally, vertically, or diagonally. The game ends in a draw if all micro games are over and no three in a row are owned by the same player.

## What is temporal difference learning?

Temporal difference (TD) learning is a reinforcement learning algorithm trained only using self-play. The algorithm learns by bootstrapping from the current estimate of the value function, i.e. the value of a state is updated based on the current estimate of the value of future states. [Read more...](https://en.wikipedia.org/wiki/Temporal_difference_learning)

## How to use

### Training

To begin training:

```bash
python train.py
```

or set the learning hyperparameters using any of the optional arguments:

```bash
python train.py --lr LEARN_RATE --a ALPHA --e EPSILON
```

### Playing

You can play against a trained model using

```bash
python player.py --params path/to/parameters.params
```

If no parameters are provided, the opponent will make moves randomly.

## Experiments

![ultimate tic-tac-toe results](/img/td-ut3-results.png)

Coming soon.

## To-do
 - [Scale the value of terminal results by the game length to prefer shorter games](https://medium.com/oracledevs/lessons-from-alphazero-connect-four-e4a0ae82af68).
 - Implement UT3 neural network in other frameworks, eg: TensorFlow.
 - Make asynchronous, i.e. do self-play, neural net training and model comparison in parallel.

## Requirements
 - [PyTorch](https://pytorch.org/)
 - [Progress](https://pypi.org/project/progress/)

## Thanks
 - [Sam Culley](https://github.com/swculley)
