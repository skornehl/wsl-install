# Install customer specific WSL Instance

Original from: https://cloudbytes.dev/snippets/how-to-install-multiple-instances-of-ubuntu-in-wsl2#step-3-install-the-second-instance-of-ubuntu-in-wsl2

## Download WSL Tarball
In local Powershell

```
Remove-Item alias:curl
curl (("https://cloud-images.ubuntu.com",
"releases/hirsute/release",
"ubuntu-21.04-server-cloudimg-amd64-wsl.rootfs.tar.gz") -join "/") `
--output ubuntu-21.04-wsl-rootfs-tar.gz
wsl --import Ubuntu-${CustomerName} C:\Users\sebas\ubuntu-${CustomerName .\ubuntu-21.04-wsl-rootfs-tar.gz
wsl -d ${CustomerName}
```

## Install User
In WSL Terminal
```
 NEW_USER=skornehl
 useradd -m -G sudo -s /bin/bash "$NEW_USER"
 passwd "$NEW_USER"
 tee /etc/wsl.conf <<_EOF
 [user]
 default=${NEW_USER}
 _EOF
```

## Restart WSL
In local Powershell

```
wsl --shutdown ${CustomerName}
wsl -d ${CustomerName}
```

## Install WSL
In WSL Terminal
```
wget -O - https://github.com/skornehl/wsl-install/blob/main/install.sh | bash
```
