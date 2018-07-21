# Small configurations for different languages

hook global WinSetOption filetype=(html) %[
    # calls to emmet-cli
    # Depends on ../bin/emmet-call
    define-command emmet %{
        execute-keys "<esc><a-?>\h+|^<ret>|%val{config}/bin/emmet-call<ret>"
        execute-keys "<esc>uU)<a-;> ;: replace-next-hole<ret>"
    }
    map global insert <a-E> ' <esc>;h: try snippet-word catch emmet<ret>'
    map global insert <a-e> '<esc>: replace-next-hole<ret>'
]

hook global WinSetOption filetype=(xml) %[
    set-option buffer formatcmd %{xmllint --format -}
]

hook global WinSetOption filetype=(json) %[
    set-option buffer formatcmd %{python -m json.tool}
]

# better indentation
hook global WinSetOption filetype=(p4|php) %[
    hook -group c-family-indent window ModeChange insert:.* c-family-trim-autoindent
    hook -group c-family-insert window InsertChar \n c-family-insert-on-newline
    hook -group c-family-indent window InsertChar \n c-family-indent-on-newline
    hook -group c-family-indent window InsertChar \{ c-family-indent-on-opening-curly-brace
    hook -group c-family-indent window InsertChar \} c-family-indent-on-closing-curly-brace
    hook -group c-family-insert window InsertChar \} c-family-insert-on-closing-curly-brace
]

hook global WinSetOption filetype=(rust) %[
    set-option buffer formatcmd rustfmt
]
