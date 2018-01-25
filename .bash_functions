#!/bin/bash

source ~/.bash_colors

# ---------
# Functions
# ---------

setupDockerEnvHelp() {
  echo -e "
${BOLD}-------------------------
Set up Docker environment
-------------------------${NC}
  First, make sure Docker is running.

${BOLD}Build environment file${NC}
${GREY}--------------------------------------------${NC}
  In the repo, mock a production environment by running 
  ${GREY}$  ${BLUE}cp env.template .env${NC}

${BOLD}Login to the workiva registry${NC}
${GREY}--------------------------------------------${NC}
  The docker image is stored on ${ZESTYGREEN}docker.workiva.net${NC}. 
  Login via the command line using your github username and gitub docker access token as the password.
  (Token should be found in your ${ORANGE}.gitconfig${NC} file or can be regenerated at ${ZESTYGREEN}https://dev.workiva.net/profile${NC})
  ${GREY}$  ${BLUE}docker login -u <github-username> docker.workiva.net${NC}

${BOLD}Setup Docker Network${NC}
${GREY}--------------------------------------------${NC}
  First, verify network is setup by running
  ${GREY}$  ${BLUE}docker network ls${NC}
  If the ${ORANGE}dev-portal${NC} network is not available, set it up with
  ${GREY}$  ${BLUE}docker network create --driver bridge dev-portal${NC}

${BOLD}Pull the development image${NC}
${GREY}--------------------------------------------${NC}
  ${GREY}$  ${BLUE}make pull${NC}

${BOLD}Install Go dependencies${NC}
${GREY}--------------------------------------------${NC}
  ${GREY}$  ${BLUE}make deps${NC}

${BOLD}Run it${NC}
${GREY}--------------------------------------------${NC}
Refer to the ${ORANGE}Makefile${NC} for more detailed information on almost all commands.
Commonly used commands:
  ${GREY}$  ${BLUE}make build-go${NC}
  ${GREY}$  ${BLUE}make test${NC}
  ${GREY}$  ${BLUE}make run ${GREY}#(CTRL-C to quit)${NC}
  ${GREY}$  ${BLUE}make run-nobuild ${GREY}#(CTRL-C to quit)${NC}

${BOLD}Test it${NC}
  ${GREY}$  ${BLUE}curl -i http://localhost:5001/v0/health${NC}

"
}

gitContributions() {
  for var in "$@"; do 
    echo "$var Contributions:"
    git log --author="$var" --pretty=tformat: --numstat | awk '{ add += $1; subs += $2; loc += $1 - $2 } END { printf "  added lines: \033[38;5;84m+%s\033[0m\n  removed lines: \033[38;5;197m-%s\033[0m\n  total lines: \033[38;5;45m%s\033[0m\n", add, subs, loc }' -
  done
}

renameBranch() {
  if [ "$1" == "-h" ]; then
    echo '''
Usage: renameBranch [-h] [-|currentBranchName] [newBranchName]

Options:
  -h : Show this help text

Current Branch Name:
  The first argument can be either a "-" or a branch name from the current repository.
  "-" will rename the currently checked out branch.

New Branch Name:
  The second argument is what the branch will be renamed to.
  
'''
    return
  fi
  if [ "$1" == "-" ]
  then
    BRANCH=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')
  else
    BRANCH="$1"
  fi
  git branch -m "$BRANCH" "$2"
  REMOTE_ORIGIN_EXISTS=$(git ls-remote --heads origin $BRANCH | wc -l)
  REMOTE_ORIGIN_EXISTS="$(echo -e "${REMOTE_ORIGIN_EXISTS}" | tr -d '[:space:]')"
  if [ "$REMOTE_ORIGIN_EXISTS" == "1" ]
  then
    git branch origin :"$BRANCH" "$2"
    git branch origin -u "$2"
  fi
  echo -e "${BLUE}${BRANCH}${NC} renamed to ${BLUE}${2}${NC}"
}

bigskySetupHelp() {
  echo -e "
Before trying to build, make sure you've run:
- ${BLUE}beforeBigsky ${GREY}# defined in ~/.bash_functions${NC}
- ${BLUE}pycleaner ${GREY}# for after pulls or moving files around${NC}
- ${BLUE}pip install -e .${NC}
- ${BLUE}pip install -r requirements_dev.txt ${GREY}# probably not necessary${NC}
- ${BLUE}ant link-libs ${GREY}# possibly called in ant full${NC}
To build, run either:
- ${BLUE}ant full ${GREY}# full bigsky build${NC}
- ${BLUE}ant quick ${GREY}# flex lazy build${NC}
To run bigsky:
- Call ${BLUE}runbigsky ${GREY}# defined in ~/.bash_aliases${NC}
- Go to ${ORANGE}localhost:8080${NC}
- Login with 
    - ${GREY}Username: ${NC}zach.newton@workiva.com
    - ${GREY}Password: ${NC}zach
- If login fails, be sure to run ${BLUE}reset_ds${NC}
"
}

beforeBigsky() {
  # virtualenvwrapper
  # Don't let Mac python (in /usr/bin) supercede brew's python (/usr/local/bin)
  echo "Setting virtual environment python wrapper..."
  export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python

  # Sets the working directory for all virtualenvs
  echo "Setting virtual environment home directory"
  export WORKON_HOME=$HOME/.virtualenvs

  # Sources the virtualenvwrapper so all the commands are available in the shell
  echo "Sourcing virtual environment wrapper..."
  source /usr/local/bin/virtualenvwrapper.sh

  # Node Version Manager CL access
  echo "Managing node version..."
  export NVM_DIR=~/.nvm
  . $(brew --prefix nvm)/nvm.sh

  # Expand Maven memory
  echo "Expanding Maven memory permissions..."
  export MAVEN_OPTS="-Xmx4096m -Xss1024m -XX:MaxPermSize=128m"

  # Set M2_HOME
  echo "Setting Maven home..."
  M2_HOME="/usr/local/Cellar/maven30/3.0.5/libexec"

  # Set virtual environment
  echo "Working on virtual environment \"Sky\""
  workon sky
}

cleanBigskyBuild() {
  echo "Cleaning python..."
  pycleaner
  echo "Installing environment dependencies..."
  pip install -e .
  echo "Installing dev requirements..."
  pip install -r requirements_dev.txt
  echo "Building bigsky..."
  ant full
}

commandX() {
  TIMES=$1
  for ((i=1;i<=TIMES;i++))
  do
    eval "$2"
  done
}

countToTen() {
  for var in {1..10}
  do
    varLen=${#var}
    EXTRASPACE=${84-$varLen}
    spaces=`printf ' %.0s' {1..$EXTRASPACE}`
    printf "\r$var$spaces"
    sleep 1
  done
  echo ""
}

countFromTen() {
  for var in {10..1}
  do
    varLen=${#var}
    EXTRASPACE=${84-$varLen}
    spaces=`printf ' %.0s' {1..$EXTRASPACE}`
    printf "\r$var$spaces"
    sleep 1
  done
  echo ""
}

colorizeRandom() {
  while read data
  do
    NUMBER=$(($RANDOM*255/32767+1)) 
    COLOR="\033[38;5;${NUMBER}m"
    echo -e "${COLOR}${data}${NC}"
  done 
}

testJSON() {
  echo -e "
{
  \"hello\": \"world\",
  \"string\": \"string\",
  \"type\": \"print\",
  \"number\": 40,
  \"boolean\": true,
  \"object\": {
    \"value1\": 1,
    \"value2\": \"2\"
  }
}{
  \"hello\": \"world\",
  \"string\": \"word\",
  \"type\": \"error\",
  \"number\": 41,
  \"boolean\": false
}{
  \"hello\": \"world\",
  \"string\": \"two words\",
  \"type\": \"print\",
  \"number\": 42,
  \"boolean\": false
}
"
}

colorizeJSON() {
  sedKeyReg='\(.*\)\(".*"\)\(:.*\)'
  sedStringReg='\(.*".*".*: \)\(".*"\)\(.*\)'
  sedNumberReg='\(.*".*".*: \)\([0-9][0-9]*\)\([^"]*\)'
  declare -a sedRegexps ; declare -a replacecolors
  sedRegexps[0]="$sedKeyReg" ; replacecolors[0]="$JSON_KEY_COLOR"
  sedRegexps[1]="$sedStringReg" ; replacecolors[1]="$JSON_STRING_COLOR"
  sedRegexps[2]="$sedNumberReg" ; replacecolors[2]="$JSON_NUMBER_COLOR"
  while read
  do
    data="$REPLY"
    for ((i=0;i<${#sedRegexps[@]};++i))
    do
      keyColor="${replacecolors[$i]}"
      keyRegexp=${sedRegexps[$i]}
      data=$(sed "s/$keyRegexp/\\1${keyColor}\\2${ESCAPED_NC}\\3/g" <<< "$data")
    done
    printf "$data\n"
  done
}

formatJSON() {
  CURRENT_OBJ=""
  errorRegexp=".*\"type\"\: \"error\".*" 
  while read
  do
    data="$REPLY"
    if [ "$data" == "}{" ] || [ "$data" == "}" ]
    then
      if [[ $CURRENT_OBJ =~ $errorRegexp ]]
      then
        JSON_KEY_COLOR="$ESCAPED_RED"
      fi
      printf "{$CURRENT_OBJ}" | prettyjson | colorizeJSON
      JSON_KEY_COLOR="$ESCAPED_SOFTGREEN"
      CURRENT_OBJ=""
    elif [ "$data" != "{" ]
    then
      CURRENT_OBJ="$CURRENT_OBJ $data"
    fi
  done
}

asigtest1() {
  export AUTO_URL="https://admin.wk-dev.wdesk.org/a/QWNjb3VudB81NzA2MTc2MDkzMjI0OTYw/recent"
  # Parse args
  for arg in "$@"
  do
    case $arg in
    --help|-h) # Show asigtest help
      echo -e " 
usage: asigtest [--local | -l] [--help | -h]

Run admin_client signals tests.

${GREEN}[no args]${NC}: runs tests on admin.wk-dev.wdesk.org
${GREEN}  --local${NC}: runs tests on localhost:8080
${GREEN}   --help${NC}: shows this help dialogue

NOTES:
 - Sauce credentials
   - Make sure your SauceLabs credentials are exported to environment variables
     - ${BLUE}export SAUCE_USERNAME=\"username\"${NC}
     - ${BLUE}export SAUCE_ACCESS_KEY=\"sauce-labs-generated-access-key\"${NC}
 - To run locally, make sure you do the following:
   - Terminal Tab 1: run ${BLUE}ddev serve${NC}
   - Terminal Tab 2: run ${BLUE}sc${NC}
   - Terminal Tab 3: run ${BLUE}dartiumc${NC}
   - Open dartium and go to ${BLUE}localhost:8080${NC}, wait for page to load
   - Terminal Tab 4: run ${BLUE}asigtest --local${NC}
"
      return
      ;;
    --local|-l) # Run tests locally
      export AUTO_URL="http://localhost:8080/a/QWNjb3VudB81NzA2MTc2MDkzMjI0OTYw/recent"
      ;;
    esac
  done
  # Run tests
  if hash ac 2>/dev/null; then
    ac # Run 'ac' alias if it exists to navigate into admin_client
  fi
  # Navigate into signals test folder  
  cd test/signals/
  export TEST_SERVER="wkdev"
  export WDESK_USERNAME='ws_user1'
  export WDESK_PASSWORD='W0rkiva!'
  # Get signals dependencies
  pub get
  pub run w_webdriver_utils:wd_runner --no-tunnel -r --browser-name 'chrome' --version 'latest-1' -p 'Windows 7' --report-directory ~/workspaces/testing/test-reports/chrome/ test/ | formatJSON
  printf "\n"
  if hash ac 2>/dev/null; then
    ac # If 'ac' alias exists, navigate back to admin_client
  else
    cd ../.. # Otherwise, just go back up from test/signals directory
  fi
  printf "${GREEN}Tests Completed${NC}\n"
  printf "Run into strange ${RED}errors${NC}? Not sure the tests ran correctly? Try running ${BLUE}asigtest -h${NC} for help on getting everything set up\n" 
}

dadJoke() {
  echo -e "${GREY}---${NC}"
  curl -H "Accept: text/plain" https://icanhazdadjoke.com/
  echo ""
}

# ---
# Git
# ---
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
# Returns "|unmerged:N" where N is the number of unmerged local and remote
# branches (if any).
parse_git_unmerged() {
  local unmerged=`expr $(git branch --no-color -a --no-merged | wc -l)`
  if [ "$unmerged" != "0" ]
  then
    echo "|unmerged:$unmerged"
  fi
}
# Returns "|unpushed:N" where N is the number of unpushed local and remote
# branches (if any).
parse_git_unpushed() {
  local unpushed=`expr $( (git branch --no-color -r --contains HEAD; \
    git branch --no-color -r) | sort | uniq -u | wc -l )`
  if [ "$unpushed" != "0" ]
  then
    echo "|unpushed:$unpushed"
  fi
}
# Returns "*" if the current git branch is dirty.
parse_git_dirty() {
  [[ $(git diff --shortstat 2> /dev/null | tail -n1) != "" ]] && echo "*"
}
# Returns "|stashed:N" where N is the number of stashed states (if any).
parse_git_stash() {
  local stash=`expr $(git stash list 2>/dev/null| wc -l)`
  if [ "$stash" != "0" ]
  then
    echo "|stashed:$stash"
  fi
}
# Get the current git branch name (if available)
git_prompt() {
    echo "($(parse_git_branch)$(parse_git_dirty)$(parse_git_stash)) " #$(parse_git_unmerged)$(parse_git_unpushed)) "
}
