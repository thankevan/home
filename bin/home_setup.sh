#!/bin/bash

BASH_BACKUP_DIR="bash_bak"
EMAIL=""

IS_WSL=0

if [[ $(uname -r) = *Microsoft ]]; then 
	IS_WSL=1
fi

function check_if_home_directory {
	echo ""
	echo "CHECK IF HOME DIRECTORY"
	echo "-----------------------"

	if [ "$PWD" != "$HOME" ]; then
		echo "You must run this from your home directory."
		exit 1
	fi
}


function setup_ssh_key {
	echo ""
	echo "SETUP SSH KEY"
	echo "-------------"

	if [ -e ".ssh/id_rsa.pub" ]; then
		echo "ssh key already exists at: .ssh/id_rsa.pub"
		return 0
	fi

	read -p 'Email address for ssh-key tag: ' EMAIL
	if [ "$EMAIL" -eq "" ]; then
		exit 1 "Error: email address cannot be blank"
	fi
	echo "Email: $EMAIL"
	ssh-keygen -t rsa -b 4096 -C "$EMAIL"
}

function instruct_ssh_key_to_github {
	echo ""
	echo "ADD SSH KEY TO GITHUB"
	echo "---------------------"
	
	if [ -d ".git" ]; then
		echo "Git directory detected - skipping adding ssh key to github"
		return 0
	fi
	
	if [ $IS_WSL == 1 ]; then
		powershell.exe /c start "https://github.com/settings/keys"
		cat ~/.ssh/id_rsa.pub | clip.exe
	fi
	read -p "ssh key copied to clipboard, add to github, then hit enter"
}

function backup_bash_files {
	echo ""
	echo "BACKUP BASH FILES"
	echo "-----------------"

  if [ -d "$BASH_BACKUP_DIR" ]; then
		echo "Home files backup directory exists - skipping backup of dot files"
		return 0
  fi

	if [ ! -d "$BASH_BACKUP_DIR" ]; then
		echo "Creating $BASH_BACKUP_DIR"
		mkdir "$BASH_BACKUP_DIR"
	fi
	
	if [ -d "$BASH_BACKUP_DIR" ]; then
		echo "Verified $BASH_BACKUP_DIR exists"
	else
		echo "Error: could not create directory $BASH_BACKUP_DIR"
		exit 1
	fi

	# copy old files to backup
	cp .bashrc $BASH_BACKUP_DIR/
	cp .profile $BASH_BACKUP_DIR/
}

function clone_home {
	echo ""
	echo "CLONE HOME"
	echo "-----------------"
	
	if [ -d ".git" ]; then
		echo "Git directory detected - skipping clone of home"
		return 0
	fi
  
  read -p 'Github home repo: ' GITHUB_HOME_REPO
  read -p 'Home github user.name: ' GITHUB_HOME_USER
	read -p 'Home github user.email: ' GITHUB_HOME_EMAIL

	git init
	git remote add origin "$GITHUB_HOME_REPO"
	git fetch origin
	git checkout origin/master -ft
	
  git config user.name "$GITHUB_HOME_USER"
	git config user.email "$GITHUB_HOME_EMAIL"
}

function setup_git_global_configs {
	echo ""
	echo "SETUP GLOBAL GIT CONFIGS"
	echo "------------------------"

	if [ "" != "`git config --global user.email`" ]; then
		echo "Git global email detected - skipping config setup"
		return 0
	fi

	read -p 'Global github user.name: ' GITHUB_GLOBAL_USER
	read -p 'Global github user.email: ' GITHUB_GLOBAL_EMAIL

	git config --global user.name "$GITHUB_GLOBAL_USER"
	git config --global user.email "$GITHUB_GLOBAL_EMAIL"

	# change how push works to automatically set upstream (needs >git push -u on the first push)
	git config --global push.default current

	# other things to try from: git help config
	# git config --global branch.autoSetupMerge always
	# git config --global branch.autoSetupRebase always
}

check_if_home_directory
setup_ssh_key
instruct_ssh_key_to_github
backup_bash_files
clone_home
setup_git_global_configs

echo "DONE"

