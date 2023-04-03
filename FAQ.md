
## FAQ

#### Q: faustus module is no longer getting compiled in kernel version 6.1 or above

A: Official faustus module is no longer supported in kernel 6.1 or above. A workaround to fix the compilation issue is added in [this fork](https://github.com/legacyO7/faustus.git). Either try to compile it manually or use the default faustus repo provided in the aurora faustus setup


#### Q: My kernel version is 6.1 (or above). Why aurora is choosing faustus mode?

A: Inorder for aurora to choose mainline mode, `asus-nb-wmi` should be enabled. You may have disabled it for some reason in the past, so enable it manually after reverting the changes you made while you disabled it.

To enable `asus-nb-wmi`
```
sudo modprobe asus-wmi
sudo modprobe asus-nb-wmi
```

Also make sure `asus-nb-wmi` isnt blacklisted. check inside `/etc/modprobe.d/`

#### Q: faustus module is disabled but can still be accessed / error while disabling faustus

A: install faustus using [this fork](https://github.com/legacyO7/faustus.git)
```
sudo depmod
sudo modprobe -r faustus
````
blacklist the module
```
printf "blacklist faustus" | sudo tee /etc/modprobe.d/faustus.conf
```
```sudo dkms remove faustus/0.2 --all
```

 

