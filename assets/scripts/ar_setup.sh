#!/bin/bash

package_manager='unknown'
signingfileloc="/lib/modules/$(uname -r)/build/certs"
faustusDir="/sys/devices/platform/faustus/"
packages_to_install="dkms openssl mokutil xterm wget git pkexec make cmake"
filename_key="signing_key"
tmpdir="$1"
require_reboot=false


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


installpackages(){
  checkos
  if [ package_manager == "unknown" ]
  then
    echo "unsupported Operating System"
  else
    echo "Installing packages"

    for terminal in "$TERMINAL" $1; do
        if command -v "$terminal" > /dev/null 2>&1; then
            exec `$terminal -e "exec 2>/tmp/legacy07.aurora/log && sudo ${package_manager} $packages_to_install"`
            echo success
            break;
        fi
    done


  fi
}

installfaustus(){
    echo "Installing faustus"

        if [ -d "$faustusDir" ]; then
            echo faustus module found
            else
            echo installing faustus module

            mkdir -p $tmpdir

                git clone --depth=1 https://github.com/legacyO7/faustus.git $tmpdir/faustus

                cd $tmpdir/faustus

                    if mokutil --sb-state | grep -q 'enabled'; then

                        require_reboot=true

                            echo "[ req ]
                            default_bits = 4096
                            distinguished_name = req_distinguished_name
                            prompt = no
                            x509_extensions = myexts

                            [ req_distinguished_name ]
                            CN = Modules

                            [ myexts ]
                            basicConstraints=critical,CA:FALSE
                            keyUsage=digitalSignature
                            subjectKeyIdentifier=hash
                            authorityKeyIdentifier=keyid" >  x509.genkey

                            openssl req -new -nodes -utf8 -sha512 -days 36500 -batch -x509 -config x509.genkey -outform DER -out ${filename_key}.x509 -keyout ${filename_key}.pem -subj "/CN=Aurora/"

                    fi

                printf "blacklist asus_wmi \nblacklist asus_nb_wmi" | sudo tee /etc/modprobe.d/faustus.conf

                sudo rmmod asus_nb_wmi
                sudo rmmod asus_wmi

                make
                sudo modprobe sparse-keymap wmi video

                if [ "$require_reboot" = true ]
                then
                    sudo /usr/src/linux-headers-`uname -r`/scripts/sign-file sha256 ./${filename_key}.pem ./${filename_key}.x509 src/faustus.ko
                    echo "=== MOK ENROLLMENT PASSWORD ==="
                    sudo mokutil --import ${filename_key}.x509
                    sudo mv ${filename_key}.pem $signingfileloc
                fi

                sudo insmod src/faustus.ko

                sudo make dkms
                sudo modprobe faustus

                sudo make onboot
                sudo ./set_rgb.sh

                make clean

            cd ..
            rm -rf faustus
        fi

}

if [ $# -ne 0 ]
  then
    case "$2" in
    checkos)
    checkos
    ;;
    installpackages)
    installpackages $3
    ;;
    installfaustus)
    installfaustus
    ;;
    esac
fi

