#!/bin/sh

ls -d /home/* >/dev/null 2>/dev/null \
	|| { echo "No users configured. Exiting.";exit 1;}

for homedir in /home/*; do
	_NAME=$(basename $homedir)
	_UID=$(stat -c %u $homedir)
	_GID=$(stat -c %g $homedir)

	echo ">> Adding user ${_NAME} with uid: ${_UID}, gid: ${_GID}."
	addgroup -g ${_GID} ${_NAME}
	adduser  -u ${_UID} -G ${_NAME} -D -s '/bin/sh' ${_NAME}
	passwd -u ${_NAME}

	if [ -f "${homedir}/.ssh/authorized_keys" ]; then
		# add to every unprefixed key additional parameters
		sed -i 's/^\s*ssh-rsa/command="borg serve --restrict-to-path ~\/",no-pty,no-agent-forwarding,no-port-forwarding,no-X11-forwarding,no-user-rc ssh-rsa/' ${homedir}/.ssh/authorized_keys
	else
		echo "WARNING: No SSH authorized_keys found for ${_NAME}!"
	fi
done

ssh-keygen -A

[ -e /etc/ssh/sshd_config ] || cp /etc/ssh.sav/sshd_config /etc/ssh/sshd_config
[ -e /etc/ssh/ssh_config ]  || cp /etc/ssh.sav/ssh_config  /etc/ssh/ssh_config
[ -e /etc/ssh/moduli ]      || cp /etc/ssh.sav/moduli      /etc/ssh/moduli

exec $@
