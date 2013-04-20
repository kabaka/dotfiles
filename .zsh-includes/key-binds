bindkey -v

bindkey "^?" backward-delete-char
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
bindkey '^[OH' beginning-of-line
bindkey '^[OF' end-of-line
bindkey '^[[5~' up-line-or-history
bindkey '^[[6~' down-line-or-history
bindkey "^r" history-incremental-search-backward
bindkey ' ' magic-space    # also do history expansion on space
bindkey '^I' complete-word # complete on tab, leave expansion to _expand

# These are mostly copy/pasted from somewhere. Need to verify which of them are
# needed for my setup.

bindkey "\e[1~" beginning-of-line     # Home
bindkey "\e[4~" end-of-line           # End
bindkey "\e[5~" beginning-of-history  # PageUp
bindkey "\e[6~" end-of-history        # PageDown
bindkey "\e[2~" quoted-insert         # Ins
bindkey "\e[3~" delete-char           # Del
bindkey "\e[5C" forward-word
bindkey "\eOc" emacs-forward-word
bindkey "\e[5D" backward-word
bindkey "\eOd" emacs-backward-word
bindkey "\e\e[C" forward-word
bindkey "\e\e[D" backward-word
# for rxvt
bindkey "\e[7~" beginning-of-line     # Home
bindkey "\e[8~" end-of-line           # End
# for non RH/Debian xterm, can't hurt for RH/Debian xterm
bindkey "\eOH" beginning-of-line
bindkey "\eOF" end-of-line
# for freebsd console
bindkey "\e[H" beginning-of-line
bindkey "\e[F" end-of-line

