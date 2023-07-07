#!/bin/bash

tmpdir="$1"
signingfileloc="/lib/modules/$(uname -r)/build/certs"
faustusDir="/sys/devices/platform/faustus/"
filename_key="signing_key"
require_reboot=false

echo "Installing faustus"

        if [ -d "$faustusDir" ]; then
            echo faustus module found
            else
            echo faustus module not found

            mkdir -p $tmpdir

                git clone --depth=1 $2 $tmpdir/faustus

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

                sudo ln -s /sys/kernel/btf/vmlinux  /usr/lib/modules/`uname -r`/build/vmlinux

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

             if [ -d "$faustusDir" ]; then
                echo "faustus module found"
             else
               echo "faustus module not found"
             fi
        fi
