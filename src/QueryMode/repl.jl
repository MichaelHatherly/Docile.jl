
import Base: LineEdit, REPL

function initmode(;
    text  = "query> ",
    color = "\e[35;5;166m",
    key   = ']',
    )

    # Not always defined, so skip if we can't find the REPL.
    isdefined(Base, :active_repl) || return

    repl       = Base.active_repl
    julia_mode = repl.interface.modes[1]

    query_mode = LineEdit.Prompt(text;
        prompt_prefix    = color,
        prompt_suffix    = Base.text_colors[:white],
        keymap_func_data = repl,
        on_enter         = REPL.return_callback,
        complete         = REPL.REPLCompletionProvider(repl),
    )
    query_mode.on_done = REPL.respond(repl, query_mode) do line
        :(Docile.QueryMode.exec(Docile.QueryMode.@query_str($(line))))
    end

    push!(repl.interface.modes, query_mode)

    hp                      = julia_mode.hist
    hp.mode_mapping[:query] = query_mode
    query_mode.hist         = hp

    search_prompt, skeymap = LineEdit.setup_search_keymap(hp)

    mk = REPL.mode_keymap(julia_mode)

    const query_keymap = Dict(
        key => (s, args...) ->
            if isempty(s) || position(LineEdit.buffer(s)) == 0
                buf = copy(LineEdit.buffer(s))
                LineEdit.transition(s, query_mode) do
                    LineEdit.state(s, query_mode).input_buffer = buf
                end
            else
                LineEdit.edit_insert(s, key)
            end
    )

    query_mode.keymap_dict = LineEdit.keymap(Dict[
        skeymap,
        mk,
        LineEdit.history_keymap,
        LineEdit.default_keymap,
        LineEdit.escape_defaults,
    ])
    julia_mode.keymap_dict = LineEdit.keymap_merge(julia_mode.keymap_dict, query_keymap)

    nothing
end
