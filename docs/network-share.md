# SMB network folder

The `network-share` Ansible role mounts SMB/CIFS shares automatically. Set `network_share_host`, `network_share_username`, `network_share_password` and the `network_shares` list in your host vars, then run the playbook. It writes the credentials to `/root/.smbcredentials` (mode `0600`) and adds an `/etc/fstab` entry for each share.

To mount a share by hand instead:

1. Install packages:
    ```bash
    sudo apt install cifs-utils
    ```
1. Create a mount point:
    ```bash
    sudo mkdir /mnt/myfolder
    ```
1. Make a credentials file readable only by root:
    ```bash
    printf 'username=%s\npassword=%s\n' your_username your_password | sudo tee /root/.smbcredentials >/dev/null
    sudo chmod 600 /root/.smbcredentials
    ```
1. Edit the `/etc/fstab` file to add the mount entry:

    ```bash
    sudo nano /etc/fstab
    ```

1. Add the following line to the end of the file, replacing `ip.address` and `SHARE_NAME` with your actual values:

    ```
    //ip.address/SHARE_NAME /mnt/myfolder cifs vers=3.0,credentials=/root/.smbcredentials,uid=1000,gid=1000,x-systemd.automount,_netdev 0 0
    ```

1. Mount the shared folder:
    ```bash
    sudo systemctl daemon-reload
    sudo mount -a
    ```
