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
  if [ -z "$EMAIL" ]; then
    echo "ERROR: email address cannot be blank"
    exit 1
  fi
  echo "Email: $EMAIL"
  ssh-keygen -t rsa -b 4096 -C "$EMAIL"

  read -p 'Setup a second personal ssh-key? (y/n): ' SECONDSSH
  if [ "$SECONDSSH" == "y" ]; then
    read -p 'Email address for second ssh-key tag: ' EMAIL2
    if [ -z "$EMAIL2" ]; then
      echo "ERROR: email address cannot be blank"
      exit 1
    fi
    echo "Email: $EMAIL2"
    ssh-keygen -t rsa -b 4096 -C "$EMAIL2" -f ~/.ssh/id_rsa_personal.pub

    echo "# Default github account" >> ~/.ssh/config
    echo "Host github.com" >> /.ssh/config
    echo "   HostName github.com" >> /.ssh/config
    echo "   IdentityFile ~/.ssh/id_rsa" >> /.ssh/config
    echo "   IdentitiesOnly yes" >> /.ssh/config
    echo "" >> /.ssh/config
    echo "# Personal github account" >> /.ssh/config
    echo "Host github-personal" >> /.ssh/config
    echo "   HostName github.com" >> /.ssh/config
    echo "   IdentityFile ~/.ssh/id_rsa_pesonal" >> /.ssh/config
    echo "   IdentitiesOnly yes" >> /.ssh/config
  fi
}

function open_url_in_browser {
  if [ $ISWSL == 1 ]; then
    powershell.exe /c start "$1"
  fi

  if [ $ISCYG == 1 ]; then
    cygstart "$1"
  fi

  if [ $ISMAC == 1 ]; then
    open "$1"
  fi
}

function copy_file_to_clipboard {
  if [ $ISWSL == 1 ]; then
    cat "$1" | clip.exe
  fi

  if [ $ISCYG == 1 ]; then
    cat "$1" > /dev/clipboard
  fi

  if [ $ISMAC == 1 ]; then
    pbcopy < "$1"
  fi
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

  open_url_in_browser "$GITHUB_SETTINGS_URL"
  copy_file_to_clipboard "$HOME/.ssh/id_rsa.pub"
  read -p "ssh key copied to clipboard, add to github, then hit enter"

  if [ -e ~/.ssh/id_rsa_personal.pub ]; then
    open_url_in_browser "$GITHUB_SETTINGS_URL"
    copy_file_to_clipboard "$HOME/.ssh/id_rsa_personal.pub"
    read -p "personal ssh key copied to clipboard, add to github, then hit enter"
  fi
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

  # missed this in the past, making it bright yellow [33
  # 5 is to make it try to blink if blinking is supported
  # 7 inverts so it's black text on yellow background to make it stand out even more
  echo -e "\033[33;5;7m*******************************\033[0m"
  echo -e "\033[33;5;7m* Pick yes if given an option *\033[0m"
  echo -e "\033[33;5;7m*******************************\033[0m"
  git fetch origin
  git checkout origin/main -ft

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

  echo "#!/bin/bash" >> .bash_precustom
  echo "#!/bin/bash" >> .bash_custom

  # environment
  read -p 'Pick environment (DEV|TEST|PROD): ' ENV_LEVEL
  echo "export CODE_ENV=$ENV_LEVEL" >> .bash_precustom

  # screen
  read -p 'Skip screen? (1|<enter to not skip>): ' SKIP_SCREEN
  if [ "$SKIP_SCREEN" = "1" ]; then
    echo "export NOSCREEN=$SKIP_SCREEN" >> .bash_precustom
  fi

  # tmux
  read -p 'Skip tmux? (1|<enter to not skip>): ' SKIP_TMUX
  if [ "$SKIP_TMUX" = "1" ]; then
    echo "export NOTMUX=$SKIP_TMUX" >> .bash_precustom
  fi

  # mac
  if [ $ISMAC = 1 ]; then
    echo "export BASH_SILENCE_DEPRECATION_WARNING=1" >> .bash_precustom
  fi

  # personal github user
  PERSONAL_GITHUB_USER=""
  if [ -n "$GITHUB_HOME_USER" ]; then
    read -p 'Use $GITHUB_HOME_USER as PERSONAL_GITHUB_USER? (1|<enter for no>):' GITHUB_HOME_USER_AS_PERSONAL
    if [ "$GITHUB_HOME_USER_AS_PERSONAL" == "1" ]; then
      PERSONAL_GITHUB_USER="$GITHUB_HOME_USER"
    fi
  fi

  if [ -z "$PERSONAL_GITHUB_USER" ]; then
    read -p 'PERSONAL_GITHUB_USER (enter to skip):' PERSONAL_GITHUB_USER
  fi

  if [ -n "$PERSONAL_GITHUB_USER" ]; then
    echo "export PERSONAL_GITHUB_USER=$PERSONAL_GITHUB_USER" >> .bash_precustom
  fi

  # personal github email
  PERSONAL_GITHUB_EMAIL=""
  if [ -n "$GITHUB_HOME_EMAIL" ]; then
    read -p 'Use $GITHUB_HOME_EMAIL as PERSONAL_GITHUB_EMAIL? (1|<enter for no>):' GITHUB_HOME_EMAIL_AS_PERSONAL
    if [ "$GITHUB_HOME_EMAIL_AS_PERSONAL" == "1" ]; then
      PERSONAL_GITHUB_EMAIL="$GITHUB_HOME_EMAIL"
    fi
  fi

  if [ -z "$PERSONAL_GITHUB_EMAIL" ]; then
    read -p 'PERSONAL_GITHUB_EMAIL (enter to skip):' PERSONAL_GITHUB_EMAIL
  fi

  if [ -n "$PERSONAL_GITHUB_EMAIL" ]; then
    echo "export PERSONAL_GITHUB_EMAIL=$PERSONAL_GITHUB_EMAIL" >> .bash_precustom
  fi

  # personal github ssh address
  read -p 'PERSONAL_GITHUB_SSH_ADDRESS (enter to skip):' PERSONAL_GITHUB_SSH_ADDRESS
  if [ -n "$PERSONAL_GITHUB_SSH_ADDRESS" ]; then
    echo "export PERSONAL_GITHUB_SSH_ADDRESS=$PERSONAL_GITHUB_SSH_ADDRESS" >> .bash_precustom
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

  # git makes you set up what your pull strategy is now, opting for rebase
  git config --global pull.rebase true
}

function mac_setup {
  if [[ $ISMAC != 1 ]]; then
    return 0
  fi

  echo ""
  echo "DO MAC SETUP"
  echo "------------"

  mac_do_defaults_writes
  mac_install_homebrew
  mac_install_commands_via_brew
  mac_default_to_bash
}

function mac_do_defaults_writes {
  echo "DO DEFAULTS WRITES"

  # turn on file extensions in the finder
  echo "Show file extensions"
  defaults write NSGlobalDomain AppleShowAllExtensions -bool true

  killall Finder
}

function mac_install_homebrew {
  echo ""
  echo "MAC INSTALL HOMEBREW"
  echo "--------------------"

  if [ -n "$(command -v brew)" ]; then
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

  if [ -z "$(command -v brew)" ]; then
    echo "brew not installed"
    exit 1
  fi

  # This is for cameracontroller to fix webcam issues
  brew tap | grep cask-drivers || brew tap homebrew/cask-drivers

  for cmd in \
    bash-completion \
    tmux \
    gnu-sed \
    grep \
    "--cask rectangle" \
    "--cask iterm2" \
    "--cask cameracontroller" \
    wget; do

    brew list $cmd || brew install $cmd

  done
}

function mac_default_to_bash {
  echo ""
  echo "MAC DEFAULT TO BASH"
  echo "-------------------"

  chsh -s /bin/bash
}

function check_for_powerline_fonts {
  echo ""
  echo "POWERLINE"
  echo "---------"

  if [ "$POWERLINE_INSTALLED" == 1 ]; then
    echo "powerline set as installed"
    return 0
  fi

  echo -e "Powerline glyphs:\n\
    Code points Glyph   Description                Old code point
    U+E0A0      \xee\x82\xa0       Version control branch     (U+2B60 \xe2\xad\xa0 )\n\
    U+E0A1      \xee\x82\xa1       LN (line) symbol           (U+2B61 \xe2\xad\xa1 )\n\
    U+E0A2      \xee\x82\xa2       Closed padlock             (U+2B64 \xe2\xad\xa4 )\n\
    U+E0B0      \xee\x82\xb0       Rightwards black arrowhead (U+2B80 \xe2\xae\x80 )\n\
    U+E0B1      \xee\x82\xb1       Rightwards arrowhead       (U+2B81 \xe2\xae\x81 )\n\
    U+E0B2      \xee\x82\xb2       Leftwards black arrowhead  (U+2B82 \xe2\xae\x82 )\n\
    U+E0B3      \xee\x82\xb3       Leftwards arrowhead        (U+2B83 \xe2\xae\x83 )\n\
    "
  read -p "Do you see symbols above? (y)" IS_POWERLINE_INSTALLED

  if [ "$IS_POWERLINE_INSTALLED" == "y" ]; then
    echo "export POWERLINE_INSTALLED=1" >> .bash_precustom
  else
    echo "Check out https://github.com/ryanoasis/nerd-fonts"
    echo ""
    echo "For Windows, Inconsolata (use partial smoothing in cygwin):"
    echo "https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/Inconsolata"
    echo ""
    echo "For Mac:"
    echo "In iTerm Preferences->Profiles->Text:Text Rendering check:"
    echo "   Use built-in Powerline glyphs"
    echo "   Blinking text"
    echo ""
    echo "Alternately use, Monoco patched font:"
    echo "https://gist.github.com/lujiacn/32b598b1a6a43c996cbd93d42d466466"

    read -p ""
  fi
}

function run_all {
  check_if_home_directory
  mac_setup
  setup_ssh_key
  instruct_ssh_key_to_github
  backup_bash_files
  clone_home
  setup_custom_dot_files
  check_for_powerline_fonts
  setup_git_global_configs
}

to_run="$@"
if [ "$to_run" == "" ]; then
  to_run="run_all"
fi

$to_run
echo "DONE"

