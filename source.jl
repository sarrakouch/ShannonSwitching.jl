#just the struct definitions
struct Vertex
    id::Int
end

mutable struct Edge
    id::Int
    u::Vertex
    v::Vertex
    weight::Float64
    state::Symbol
end

struct GameGraph
    vertices::Vector{Vertex}
    edges::Vector{Edge}
    s::Vertex
    t::Vertex
end

mutable struct GameState
    graph::GameGraph
    current_player::Symbol
    history::Vector{Tuple{Symbol, Edge}}
    winner::Union{Symbol, Nothing}
end


# function path_exists
# Checks whether there is a path from `s` to `t` using only the edges in `edges`.
# 1. Build an adjacency list from edges
# 2. Run BFS/DFS from s, marking visited vertices
# 3. Return true if t is reached, false otherwise
function path_exists(edges::Vector{Edge}, s::Vertex, t::Vertex)::Bool
    # Shortcut: if start and target are identical, a path trivially exists.
    s.id == t.id && return true
 
    # Build the adjacency list: Vertex.id => Vector{Vertex.id}
    adj = Dict{Int, Vector{Int}}()
    for e in edges
        push!(get!(adj, e.u.id, Int[]), e.v.id)
        push!(get!(adj, e.v.id, Int[]), e.u.id)
    end
 
    # BFS starting from s
    visited = Set{Int}([s.id])
    queue = [s.id]
    while !isempty(queue)
        current = popfirst!(queue)
        for neighbor in get(adj, current, Int[])
            if neighbor == t.id
                return true
            end
            if !(neighbor in visited)
                push!(visited, neighbor)
                push!(queue, neighbor)
            end
        end
    end
    return false
end



# function new_game
# Create a new game state for the graph g.
# All edges are neutral, Short starts, and there is no winner.
function new_game(g::GameGraph)::GameState
    for edge in g.edges              # all edges are neutral
        edge.state = :neutral
    end
    current_player = :short          # current (first) player is short
    history = Tuple{Symbol, Edge}[]  # no move history yet
    winner = nothing                 # no winner yet
    return GameState(g, current_player, history, winner)
end



# function valid_moves
# Returns all neutral edges that the current player is allowed to choose.
function valid_moves(state::GameState)::Vector{Edge}
    result = Vector{Edge}()          # initial empty result
    for edge in state.graph.edges
        if edge.state == :neutral    # each neutral edge is a valid move
            push!(result, edge)
        end
    end
    return result
end



# function make_move!
# Executes the current player's move on edge `e`: Short sets `e.state = :short`,
# while Cut sets `e.state = :cut`.
# Updates the history, switches the active player, and checks the winning condition.
function make_move!(state::GameState, e::Edge)::Nothing
    if !(e in valid_moves(state))            # must be a valid move
        error("Invalid move: edge $(e.id) is not neutral")
    end
 
    push!(state.history, (state.current_player, e))  # update history
 
    if state.current_player == :short        # update state of edge e
        e.state = :short
    else
        e.state = :cut
    end
 
    result = check_winner(state)
    if result === nothing                    # game is not over yet
        state.current_player = state.current_player == :short ? :cut : :short
    else
        state.winner = result                # else sets the winner
    end
 
    return nothing
end


 
# function check_winner
# Returns :short if the edges claimed by Short contain an s-t path;
# returns :cut if no s-t path exists anymore in the remaining graph;
# otherwise returns nothing.
function check_winner(state::GameState)::Union{Symbol, Nothing}
    short_edges = Vector{Edge}()      # edges claimed by Short
    remaining_edges = Vector{Edge}()  # edges not claimed by Cut (short + neutral)
 
    for edge in state.graph.edges
        if edge.state == :short
            push!(short_edges, edge)
            push!(remaining_edges, edge)
        elseif edge.state == :neutral
            push!(remaining_edges, edge)
        end
    end
 
    if path_exists(short_edges, state.graph.s, state.graph.t)
        return :short
    elseif !path_exists(remaining_edges, state.graph.s, state.graph.t)
        return :cut
    else
        return nothing
    end
end

#function random_graph
#Generates a random connected graph with (n) vertices and (m) edges. *
#Vertex 1 is the source (s), and vertex (n) is the target (t). 
#In the weighted case, edge weights are drawn uniformly from ([1,10]).


function random_graph(n::Int, m::Int; weighted=false)::GameGraph
    vertices = [Vertex(i) for i in 1:n]                                             # create n vertices with ids 1 to n
    edges = Edge[]                                                                  # empty list for the graph's edges
    edge_id = 1                                                                     # starting value
    existing = Set{Tuple{Int,Int}}()                                                # stores all edges already present, as index pairs
    for i in 1:n-1
        w = weighted ? rand() * 9 + 1 : 0.0                                         # if weighted is true, use a random weight, otherwise 0.0
        push!(edges, Edge(edge_id, vertices[i], vertices[i+1], w, :neutral))        # add an edge between vertex i and i+1
        push!(existing, (i, i+1))                                                   # mark this edge as present
        edge_id += 1                                                                # increment edge id
    end
    while length(edges) < m                                                         # add more edges until m is reached
        u = rand(1:n)                                                               # pick a random first vertex index
        v = rand(1:n)                                                               # pick a random second vertex index
 
        u == v && continue                                                          # if u == v, pick again
        a, b = min(u,v), max(u,v)                                                   # sort both endpoints
        (a, b) in existing && continue                                              # if the edge already exists, skip it
        w = weighted ? rand() * 9 + 1 : 0.0
 
        push!(edges, Edge(edge_id, vertices[a], vertices[b], w, :neutral))          # add the new random edge to the list
 
        push!(existing, (a,b))                                                      # mark this edge as present
        edge_id += 1
    end
    s = vertices[1]                                                                 # start vertex is the first vertex
    t = vertices[n]                                                                 # target vertex is the last vertex
    return GameGraph(vertices, edges, s, t)                                         # build and return the complete game graph
end
