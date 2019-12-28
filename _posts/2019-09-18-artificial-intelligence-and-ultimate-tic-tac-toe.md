---
layout: post
tags: UT3
---

You probably already know how to play the original version of [tic-tac-toe](https://en.wikipedia.org/wiki/Tic-tac-toe). Well ultimate tic-tac-toe is similar, except that each square on the board contains another, smaller game of tic-tac-toe! Let's call the big game the "macro game" and the small games "micro games". A player must win micro games to claim corresponding squares in the macro game. The goal is to win three micro games in a row. Simple, right?

Not so fast! There is a catch. The most important rule of ultimate tic-tac-toe is the following: The square you pick dictates the next micro game your opponent must play in. Specifically, whichever row and column you choose to play in a micro game is the row and column of the macro game your opponent is forced to play in next. So, for example, if you are first to move and you choose the middle square in any one of the micro games, your opponent must make their next move in the middle of the macro game. If this is confusing, take a look at Figure 1. Highlighted squares indicate where the current player is permitted to play.

![ultimate tic-tac-toe gif](/img/ut3.gif)
###### Figure 1: A game of ultimate tic-tac-toe in progress. [[source]](https://playground.riddles.io/competitions/ultimate-tic-tac-toe/how-to-play)

But what happens if your opponent sends you to a micro game that has already been won, or is full? Well then you are in luck! If this happens you are allowed to place your next move on any empty square on the entire board.

And that's it! The game is won when three micro games are won in a row, either horizontally, vertically, or diagonally. The game ends in a draw if all micro games are over and no three in a row have been won by the same player.
