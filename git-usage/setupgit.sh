#!/bin/sh

#global settings
NAME=whatacold
EMAIL=csuhgw@gmail.com

githubdir=~/.ssh/keys_github
github_id=$githubdir/id_rsa.github

test_github_key()
{
	echo -e "test your github key now...\n\
		need you to add hithub to your known host list\n\
		and type in your id's correspond password\n\
		Finally check if it's succeeded with ssh's output yourself!"
	if ! ssh -i $github_id git@github.com; then
		echo "testing github key failed"
		return
	fi
}

gen_sshkeys_for_github()
{
	#XXX '[]' or test of shell don't recognise '~'
	[ ! -d "$HOME/.ssh" ] && return

	backupdir=~/.ssh/keys_before_github
	mkdir -p "$backupdir"
	cp -fp ~/.ssh/id_rsa* $backupdir
	
	mkdir -p $githubdir

	echo "generating ssh keys for github now..."
	echo "NEED you to type password manually!"
	ssh-keygen -t rsa -C "$EMAIL" -f $github_id

	echo "setting up ssh config..."
	echo "Host github.com" >> ~/.ssh/config
	echo -e "\tIdentityFile $github_id" >> ~/.ssh/config

	echo "keygen done, please paste your public id to github now..."
}

config_git_globals()
{
	echo "configure git global settings now..."
	# Sets the default name for git to use when you commit
	git config --global user.name "$NAME"

	# Sets the default email for git to use when you commit
	git config --global user.email "$EMAIL"

	#Password cacheing
	# Set git to use the credential memory cache
	git config --global credential.helper cache
	# Set the cache to timeout after 1 hour (setting is in seconds)
	git config --global credential.helper 'cache --timeout=3600'
}

echo "configure git global settings[y/N]?"
read answer
case $answer in
	y|Y)
	config_git_globals
	;;
	n|N|"")
	#nop
	;;
	*)
	echo "treat your illegimate answer:$answer as NO"
	;;
esac

echo "generate sshkey for github ?[y/N]?"
read answer
case $answer in
	y|Y)
	gen_sshkeys_for_github
	;;
	n|N|"")
	#nop
	;;
	*)
	echo "treat your illegimate answer:$answer as NO"
	;;
esac

echo "test github key?[y/N]?"
read answer
case $answer in
	y|Y)
	test_github_key
	;;
	n|N|"")
	#nop
	;;
	*)
	echo "treat your illegimate answer:$answer as NO"
	;;
esac

