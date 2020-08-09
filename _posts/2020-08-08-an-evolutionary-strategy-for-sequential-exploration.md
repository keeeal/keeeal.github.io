---
layout: post
tags: UT3
---

A friend of mine is making a game called Chicken Wings - an energetic side-scroller where the protagonist, an ambitious chicken with lofty aspirations of space travel, needs to avoid various obstacles and collect corn. In this post I describe Proavis, the algorithm I made to play it.

![chicken-wings](/img/proavis-000.gif)
###### Figure 1: A chicken with big dreams.

Chicken Wings was made for a research project and one day it will be sent to a cohort of research participants. Before this happens though, it is important to make sure the game is playable and consistent. So, to do this, my friend asked a few people including myself to play test his game and report the difficulty. I gave it a few goes but I wasn't much help. Let's just say video games aren't my thing. If I was going to help in any meaningful way I would have to automate the game testing process. So I made an evolutionary algorithm to play Chicken Wings. Here is how it works.

## The Algorithm

An evolutionary algorithm improves upon a population of potential solutions to a problem by applying a form of natural selection. In my case, by "solutions" to a "problem" I mean attempts at playing a level of Chicken Wings. Since Chicken Wings can be played using only the mouse, this means an entire solution can be encoded as nothing more than a sequence of clicks. Our task as a player is to find the precise sequence of mouse clicks which, when provided one at a time, beat the level. (Note: This is only possible because one level of Chicken Wings is deterministic, not randomly generated. The evolutionary algorithm has no way of seeing the screen so lacks any ability to react to dynamic enemies.)

An attempt at playing the level is referred to as an individual. An individual is defined by its genome: A list of values that correspond to mouse actions. There are three possible mouse actions to consider, each encoded with a unique value: 1 = click, 0 = hold, and -1 = release. Having defined our individuals, the first step in most evolutionary algorithms is to generate an initial population of individuals, each having some fixed length and being filled with random values.

This is where Proavis differs. In this algorithm, individuals begin empty. The reason for this will become clear later. Our initial population is therefore a list of empty lists. If our population size is 64 then there are 64 empty lists in our initial population. From this point, like almost all evolutionary algorithms, optimization relies on four steps: Evaluation, selection, crossover, and mutation.

### Evaluation

The purpose of evaluation is to determine the fitness of an individual. Evaluation requires an attempt at the level to be made and the resulting score to be recorded. I implemented this using pyautogui, a Python package for automated mouse and keyboard control. From a given individual, elements were read one at a time and their corresponding action executed at a rate of one action every 10 milliseconds.

This works fine until the elements run out. This is of particular concern because, for our initial population of empty lists, the elements run out immediately. So what should we do in this case? Well, if the elements in an individual run out and the game is not over yet, we just randomly generate new elements on the fly (no pun intended). In our case, the new elements were given equal probability of being -1, 0, or 1. These elements were recorded as they are executed and added to the end of the individual. After this, the individual has new genetic information that it didn't have when evaluation began. On the other hand if an individual with, say, 100 elements only executes 80 of them before colliding with an obstacle, the remaining 20 elements that weren't executed are removed before continuing.

The end result of evaluation is that each individual only consists of it's executable portion and has been assigned a fitness value. The fitness value, by the way, was simply taken to be the in-game score at the time of death, taken directly from the game files. The score in Chicken Wings is a function of both the distance travelled and the number of delicious corn cobs collected.

### Selection

The purpose of the selection step is to use the previously assigned fitness values to apply selection pressure, improving the overall score. In a probabilistic manner, individuals with a higher fitness are allowed to propagate more often, passing their genes on to the next generation, while those with a lower fitness are not. In Proavis, this is implemented using standard tournament selection. For each member of the next generation, *N* individuals from the last generation are chosen at random and only the fittest of these *N* goes through to the next generation. *N* may be considered the degree of selection pressure and, in our case, *N* was set to 3.

### Crossover

Crossover is commonly used to explore new possibilities by mating two individuals together. The individuals created through this process get part of their genome from each of their parents and (hopefully) become better than either one of them. For example, the start of parent *A*'s sequence may be more optimal that that of parent *B*, but parent *B* may have a more favorable end section. It is common practice, therefore, to create two new children by breaking the genome of both of the parents in half at a randomly chosen point and then swapping their tails.

![crossover](/img/proavis-001.png)
###### Figure 2: Crossover. [Source: sciencedirect.com/topics/medicine-and-dentistry/genetic-operator]

However, this where the Proavis algorithm differs once again. After the evaluation step is complete, one thing is true of all individuals in the population: They met their demise at the end of their genome. This is true because any elements that were not executed were ultimately removed from the individual. We know then, that every element in an individual proved successful at navigating the level until, near the end, a relatively small number of misguided clicks caused the run to abruptly end. Intuitively then, it is the end of the individual that requires the most attention.

For this reason, the Proavis algorithm uses a crossover point chosen randomly but not uniformly. Instead, a strong bias is introduced to encourage exploration of the solution space near the end of a given individual. The equation of the probability distribution is as follows:

![equation-1](/img/proavis-002.png)
###### Equation 1: The probability distribution for 0 <= *x* <= *n*.

where *n* is the length of the individual and *b* is a parameter that controls the degree of bias.

This distribution has some favorable features. Firstly, it is monotonically increasing with an exponential slope dictated by *b*. Secondly, and perhaps more importantly, the function is exponential, which means it is self-similar for a given range of indices preceding *n*, *e.g.* between *n* and *n* - 10. Therefore, regardless of how long the individual is, the parameter *b* dictates the probability of selecting *x* as a function of the how far *x* is from the end of the genome.

A point sampled from this distribution was used as the crossover point. Note that the parameter *b* must be larger than 1, but not by very much. A suitable value was found to be 1.02.

### Mutation

The final step required for a genetic algorithm to succeed is mutation. This operator introduces new genetic material to the population that may not be found in any of the current population. A common way to do this is to visit each individual and, with some likelihood, randomize some of its elements.

![mutation](/img/proavis-004.png)
###### Figure 3: Mutation. [Source: sciencedirect.com/topics/medicine-and-dentistry/genetic-operator]

Once again, performing this operation with an equal likelihood over an individual does not serve the Proavis algorithm very well. Mutations are far more important near the end of an individual's sequence where improvements must be made to overcome run-ending obstacles. This is difficult, however, if such a mutation can only occur while also mutating earlier elements.

Instead, by using the same probability distribution as we did for crossover, a point was chosen with a strong bias towards the end of the sequence. Mutation was then only applied to elements that followed this point. This approach allows elements near the end of the individual, where change is required, to be modified without impacting previous points and causing the individual's premature death.

### Notes

The algorithm was implemented using the Python package "DEAP". The probability of an individual being crossed with another was 50%. The probability of an individual being mutated was 20%, after which the independent probability of randomizing each element after the mutation point was 10%. Population size was set to 64. For my friend's research project, *x* and *y* coordinates of death were recorded, along with the number of attempts required to get past each obstacle.

## Results

Coming soon :)

