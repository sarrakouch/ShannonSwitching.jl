# ShannonSwitching.jl
Julia implementation of the Shannon Switching Game: a two-player graph game introduced by Claude Shannon. Includes core game logic, an interactive playable visualization, provably optimal strategies for the unweighted game via matroid duality, and heuristic strategies for the open weighted variant.

# What is this game?
The Shannon Switching Game is a two-player game on a graph, invented by Claude Shannon in the 1950s. There's a source node s and a target node t. Two players, Short and Cut, take turns:

Short claims a neutral edge, trying to build a connected path from s to t.
Cut removes a neutral edge, trying to permanently disconnect s from t.

Short goes first. The game ends the moment either Short has a full s-t path, or Cut has made one impossible.

There's also a weighted variant, where Short tries to minimize the total weight of his winning path and Cut tries to force him into the most expensive one possible. (Unlike the classical version, no optimal strategy is known for the weighted game; that's the open, unsolved part).

# Project structure
Core game engine: data structures (Vertex, Edge, GameGraph, GameState) and game logic (new_game, valid_moves, make_move!, check_winner)

Playable visualization: two humans can play a full game

Optimal strategy (unweighted game): a provably optimal computer strategy via spanning trees, co-spanning trees, and matroid duality (Kishi-Kajitani maximally-distant tree algorithm)

Heuristic strategy (weighted game): experimental strategies for the open weighted variant, tuned against self-play

# Status: Phase 2

Worked on the foundation: data structures and core game logic. 

Currently working on a playable Visualization

# Background

The theory here comes from a two-part matroid-theoretic result:

Short's strategy relies on finding two spanning trees of the graph with disjoint neutral edges (a Steiner-tree argument), maintained turn-by-turn via a repair strategy.
Cut's strategy is the matroid dual of Short's: instead of two disjoint spanning trees, Cut needs two disjoint co-spanning trees, computed the same way but with fundamental cuts standing in for fundamental circuits.

Both use an algorithm by Kishi and Kajitani for computing maximally distant spanning trees.
