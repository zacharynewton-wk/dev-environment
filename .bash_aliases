#!/bin/bash

# ------- #
# Aliases #
# ------- #

alias ll="ls -al"
alias cppath="pwd|pbcopy"
alias gitcode="git ls-files | xargs cloc"
alias chrome="open -a \"Google Chrome\""

# ----
# Dart
# ----
alias ddev="pub run dart_dev"
alias ddevservejs="pub run dart_dev serve --web-compiler=dart2js"
alias dartiumc='DART_FLAGS="--checked --load_deferred_eagerly" dartium'
alias pubclean='rm -r .pub/ && echo "Removed .pub/"; rm -r packages/ && echo "Removed packages/"; rm .packages && echo "Removed .packages"; pubcleanlock'
alias pubcleanlock='git ls-files pubspec.lock --error-unmatch &>/dev/null && echo "Not removing pubspec.lock - it is tracked" || (rm pubspec.lock && echo "Removed pubspec.lock")'
alias pubblame="pub get --packages-dir --verbosity solver | grep 'inconsistent' -A 2 | sed -e 's/\ |//g'"
alias pubrefresh="pubclean && pub get"
alias chromium="DART_FLAGS='--checked --enable_asserts' open -a '/usr/local/opt/dart/Chromium.app'"
alias socks="export SOX_CONTEXT=true"
alias nosocks="export SOX_CONTEXT="
alias asigtest="admin_client && sh ./tool/signals_test.sh"
alias cov="pub run dart_codecov_generator --packages=.packages test/*.dart && chrome coverage_report/index.html"

# ------
# Bigsky
# ------
alias runbigsky="dev_appserver.py --datastore_path=../bigsky-datastore/django_dev~big-sky.datastore dispatch.yaml bigskyf1.yaml bigskyf4.yaml app.yaml validationf1.yaml ../py-iam-services/iam-services.yaml ../notification-services/notification-services.yaml --enable_sendmail"
alias reset_ds="python tools/erase_reset_data.py --admin='zach.newton@workiva.com' --password='zach'"

# ----------
# Navigation
# ----------
alias notes="cd ~/Documents/Notes/"
alias admin_client="cd ~/workspaces/wf/admin_client/"
alias wksp_comp="cd ~/workspaces/wf/workspaces_components/"
alias wsdk="cd ~/workspaces/wf/wdesk_sdk/"
alias truss="cd ~/workspaces/wf/truss/"
alias web_skin="cd ~/workspaces/wf/web_skin_dart/"
alias s16="cd ~/Projects/s16-wgetter/"

# ------------
# Bash Profile
# ------------
alias vbp="vim ~/.bash_profile"
alias sbp="clear && source ~/.bash_profile"
alias vba="vim ~/.bash_aliases"
alias vbf="vim ~/.bash_functions"
alias vbc="vim ~/.bash_colors"

# -----
# Other
# -----
alias prettyjson="python -m json.tool"

