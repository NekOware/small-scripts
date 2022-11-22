#
# > NekO's quick luvit env setup script. :)
#   - This is a preset for my discord bot tests.
#   - Feel free to use this for whatever ¯\_(ツ)_/¯
# 
# --- PACKAGES BELOW ---

from_lit=(
  luvit/pretty-print luvit/secure-socket creationix/coro-http
  SinisterRectus/discordia
)

from_git=(
  https://github.com/Bilal2453/discordia-interactions.git
  https://github.com/GitSparTV/discordia-slash.git
)

# --- PACKAGES ABOVE ---
#
# --- Setup of environment below ---

# If `not file "./main.lua"` then create it.
[ ! -f ./main.lua ] && >./main.lua

# If `not file "./luvit" or not file "./lit"` then run Luvit download script.
[ ! -f ./luvit -o ! -f ./lit ] && curl -L https://github.com/luvit/lit/raw/master/get-lit.sh | sh

# If `not directory "./deps"` then create it.
[ ! -d ./deps ] && mkdir deps

# Function to "git clone Arg[1]", delete files `".git", ".gitignore", ".vscode", "README.md" and "LICENSE"` from the gotten directory and then move the cloned directory to the "./deps/" directory.
dep_from_git(){ local pre="[dep_from_git]:"; echo "$pre Installing \"$1\" from git."; local dirname=$(echo "${1:19:-4}" | grep -oE '[^/]+$'); git clone $1 && rm -rf "./$dirname/"{.git,.gitignore,.vscode,README.md,LICENSE} && mv "./$dirname" ./deps; echo "$pre Finished installing \"$1\" from git."; }

# If var `from_luvit` exists and contains more than 0 entries then: Run Luvit package (or dep) manager command to install given Luvit packages in list `from_lit`
if [ ! -z ${from_lit+x} ]&&(("${#from_lit[@]}"> 0)); then ./lit install ${from_lit[*]}; else echo "0:[Luvit_Env_Setup]: No Luvit packages (deps) to get."; fi

# If var `from_git` exists and contains more than 0 entries then: Run `dep_from_git` function for each entry in list `from_git`.
if [ ! -z ${from_git+x} ]&&(("${#from_git[@]}"> 0)); then for i in "${from_git[@]}"; do dep_from_git "$i"; done; fi

# --- EOF ---
