#function new game
#Create a new game state for the graph g.

#All edges are neutral, Short starts, and there is no winner.

function new_game(g::GameGraph)::GameState:
    for edge in g.edges                 #all edges are neutral
        edge.state = :neutral
    current_player = :short     #current(first) player is short
    history = Tuple{Symbol, Edge}[]     #no path history
    winner = nothing         #no winner                                  
    return GameState(g, current_player, history, winner)
    
end

#function valid_moves
#Returns all neutral edges that the current player is allowed to choose

function valid_moves(state::GameState)::Vector{Edge}:
    Result=Vector{Edge}()
    for edge in state.graph.edges:
        if edge.state == :neutral
            push!(Result,edge)
        end
    end
end



function make_move!(state::GameState, e::Edge)::Nothing: 
