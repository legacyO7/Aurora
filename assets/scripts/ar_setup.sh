#!/bin/bash

package_manager='unknown'
packages_to_install="dkms openssl mokutil xterm wget git pkexec make cmake"
terminal_list="$4"
tmpdir="$1"
git_faustus="$3"


checkos(){

 declare -A osInfo;
 osInfo[/etc/debian_version]="apt-get install -y"
 osInfo[/etc/alpine-release]="apk --update add"
 osInfo[/etc/centos-release]="yum install -y"
 osInfo[/etc/fedora-release]="dnf install -y"

 for f in ${!osInfo[@]}
 do
     if [[ -f $f ]];then
         package_manager=${osInfo[$f]}
     fi
 done

}

executeinterminal(){

   if [ "$EUID" -ne 0 ]; then
     clear
     echo "Opening native terminal to continue installation"

           for terminal in "${terminal_list[@]}"; do
                echo $terminal
                if command -v "$terminal" > /dev/null 2>&1; then
                    exec `$terminal -e "exec 2>$tmpdir/log && $@"`
                    echo success
                    break;
                fi
            done
   else
        $@
   fi



}


installpackages(){

  checkos
  if [ package_manager == "unknown" ]
  then
    echo "unsupported Operating System"
  else

  clear
    echo "Installing packages"
    executeinterminal "sudo ${package_manager} $packages_to_install"

  fi
}

setterminallist(){
  shift
  shift
  terminal_list=($@)
  clear
}

if [ $# -ne 0 ]
  then
    case "$2" in
    checkos)
    checkos
    ;;
    installpackages)
    setterminallist $@
    installpackages
    ;;
    installfaustus)
    shift
    setterminallist $@
    executeinterminal "sudo $tmpdir/install_faustus.sh $tmpdir $git_faustus"
    ;;
    esac
fi

