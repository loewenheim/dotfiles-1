hook global BufCreate .*\.p4 %{
    set-option buffer filetype p4
}

# Regions definition are the same between c++ and objective-c
%sh{
    ft="p4"
    maybe_at=''

    printf %s\\n '
        add-highlighter shared/ regions -default code -match-capture FT \
            string %{MAYBEAT(?<!QUOTE)(?<!QUOTE\\)"} %{(?<!\\)(?:\\\\)*"} "" \
            string %{R"([^(]*)\(} %{\)([^)]*)"} "" \
            comment /\* \*/ "" \
            comment // $ "" \
            disabled ^\h*?#\h*if\h+(?:0|FALSE)\b "#\h*(?:else|elif|endif)" "#\h*if(?:def)?" \
            macro %{^\h*?\K#} %{(?<!\\)\n} ""

        add-highlighter shared/FT/string fill string
        add-highlighter shared/FT/comment fill comment
        add-highlighter shared/FT/disabled fill rgb:666666
        add-highlighter shared/FT/macro fill meta
        add-highlighter shared/FT/macro regex ^\h*#include\h+(\S*) 1:module
        ' | sed -e "s/FT/${ft}/g; s/QUOTE/'/g; s/MAYBEAT/${maybe_at}/;"
}


add-highlighter shared/p4/code regex %{\b(lpm|exact|ternary|range|true|false|null)\b} 0:value
add-highlighter shared/p4/code regex %{\b(bit|bool|int|varbit|void|error)\b} 0:type
add-highlighter shared/p4/code regex "\b(tuple|extern|enum|action|apply|control|default|exit|header|header_union|match_kind|package|parser|state|struct|switch|size|table|transition|typedef|verify)\b" 0:keyword
add-highlighter shared/p4/code regex "\b(key|actions||default_action|entries|implementation|const|in|out|inout)\b" 0:attribute
add-highlighter shared/p4/code regex "\b(update_checksum|isValid)\b" 0:function
add-highlighter shared/p4/code regex "(apply)\(" 1:function
add-highlighter shared/p4/code regex "@(name|tableonly|defaultonly|globalname|atomic|hidden)" 0:meta
add-highlighter shared/p4/code regex %{\b(_|NoError|PacketTooShort|NoMatch|StackOutOfBounds|OverwritingHeader|HeaderTooShort|ParserTiimeout)\b} 0:builtin

add-highlighter shared/p4/comment regex "(?<!\w)@\w+\b" 0:green

# integer literals
%sh{ 
    prefix="(\\\d+[ws])?"
    printf %s\\n '
        add-highlighter shared/p4/code regex %{\bPREFIX[0-9][0-9_]*\b} 0:value  
        add-highlighter shared/p4/code regex %{\bPREFIX0[Xx][0-9a-fA-F]+\b} 0:value
        add-highlighter shared/p4/code regex %{\bPREFIX0[dD][0-9_]+\b} 0:value
        add-highlighter shared/p4/code regex %{\bPREFIX0[oO][0-7_]+\b} 0:value
        add-highlighter shared/p4/code regex %{\bPREFIX0[bB][01_]+\b} 0:value
        ' | sed -e "s/PREFIX/${prefix}/g"
}




hook -group p4-highlight global WinSetOption filetype=p4 %{ add-highlighter window ref p4 }
hook -group p4-highlight global WinSetOption filetype=(?!p4).* %{ remove-highlighter window/p4 }

hook global WinSetOption filetype=p4 %[
    hook -group c-family-indent window ModeChange insert:.* c-family-trim-autoindent
    hook -group c-family-insert window InsertChar \n c-family-insert-on-newline
    hook -group c-family-indent window InsertChar \n c-family-indent-on-newline
    hook -group c-family-indent window InsertChar \{ c-family-indent-on-opening-curly-brace
    hook -group c-family-indent window InsertChar \} c-family-indent-on-closing-curly-brace
    hook -group c-family-insert window InsertChar \} c-family-insert-on-closing-curly-brace
]
