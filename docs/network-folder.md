# SMB network folder

How to mount a network shared folder the SMB/CIFS. You'll need the username and password for the user or shared folder.

1. Install packages:
    ```bash
    sudo apt install cifs-utils
    ```
1. Create a mount point:
    ```bash
    mkdir /mnt/myfolder
    ```
1. Make a credentials file:
    ```bash
    echo "username=your_username" > ~/.smbcredentials
    echo "password=your_password" >> ~/.smbcredentials
    chmod 600 ~/.smbcredentials
    ```
1. Edit the `/etc/fstab` file to add the mount entry:

    ```bash
    sudo nano /etc/fstab
    ```

1. Add the following line to the end of the file, replacing `ip.address`, `SHARE_NAME`, and `your_username` with your actual values:

    ```
    //ip.address/SHARE_NAME /mnt/myfolder cifs vers=3.0,credentials=/home/your_username/.smbcredentials,uid=1000,gid=1000 0 0
    ```

1. Mount the shared folder:
    ```bash
    sudo mount -a
    ```
