---
layout: post
tags: UT3
---

A friend of mine is making a game called Chicken Wings - an energetic side-scroller where the protagonist, an ambitious chicken with lofty aspirations of space travel, need to avoid various obstacles and collect corn. In this post I will describe Proavis, the algorithm I built to play this game.

(picture of chicken)

Chicken Wings was made for a research project and one day it will be sent to a large cohort of research participants. But before this happens, it is important to make sure tht the game is playable and consistent. So, to do this, my friend asked a few people, myself included, to play test the game and quantify the of difficulty each level. I gave it a few goes but I wasn't much help. Let's just say video games aren't my forte. If I was going to help in any meaningful way I would have to automate the game testing process. So I made an evolutionary algorithm to play Chicken Wings. Here is how it works.

## The Algorithm

An evolutionary algorithm improves upon a population of potential solutions to a problem by applying a form of natural selection. In my case by "solutions" to a "problem" I mean attempts at playing a particular level of Chicken Wings. Since Chicken Wings can be played using only the mouse, this means an entire solution can be encoded as nothing more than a sequence of clicks. This means that our task as a player is to find the precise sequence of mouse clicks which, when provided one at a time, beat the level in the optimal manner. Note: This is only possible because one level of Chicken Wings is deterministic, not randomly generated. The evolutionary algorithm has no way of seeing the screen so lacks any ability to react to dynamic enemies.

An attempt at playing the level is referred to as an individual. An individual is defined by its genome: A list of values that correspond to mouse actions. There are three possible mouse actions, each with a unique value: 1 = click, 0 = hold, and -1 = release. Having defined our individuals, the first step in most evolutionary algorithms is to generate an initial population of individuals, each having some fixed length and being filled with random values.

This is where Proavis differs. In this algorithm, individuals begin empty. The reason for this will become clear later. Our initial population is therefore a list of empty lists. If our population size is 64, then there are 64 empty lists in our initial population. From this point, like almost all evolutionary algorithms, optimization relies on four steps: Evaluation, selection, crossover, and mutation.

### Evaluation

The purpose of this step is to determine the fitness value of an individual. Evaluation requires an attempt at the level to be made and the resulting score recorded. To implement this I used pyautogui, a package for automated mouse and keyboard control. From a given individual, elements were read one at a time and their corresponding action executed.

This works fine until the elements run out. In particular, for our initial population of empty lists, the elements run out immediately. So what should we do in this case? Well, if the elements in an individual run out and the game is not over yet, we just randomly generate new elements on the fly (no pun intended). These new elements were given equal probability of being -1, 0, or 1. These elements were recorded as they are executed and added to the end of the individual. After this, the individual has new genetic information that it didn't have when evaluation began. The converse of this is if an individual with, say, 100 elements only executes 80 of them before colliding with an obstacle. In this case the remaining 20 elements that were never executed are removed before continuing.

The end result of evaluation is that each individual only consists of it's executable portion and has been assigned a fitness value. The fitness value, by the way, was simply taken to be the in-game score at the time of death, taken directly from the game files. Score in Chicken Wings is a function of both the distance travelled and the number of corn cobs collected.

### Selection

The purpose of selection is to use the previously assigned fitness values to apply selection pressure. In a probabilistic manner, individuals with a higher fitness should propagate more often, passing their genome to the next generation, while those with a lower fitness should not. In Proavis, this is implemented using standard tournament selection. For each member of the next generation, N individuals from the last generation are chosen at random and only the fittest of these N goes through to the next generation. N may be considered the degree of selection pressure and, in our case, N was set to 3.

### Crossover

Crossover commonly used to explore new possibilities by mating two individuals together. The individuals created through this process get part of their genome from each of their parents and (hopefully) become better than either one of them. For example, the start of parent A's sequence may be more optimal that that of parent B, but parent B may have a more favorable end section. It is common practice, therefore, to create two new children by breaking both of the parents at a randomly chosen point and then swapping their tails.

![equation-1](/img/proavis-001.png)

However, this where the Proavis algorithm differs once again. You see, after the evaluation step is complete, one thing is true of all individuals in the population: They met their demise at the end of their genome. This is true because any elements that were not executed were ultimately removed from the individual. We know then, that every element in an individual proved successful at navigating the level until, near the very end, a relatively small number of misguided clicks caused the run to end. Intuitively then, it is the end of the individual that requires the most attention.

For this reason, the Proavis algorithm uses a crossover point chosen randomly but not uniformly. Instead, a strong bias was introduced to encourage exploration of the solution space near the end of a given individual. The equation of the probability distribution is as follows:

![equation-1](/img/proavis-002.png)

where n is the length of the individual and b is a parameter that controls the degree of bias.

This distribution has some favorable features. Firstly, on the domain of indices corresponding to elements in the individual (i.e. from 0 to n), the function ranges from 0 to 1. It is also monotonically increasing, with an exponential slope dictated by b. Finally, and perhaps most importantly, since the function is exponential it is self-similar for a given set of indices preceding n, e.g. between n - 10 and n, regardless of the value taken by n. This means that the parameter b dictates the probability of selecting index i, depending on the distance i is from n.

The distribution was sampled by setting p equal to a uniform random number from [0, 1) and finding x:

![equation-2](/img/proavis-003.png)

This point was then used as the crossover point. The parameter b must be larger than 1. A suitable value was found to be 1.02.

### Mutation

The final step required for a genetic algorithm is mutation. This operator introduces new genetic material to the population that may not be present in any one of the existing parents. A common way to do this is to visit an individual and, with some likelihood, randomize each element independently.

![equation-2](/img/proavis-004.png)

Once again, performing this operation with an equal likelihood everywhere does not serve the Proavis algorithm well. Mutations are particularly important near the end of an individual's sequence, where improvements must be made to overcome run-ending obstacles. This is difficult, however, if such a mutation can only occur while also mutating earlier elements.

Instead, by using the same probability distribution as described for crossover, a point was chosen in the individual with a strong bias towards points near the end of the sequence. Mutation was then applied only to elements that follow this point. This allowed points near the end of the individual, where a change is required, to be modified without impacting previous points and causing the individual's premature death.

### Notes

The algorithm was implemented using the Python package "DEAP". The probability of an individual being crossed with another was 50%. The probability of an individual being mutated was 20%, at which point the probability of each element being mutated was the equation for p, scaled by a factor of 0.1. Population size was 64. For my friend's research project, x and y coordinates of death were recorded, along with the number of attempts required to get past each obstacle.

## Results

Coming soon :)

