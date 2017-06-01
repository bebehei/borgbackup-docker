# borgbackup server docker image

minimalistic docker image to contain a borg server

## running

    docker run --rm \
      -v $PWD/data:/home \
      -v $PWD/ssh:/etc/ssh \
      -p 22:22 \
      bebehei/borg

## User management

**root login is not enabled**

Create a new folder in your home volume manually and chmod the folder to the UID and GID.  Also add an SSH-Key to your user.

### Example

To add a user with the name `backup` and the UID/GID 1000. In this case, the file `id_rsa.pub` contains the pubkey and the data-folder is the `/home`-volume.

    mkdir -p data/backup/.ssh
    cp id_rsa.pub data/backup/.ssh/authorized_keys
    chown -R 1000:1000 data/backup

## Volumes

- Volume `/home/`
  - Contains the data for different users
- Volume `/etc/ssh`
  - Contains the keys of sshd. Mount it to have them persisted.
