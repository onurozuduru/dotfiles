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
  BASHRC[bashrc] --> ENV{Does .bash_config/env exist?}
  ENV --> ALIASES{Does .bash_config/aliases exist?}
  ALIASES --> FUNCTIONS{Does .bash_config/functions exist?}
  FUNCTIONS --> WORK{Does .bash_config/work/bashrc exist?}
  WORK --> FZF(Source FZF files)
  FZF --> COMP(Source bash completion)
  COMP --> OMP{Does oh-my-posh command exist?}
  OMP --> DONE[Done]
%% Yes branch
  ENV --> |Yes| SOURCE(Source the file)
  ALIASES --> |Yes| SOURCE
  FUNCTIONS --> |Yes| SOURCE
  WORK --> |Yes| SOURCE
  OMP --> |Yes| SETOMP(Set oh-my-posh)
%% No branch
  ENV --> |No| CONTINUE(Continue)
  ALIASES --> |No| CONTINUE
  FUNCTIONS --> |No| CONTINUE
  WORK --> |No| CONTINUE
  OMP --> |No| CONTINUE
```
