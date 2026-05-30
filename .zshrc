PS1='%F{166}%B%n';      # print username
PS1+='%f at ';
PS1+='%F{71}%m';        # print hostname
PS1+='%f in ';
PS1+='%F{141}%~ ';      # current directory
PS1+=$'\n';
PS1+='%f-> %b';
export PS1;

# ------ PATH ------
# Use local installed Python/tools instead of macOS defaults
export PATH="/usr/local/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"

# Autocompletions and suggestions
# autoload -Uz compinit
# compinit

# ------ PLUGINS ------
zsh_plugins=(
  # Initializes zsh completions.
  mattmc3/ez-compinit

  # Extra completion definitions.
  # Must load before ez-compinit because ez-compinit runs compinit.
  zsh-users/zsh-completions

  # Autosuggestions as you type.
  zsh-users/zsh-autosuggestions
)

# Completion style for ez-compinit
# Set an ez-compinit completion style to configure how completions are displayed
zstyle ':plugin:ez-compinit' 'compstyle' 'zshzoo'

# Clone and source plugins
ZSH_PLUGINS_HOME=${ZDOTDIR:-$HOME}/.zsh_plugins

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

  source "$plugin_dir/${zplugin:t}.plugin.zsh"
done
