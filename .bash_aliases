alias ..='cd ../'
alias l='ls -lh --classify'
alias gdb='/usr/bin/gdb -q'
alias n='nvim'
alias py='python3 -q'
alias strace='/usr/bin/strace -f -s999999 -e "trace=!futex,brk,mmap,mprotect"'
alias tcpdump='/usr/sbin/tcpdump -nn -s0 -l'  # dont lookup hostname/ports, dont cap string size, output-while-capturing
alias sudo='/usr/bin/sudo -p "[sudo] password for $USER:"'
alias ipy='ipython3 --no-banner' # --nosep
alias xxxd='hexyl --color=auto'
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'


# cat <bigfile> | clipboard
case "$(uname -s)" in
  Linux*)
    alias g='grep -ir'
    alias x='xdg-open'
    alias clipboard='xclip -selection clipboard'
    ;;
  Darwin*)
	alias g='ggrep -ir'
	alias x='open'
    alias clipboard='pbcopy'
    ;;
esac


# notifications <start|stop>
notifications() {
    if [ ! -z $1 ] ; then
        case $1 in
            start) gsettings set org.gnome.desktop.notifications show-banners true ;;
            stop) gsettings set org.gnome.desktop.notifications show-banners false ;;
            *) echo "Usage: notifications <start|stop>  ('$1' is not valid)" ;;
        esac
    else
        echo "Usage: notifications <start|stop>"
    fi
}


pyc() {
    cython3 -3 --embed "$1"
    gcc -O3 `echo "$1" | awk '{ gsub(".py",".c"); print }'` $(pkg-config --libs --cflags python3)
}


digg() {
    dns_types=(A AAAA TXT CNAME MX NS PTR SOA)
    for i in "${dns_types[@]}";
    do
        echo "==========> $i";
        /usr/bin/dig +nocmd "$1" "$i" +noall +answer;
    done
}


# Unzip and keep zipped file:
extract() {
    if [ -f "$1" ] ; then
        case $1 in
            *.tar.bz2) tar xjf "$1" ;;
            *.tar.gz) tar xzf "$1" ;;
            *.bz2) bunzip2 "$1" ;;
            *.rar) unrar e "$1" ;;
            *.gz) gunzip "$1" ;;
            *.tar) tar xf "$1" ;;
            *.tbz2) tar xjf "$1" ;;
            *.tgz) tar xzf "$1" ;;
            *.zip) unzip "$1" ;;
            *.Z) uncompress "$1" ;;
            *.7z) 7z x "$1" ;;
            *) echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# DEB
DEBFULLNAME='Nicolai Søborg'
DEBEMAIL='git@xn--sb-lka.org'
export DEBEMAIL DEBFULLNAME

