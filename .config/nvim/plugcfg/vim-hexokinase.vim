let g:Hexokinase_refreshEvents = ['InsertLeave']

let g:Hexokinase_optInPatterns = 'full_hex,rgb,rgba,hsl,hsla,colour_names'

let g:Hexokinase_highlighters = ['backgroundfull']

let g:Hexokinase_ftOptInPatterns = {
\     'css': 'full_hex,rgb,rgba,hsl,hsla,colour_names',
\     'html': 'full_hex,rgb,rgba,hsl,hsla,colour_names'
\ }

" Reenable hexokinase on enter
autocmd VimEnter * HexokinaseTurnOn
