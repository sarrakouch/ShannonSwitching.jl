include("source.jl")
 
# prints the current board (edge list with state) plus whose turn it is
# or, once the game is over, who won. This covers the "show current
# player / game status / winner" bonus point for free, in text form.

function print_state(state::GameState)
    println()
    println("--- Board ---")
    for e in state.graph.edges
        println("  Edge $(e.id): $(e.u.id) -- $(e.v.id)  [$(e.state)]")
    end
    println("s = $(state.graph.s.id), t = $(state.graph.t.id)")
    if state.winner === nothing
        println("Turn: $(state.current_player)")
    else
        println("Game over! Winner: $(state.winner)")
    end
end
 
# Repeatedly asks the current player for an edge id until a valid move
# is entered (or the player types "quit"). Returns the chosen Edge,
# or `nothing` if the player quit.
function prompt_move(state::GameState)::Union{Edge, Nothing}
    moves = valid_moves(state)
    ids = join([e.id for e in moves], ", ")
    while true
        print("Player $(state.current_player), choose an edge id ($ids), or 'quit': ")
        raw = readline()
        input = strip(raw)
        if lowercase(input) == "quit"
            return nothing
        end
        id = tryparse(Int, input)
        if id === nothing
            println("Not a number, try again.")
            continue
        end
        idx = findfirst(e -> e.id == id, moves)
        if idx === nothing
            println("Edge $id is not a valid move.")
            continue
        end
        return moves[idx]
    end
end
 
# Drives a full game from start to finish in the terminal.
function play_repl(g::GameGraph)
    state = new_game(g)
    print_state(state)
    while state.winner === nothing
        e = prompt_move(state)
        if e === nothing
            println("\nGame aborted by player.")
            return state
        end
        make_move!(state, e)
        print_state(state)
    end
    println("\nThanks for playing!")
    return state
end

# Goal: only auto-start a demo game when run standalone, so the functions stay safely reusable when included in the the future Gtk4 app
if abspath(PROGRAM_FILE) == @__FILE__
    g = random_graph(6, 8)
    play_repl(g)
end
 
#will be improved later using Gtk4 Package


