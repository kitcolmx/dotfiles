# PATH
export PATH=$PATH:/mnt/c/HashiCorp/Vagrant/bin

# vi mode
bindkey -v
bindkey "jj" vi-cmd-mode

# wrapping paste.exe
alias paste.exe='paste.exe | sed "s///g"'

# useful alias
alias c='clip.exe'
alias p='paste.exe | source /dev/stdin'
alias trans='/usr/local/bin/trans'
# notify finished command

export NOTIFY_BLACKLIST=("vim" "zsh")
precmd()
{
  returned_value=$?

  if [ $TIMESTAMP ]; then
    res=$(($SECONDS-$TIMESTAMP))
    if [ $res -ge 10 ]; then
      cmd=$(fc -ln -1 | sed -e 's/\"/\`\"/g')

      is_included_to_blacklist=0
      for item in ${NOTIFY_BLACKLIST[@]}; do
        [ $(echo $cmd | awk '{print $1}') = $item ] && is_included_to_blacklist=1
      done

      if [ $is_included_to_blacklist -eq 1 ]; then
        :
      else
        sts=$([ $returned_value -eq 0 ] && echo succeeded || echo failed)
        hh=$(($res / 3600))
        mm=$((($res - ($hh * 3600)) / 60))
        ss=$(($res - $hh * 3600 - $mm * 60))
        msg="command "$sts", took "$(printf "%.2dh%.2dm%.2ds" $hh $mm $ss)
        tty=$(tty)
        powershell.exe -c "\$toastHeader = New-BTHeader -Id \"$tty\" -Title \"$tty\"; 
        New-BurntToastNotification -Header \$ToastHeader -Text \"$msg\", \"$cmd\""
      fi
    fi
    export TIMESTAMP=$SECONDS
  fi
}

preexec()
{
  export TIMESTAMP=$SECONDS
}
