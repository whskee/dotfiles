PS1='%F{166}%B%n';      # Print USERNAME instead of %n to avoid showing the domain part of the username.
PS1+='%f at ';
PS1+='%F{71}%m';        # Print HOSTNAME instead of %M to avoid showing the domain part of the hostname.
PS1+='%f in ';
PS1+='%F{141}%~ ';      # Print ~ instead of the full path for the current directory.
PS1+=$'\n';
PS1+='%f-> %b';
export PS1;

# ------------------------------------ PATH ------------------------------------
# Use local installed Python/tools instead of macOS defaults
export PATH="/usr/local/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"


# ------------------------------ COMPLETION PATHS ------------------------------
ZSH_PLUGINS_HOME=${ZDOTDIR:-$HOME}/.zsh_plugins
ZSH_COMPLETIONS_DIR=${ZDOTDIR:-$HOME}/.zsh/completions

mkdir -p "$ZSH_PLUGINS_HOME" "$ZSH_COMPLETIONS_DIR"

# Generated completions live here:
#   ~/.zsh/completions/_gh
#   ~/.zsh/completions/_docker
fpath=("$ZSH_COMPLETIONS_DIR" $fpath)


# ------------------------------------ PLUGINS ------------------------------------
zsh_plugins=(
  zsh-users/zsh-completions       # Extra completion definitions. Must be available before ez-compinit runs compinit.
  mattmc3/ez-compinit             # Initializes zsh completions.
  zsh-users/zsh-autosuggestions   # Shows previous commands as suggestions while you type
)

# Completion style for ez-compinit. Set an ez-compinit completion style to configure how completions are displayed
zstyle ':plugin:ez-compinit' 'compstyle' 'zshzoo'

# ------------------------ Make TAB completion less noisy ------------------------
# unsetopt AUTO_LIST        # Do not immediately print every possible match
# setopt BASH_AUTO_LIST     # Show matches only after pressing TAB twice
# setopt AUTO_MENU          # Repeated TAB cycles through matches
# setopt LIST_PACKED        # Use less vertical space when lists are shown

# for zplugin in $zsh_plugins; do
#   [[ -d $ZSH_PLUGINS_HOME/$zplugin ]] \
#     || git clone https://github.com/$zplugin $ZSH_PLUGINS_HOME/$zplugin
#   source $ZSH_PLUGINS_HOME/${zplugin}/${zplugin:t}.plugin.zsh  
# done

for zplugin in $zsh_plugins; do
  plugin_dir="$ZSH_PLUGINS_HOME/$zplugin"

  if [[ ! -d "$plugin_dir" ]]; then
    mkdir -p "${plugin_dir:h}"
    git clone "https://github.com/$zplugin" "$plugin_dir"
  fi

  if [[ "$zplugin" == "zsh-users/zsh-completions" ]]; then
    fpath=("$plugin_dir/src" $fpath)
    continue
  fi

  plugin_file="$plugin_dir/${zplugin:t}.plugin.zsh"

  if [[ -f "$plugin_file" ]]; then
    source "$plugin_file"
  else
    echo "Missing plugin file: $plugin_file"
  fi
done

# ------------------ GitHub & Docker COMPLETIONS ------------------
refresh-completions() {
  mkdir -p "$ZSH_COMPLETIONS_DIR"

  if command -v gh >/dev/null 2>&1; then
    gh completion -s zsh >| "$ZSH_COMPLETIONS_DIR/_gh"
  fi

  if command -v docker >/dev/null 2>&1; then
    docker completion zsh >| "$ZSH_COMPLETIONS_DIR/_docker"
  fi
}

# Generate completions only if they do not already exist.
[[ -f "$ZSH_COMPLETIONS_DIR/_gh" ]] || refresh-completions
[[ -f "$ZSH_COMPLETIONS_DIR/_docker" ]] || refresh-completions

# Maven wrapper should reuse Maven's normal completion.
if (( $+functions[compdef] )); then
  compdef _mvn mvn
  compdef _mvn mvnw
  compdef _mvn ./mvnw
fi
