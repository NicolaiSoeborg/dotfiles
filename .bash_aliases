# Change first day of week to Monday and use metric system
export LC_TIME=en_DK.UTF-8
export LC_MEASUREMENT=en_DK.UTF-8

# Dont make __pycache__ (hmm, maybe only on laptop?)
export PYTHONDONTWRITEBYTECODE=1

# Verify DCT integrity of the images
export DOCKER_CONTENT_TRUST=1

# Opt out of dotnet tracking
export DOTNET_CLI_TELEMETRY_OPTOUT=1

alias ..='cd ../'
alias l='ls -Ahl --classify'
alias gdb='/usr/bin/gdb -q'
alias n='nvim'
alias b='base64'
alias bjq='b -d | jq'
alias jwt='tr "." "\n" | head -n2 | base64 -d 2>/dev/null ; echo'
alias py='python3 -q'
alias strace='/usr/bin/strace -f -s999999 -e "trace=!futex,brk,mmap,mprotect"'
alias tcpdump='tcpdump -nn -s0 -l'  # dont lookup hostname/ports, dont cap string size, output-while-capturing
alias sudo='/usr/bin/sudo -p "[sudo] password for $USER:" '
alias ipy='ipython3 --no-banner' # --nosep
alias xxxd='hexyl --color=auto'
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias lzd='docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock lazyteam/lazydocker'
alias dockershell='sudo docker exec -it "$(sudo docker ps -q|head -n1)" sh'

# Or maybe `alias ssh=kitty +kitten ssh'` ?
# export TERM=xterm-color

case "$(uname -s)" in
  Linux*)
    which kitty > /dev/null && source <(kitty + complete setup bash)
    alias g='grep -ir'
    alias x='xdg-open'
    alias clipboard='xclip -selection clipboard'
    ;;
  Darwin*)
    # kitty + complete setup zsh | source /dev/stdin
    alias g='ggrep -ir'
    alias x='open'
    alias clipboard='pbcopy'
    alias plist='/usr/libexec/PlistBuddy -c print'
    ;;
esac


# Android tricks
enable_proxy() {
    adb shell settings put global http_proxy localhost:8080
    adb shell settings put global captive_portal_mode 0
    adb reverse tcp:8080 tcp:8080
    # adb forward tcp:27042 localabstract:/data/local/tmp/frida.sock
}
disable_proxy() {
    adb shell settings delete global global_http_proxy_host
    adb shell settings delete global global_http_proxy_port
    adb shell settings delete global http_proxy
}
apk_install() {
    if [ -f "$1" ] ; then
        adb push "$1" /data/local/tmp/app.apk
        adb shell pm install -i "com.android.vending" -r /data/local/tmp/app.apk
        adb shell rm /data/local/tmp/app.apk
    fi
}
apk_packages() {
    PATTERN=".*"
    if [ ! -z $1 ] ; then
        PATTERN="$1"
    fi
    adb shell pm list packages | cut -d':' -f2 | egrep "$PATTERN"
}
apk_info() {
    adb shell pm dump "$1"
}
apk_version() {
    if [ -z $1 ] ; then
        exit 1
    fi
    versionName=$(apk_info "$1"|grep -Po '(?<=versionName=)[^ ]+')
    versionCode=$(apk_info "$1"|grep -Po '(?<=versionCode=)[^ ]+')
    versionStr="${versionName}_${versionCode}"
    printf "$versionStr\n"
}
apk_download() {
    versionName=$(apk_info "$1"|grep -Po '(?<=versionName=)[^ ]+')
    versionCode=$(apk_info "$1"|grep -Po '(?<=versionCode=)[^ ]+')
    versionStr="${versionName}_${versionCode}"
    mkdir "./$versionStr/"
    cd "./$versionStr/"
    for fullpath in $(adb shell pm path "$1"| sed 's/^package://')
    do
        adb pull "$fullpath"
    done
}
apk_extract() {
    if [ -f "$1" ] ; then
        jadx --show-bad-code --deobf --deobf-min 2 --deobf-use-sourcename --deobf-parse-kotlin-metadata "$1"
    fi
}


if [ -f "/usr/share/virtualenvwrapper/virtualenvwrapper.sh" ]; then
    VIRTUALENVWRAPPER_PYTHON=python3
    source /usr/share/virtualenvwrapper/virtualenvwrapper.sh
fi


pyc() {
    cython3 -3 --embed "$1"
    gcc -fPIE -O3 $(python3-config --cflags --embed) `echo "$1" | awk '{ gsub(".py",".c"); print }'` $(python3-config --ldflags --embed)
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
            *.deb) ar x "$1" ;;
            *.rar) unrar e "$1" ;;
            *.gz) gunzip "$1" ;;
            *.tar) tar xf "$1" ;;
            *.tbz2) tar xjf "$1" ;;
            *.tgz) tar xzf "$1" ;;
            *.xz) xz --decompress "$1" ;;
            *.zip) unzip "$1" ;;
            *.Z) uncompress "$1" ;;
            *.7z) 7z x "$1" ;;
            *) echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

cert_info() {
    if [ -f "$1" ] ; then
        case $1 in
            *.pem|*.crt) openssl x509   -in "$1" -text -noout ;;
            *.der)       openssl x509   -in "$1" -text -noout -inform DER ;;
            *.csr)       openssl req    -in "$1" -text -noout -verify ;;
            *.pfx|*.p12) openssl pkcs12 -in "$1" -info -nodes ;;
            *) echo "'$1' cannot be parsed via cert_info()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# DEB
DEBFULLNAME='Nicolai Søborg'
DEBEMAIL='git@xn--sb-lka.org'
export DEBEMAIL DEBFULLNAME

# Disable keybase FS
export KEYBASE_NO_KBFS=1

# pipx (apt install python3-argcomplete)
if [ $(command -v register-python-argcomplete3) ] ; then
    eval "$(register-python-argcomplete3 pipx)"
fi

