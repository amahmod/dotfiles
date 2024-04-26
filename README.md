# Hyprland Installer

**For Nvidia suuport** (do this first)

```
$ yay -S linux-headers nvidia-dkms qt5-wayland qt5ct libva libva-nvidia-driver-git

Add modules: nvidia nvidia_modeset nvidia_uvm nvidia_drm to /etc/mkinitcpio.conf
$ sudo sed -i 's/MODULES=()/MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' /etc/mkinitcpio.conf

Generate new image:
$ sudo mkinitcpio --config /etc/mkinitcpio.conf --generate /boot/initramfs-custom.img

Add/create the following: options nvidia-drm modeset=1 in /etc/modprobe.d/nvidia.conf
$ echo -e "options nvidia-drm modeset=1" | sudo tee -a /etc/modprobe.d/nvidia.conf &>> $INSTLOG

reboot!
```
