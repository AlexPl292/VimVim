# VimVim.vim

An IdeaVim plugin for Vim.

Now you can finally integrate Vim motions functionality into the Vim editor.

IdeaVim is a Vim plugin for IntelliJ IDEA, and other JetBrains IDEs.  
FleetVim is a Vim plugin for Fleet.  
VimVim is a Vim plugin for Vim.

It`s like win-win, but VimVim.

Created by Alex Plate, maintainer of the [IdeaVim](https://github.com/JetBrains/ideavim) plugin.

[IdeaVim](https://github.com/JetBrains/ideavim) is a Vim engine for JetBrains IDEs. Known for their extensive features and ready-to-use environment, JetBrains IDEs make IdeaVim a powerful tool for bringing Vim functionality into modern development workflows.

# Usage

- Install the plugin
- Run Vim using `vim --cmd "let g:enable_vimvim = 1"`

NOTE: Vim motions is a powerful and complex tool, and this plugin is **disabled by default**. To enable it, you must provide an additional parameter at startup.  
**Warning**: Do not run Vim with the `vimvim` plugin enabled unless you are familiar with Vim motions.

## Installation

You can install the `VimVim` plugin using various plugin managers.

### **vim-plug**
Add the following line to your `~/.vimrc` (or `~/.config/nvim/init.vim` for Neovim):
```
Plug `AlexPl292/VimVim`
```
Then, restart Vim and run:
```
:PlugInstall
```

### **Vundle**
Add the following line to your `~/.vimrc`:
```
Plugin `AlexPl292/VimVim`
```
Then, restart Vim and run:
```
:PluginInstall
```

### **Pathogen**
Clone the repository into your `~/.vim/bundle/` directory:
```
git clone https://github.com/AlexPl292/VimVim ~/.vim/bundle/VimVim
```

### **Lazy.nvim (for Neovim)**
Add the following to your Neovim `lua/plugins.lua` configuration:
```
{
    `AlexPl292/VimVim`,
    lazy = false -- Load on startup
}
```
Then reload Neovim and run:
```
:Lazy sync
```

### **Manual Installation**
If you prefer to install the plugin manually:
```
git clone https://github.com/AlexPl292/VimVim ~/.vim/pack/plugins/start/VimVim
```

# Rationale for creating this plugin

Because I can.

# How it works

The original Vim always remains in normal mode and is treated as a simple editor with an API.
Any pressed key is passed to the key dispatcher, which determines what function to call. Inside these functions, API commands like `getpos` or `setline` are used to perform all needed actions.
In VimVim's insert mode, Vim itself remains in normal mode, and letters are inserted using the API.

# License

VimVim is licensed under the MIT license.


