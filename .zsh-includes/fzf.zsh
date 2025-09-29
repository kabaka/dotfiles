# history search
fh() {
  print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed -r 's/ *[0-9]*\*? *//')
}

zle -N fh{,}

for keymap in emacs viins; do
  bindkey -M $keymap '^R' fh 2>/dev/null
done

export FZF_DEFAULT_OPTS='
  --color fg:252,bg:233,hl:67,fg+:252,bg+:235,hl+:81
  --color info:144,prompt:161,spinner:135,pointer:135,marker:118
'

[[ $- == *i* ]] && source "/home/kljohnso/.fzf/shell/completion.zsh" 2> /dev/null

export FZF_COMPLETION_TRIGGER=''
for keymap in emacs viins; do
  bindkey -M $keymap '^T' fzf-completion 2>/dev/null
  [[ -n ${fzf_default_completion-} ]] && bindkey -M $keymap '^I' "$fzf_default_completion" 2>/dev/null
done
