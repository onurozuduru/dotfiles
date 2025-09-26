# My Dotfiles

Directory structure and setup is managed by simple tool [dothome](https://github.com/onurozuduru/dothome).

## Description of Files and Directories

|File/Directory|Description                                                                                                |
|--------------|-----------------------------------------------------------------------------------------------------------|
|.profile      | Adds following directories to `$PATH` if they exist: `$HOME/bin`, `$HOME/.local/bin`, `/usr/local/go/bin`.|
|.bashrc       | Sets prompt, includes files under `.bash_config` and `.bash_config/work` if they exist.                   |
|.bash_config/ | Stores files for `aliases`, `functions`, `env`.                                                           |
|.config/nvim/ | Neovim config based on [AstroNvim user template](https://github.com/AstroNvim/template).                  |

## Bash Configuration Logic

```mermaid
flowchart-elk LR
%% Main flow
  BASHRC[bashrc] --> PS1{Does .bash_config/set_decorated_ps1 exist?}
  PS1 --> ENV{Does .bash_config/env exist?}
  ENV --> ALIASES{Does .bash_config/aliases exist?}
  ALIASES --> FUNCTIONS{Does .bash_config/functions exist?}
  FUNCTIONS --> WSL{Is it WSL where .bash_config/wsl exists?}
  WSL --> WORK{Does .bash_config/work/bashrc exist?}
  WORK --> FZF(Source FZF files)
  FZF --> COMP(Source bash completion)
  COMP --> DONE[Done]
%% Yes branch
  PS1 --> |Yes| SOURCE(Source the file)
  ENV --> |Yes| SOURCE
  ALIASES --> |Yes| SOURCE
  FUNCTIONS --> |Yes| SOURCE
  WSL --> |Yes| SOURCE
  WORK --> |Yes| SOURCE
%% No branch
  PS1 --> |No| CONTINUE(Continue)
  ENV --> |No| CONTINUE
  ALIASES --> |No| CONTINUE
  FUNCTIONS --> |No| CONTINUE
  WSL --> |No| CONTINUE
  WORK --> |No| CONTINUE
```
