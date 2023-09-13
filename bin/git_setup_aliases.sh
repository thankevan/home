#!/bin/bash

# Some good sources for aliases
# https://archive.kernel.org/oldwiki/git.wiki.kernel.org/index.php/Aliases.html
# https://snyk.io/blog/10-git-aliases-for-faster-and-productive-git-workflow/
# https://betterprogramming.pub/8-amazing-aliases-to-make-you-more-productive-with-git-3be35d1b7e51


# clear each alias first so you can replay

git config --global --unset alias.p
git config --global alias.p "push -u"

git config --global --unset alias.pf
git config --global alias.pf "push --force-with-lease"

git config --global --unset alias.ri
git config --global alias.ri "rebase -i"

git config --global --unset alias.ap
git config --global alias.ap "add --patch"

git config --global --unset alias.co
git config --global alias.co checkout

git config --global --unset alias.cb
git config --global alias.cb "checkout -b"

git config --global --unset alias.st
git config --global alias.st status

git config --global --unset alias.sst
git config --global alias.sst "status -sb"

git config --global --unset alias.last
git config --global alias.last "log -1 HEAD --stat"

git config --global --unset alias.vd
git config --global alias.vd "difftool -t vimdiff -y"

# show branches, sort by commit date, show last commit message, date, author
# options for committerdate: relative,local,default,iso,iso-strict,rfc,short
git config --global --unset alias.br
git config --global alias.br "branch --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(contents:subject) %(color:green)(%(committerdate:local)) [%(authorname)]' --sort=-committerdate"


# output global configs
git config --global --unset alias.gl
git config --global alias.gl "config --global -l"

# output global aliases
git config --global --unset alias.al
#git config --global alias.al "!git config --global -l | grep alias"
git config --global alias.al "!git config -l |grep -E '^alias' | cut -c 7- |grep --color=always -E '^[^=]+'"

# pretty logs
git config --global --unset alias.gr
git config --global alias.gr "log --graph --abbrev-commit --decorate --format=format:'%C(bold cyan)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(bold white)%s%C(reset) - %C(yellow)%an%C(reset)%C(auto)%d%C(reset)'"

# count commits, default to current branch
git config --global --unset alias.cc
git config --global alias.cc "!count_commits() { local curbranch=\`git rev-parse --abbrev-ref HEAD\`;git rev-list --count \${1:-\$curbranch}; }; count_commits"

# show file in from other branch
git config --global --unset alias.showother
git config --global alias.showother "!show_file_from_branch() { git show \$1:\$2; }; show_file_from_branch"


# call external apps
git config --global --unset alias.dup
git config --global alias.dup "!docker compose up"


# diff branch to branching point (diff to origin)
git config --global --unset alias.do
git config --global alias.showother "!show_file_from_branch() { git show \$1:\$2; }; show_file_from_branch"

