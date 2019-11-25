#****** useful bash functions

fromhex(){
    hex=${1#"#"}
    r=$(printf '0x%0.2s' "$hex")
    g=$(printf '0x%0.2s' ${hex#??})
    b=$(printf '0x%0.2s' ${hex#????})
    printf '%03d' "$(( (r<75?0:(r-35)/40)*6*6 + 
                       (g<75?0:(g-35)/40)*6   +
                       (b<75?0:(b-35)/40)     + 16 ))"
}

termcolor(){
    for c; do
        printf '\e[48;5;%dm%03d' $c $c
    done
    printf '\e[0m \n'
}


termcolors_all(){
IFS=$' \t\n'
termcolor {0..15}
for ((i=0;i<6;i++)); do
    termcolor $(seq $((i*36+16)) $((i*36+51)))
done
termcolor {232..255}
}


pathadd() {
    if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
        PATH="${PATH:+"$PATH:"}$1"
    elif [ ! -d "$1" ]; then
        echo pathadd ERROR: "$1" does not exist or is not a directory
    fi
}

pythonadd() {
    if [ -d "$1" ] && [[ ":$PYTHONPATH:" != *":$1:"* ]]; then
        PYTHONPATH="${PYTHONPATH:+"$PYTHONPATH:"}$1"
    elif [ ! -d "$1" ]; then
        echo pythonadd ERROR: "$1" does not exist or is not a directory
    fi
}

function Find(){
    find ./ -type f -iname "${1}"
}

DU () {
  # strange, but I want this to work even if there is a folder named total
  a=$(du -hcs .[A-Za-z]* * 2> /dev/null | sort -hr)
  b=$(echo "$a" | head -1) # total should be here
  c=$(echo "$a" | grep -v "$b") # all except total
  for i in $(ls -d .[A-Za-z]*/ */ 2> /dev/null );
  do
   d=$(echo "$c" | sed "s@[\s\S\t]${i%/}\$@\\\e[34m\t${i}\\\e[39m@")
   c=$d
  done
  echo -e "$c\n--------------\n$b"
}
