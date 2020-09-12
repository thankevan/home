#!/bin/bash

BASH_BACKUP_DIR="bash_bak"
EMAIL=""

ISBSD=0
ISMAC=0
ISCYG=0
ISWSL=0

if [ "FreeBSD" = `uname` ]; then
  ISBSD=1
fi

if [ "Darwin" = `uname` ]; then
  ISMAC=1
fi

if [[ `uname` == CYGWIN* ]]; then
  ISCYG=1
fi

if [[ $(uname -r) = *icrosoft* ]]; then
  ISWSL=1
fi


function check_if_home_directory {
  echo ""
  echo "CHECK IF HOME DIRECTORY"
  echo "-----------------------"

  if [ "$PWD" != "$HOME" ]; then
    echo "You must run this from your home directory."
    exit 1
  fi

  echo "Verified"
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
  if [ "$EMAIL" == "" ]; then
    echo "ERROR: email address cannot be blank"
    exit 1
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

  GITHUB_SETTINGS_URL="https://github.com/settings/keys"

  if [ $ISWSL == 1 ]; then
    powershell.exe /c start "$GITHUB_SETTINGS_URL"
    cat ~/.ssh/id_rsa.pub | clip.exe
  fi

  if [ $ISCYG == 1 ]; then
    cygstart "$GITHUB_SETTINGS_URL"
    cat ~/.ssh/id_rsa.pub > /dev/clipboard
  fi

  if [ $ISMAC == 1 ]; then
    open "$GITHUB_SETTINGS_URL"
    pbcopy < ~/.ssh/id_rsa.pub
  fi

  read -p "ssh key copied to clipboard, add to github, then hit enter"
}

function backup_bash_files {
  echo ""
  echo "BACKUP BASH FILES"
  echo "-----------------"

  if [ ! -d "$BASH_BACKUP_DIR" ]; then
    echo "Creating $BASH_BACKUP_DIR"
    mkdir "$BASH_BACKUP_DIR"
  fi

  if [ -d "$BASH_BACKUP_DIR" ]; then
    echo "Verified $BASH_BACKUP_DIR exists"
  else
    echo "ERROR: could not create directory $BASH_BACKUP_DIR"
    exit 1
  fi

  for file in \
    .profile \
    .bashrc \
    .bash_profile \
    .bash_logout \
    .inputrc \
    .noop; do

    if [ -f "$file" ]; then
      echo "Copying $file to $BASH_BACKUP_DIR (no clobber)"
      if [[ $ISMAC = 1 ]]; then
        cp -n "$file" "$BASH_BACKUP_DIR/"
      else
        cp --no-clobber "$file" "$BASH_BACKUP_DIR/"
      fi
    fi

  done

  if [ ! -f "$BASH_BACKUP_DIR/.profile" ]; then
    echo "ERROR: $BASH_BACKUP_DIR/.profile not found, backup existing files"
    exit 1
  fi
}

function clone_home {
  echo ""
  echo "CLONE HOME"
  echo "----------"

  if [ -d ".git" ]; then
    echo "Git directory detected - skipping clone of home"
    return 0
  fi

  read -p 'Github home repo clone link: ' GITHUB_HOME_REPO
  read -p 'Home github user.name: ' GITHUB_HOME_USER
  read -p 'Home github user.email: ' GITHUB_HOME_EMAIL

  git init
  git remote add origin "$GITHUB_HOME_REPO"
  git fetch origin
  git checkout origin/master -ft

  git config user.name "$GITHUB_HOME_USER"
  git config user.email "$GITHUB_HOME_EMAIL"
}

function setup_custom_dot_files {
  echo ""
  echo "SETUP CUSTOM DOT FILES"
  echo "----------------------"

  if [ -f ".bash_precustom" ]; then
    echo ".bash_precustom already exists, skipping"
    return 0
  fi

  read -p 'Pick environment (DEV|TEST|PROD): ' ENV_LEVEL
  read -p 'Skip screen? (1): ' SKIP_SCREEN
  read -p 'Skip tmux? (1): ' SKIP_TMUX

  echo "#!/bin/bash" >> .bash_precustom
  echo "#!/bin/bash" >> .bash_custom

  # .bash_precustom
  echo "export CODE_ENV=$ENV_LEVEL" >> .bash_precustom

  if [ "$SKIP_SCREEN" = "1" ]; then
    echo "export NOSCREEN=$SKIP_SCREEN" >> .bash_precustom
  fi

  if [ "$SKIP_TMUX" = "1" ]; then
    echo "export NOTMUX=$SKIP_TMUX" >> .bash_precustom
  fi

  if [ $ISMAC = 1 ]; then
    echo "export BASH_SILENCE_DEPRECATION_WARNING=1" >> .bash_precustom
  fi
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

function mac_setup {
  echo ""
  echo "DO MAC SETUP"
  echo "------------"

  mac_install_homebrew
  mac_install_commands_via_brew
  mac_default_to_bash
}

function mac_install_homebrew {
  echo ""
  echo "MAC INSTALL HOMEBREW"
  echo "--------------------"

  if [[ "$(command -v brew)" != "" ]]; then
    echo "homebrew already installed"
    return 0
  fi

  echo "Installing brew... see: https://brew.sh/"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
}

function mac_install_commands_via_brew {
  echo ""
  echo "MAC INSTALL COMMANDS VIA BREW"
  echo "-----------------------------"

  if [[ "$(command -v brew)" = "" ]]; then
    echo "brew not installed"
    exit 1
  fi

  for cmd in \
    gnu-sed \
    grep \
    wget; do

    brew install $cmd

  done
}

function mac_default_to_bash {
  echo ""
  echo "MAC DEFAULT TO BASH"
  echo "-------------------"

  chsh -s /bin/bash
}

function run_all {
  check_if_home_directory
  if [[ $ISMAC == 1 ]]; then
    mac_setup
  fi
  setup_ssh_key
  instruct_ssh_key_to_github
  backup_bash_files
  clone_home
  setup_custom_dot_files
  setup_git_global_configs
}

to_run="$@"
if [ "$to_run" == "" ]; then
  to_run="run_all"
fi

$to_run
echo "DONE"

