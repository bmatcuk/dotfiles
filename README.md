# My dotfiles
These dotfiles are configured for OSX, but you may find that some of it applies
to other *NIX systems. I'm using [ghostty] as my terminal, and the [catppuccin]
theme. The configuration relies on [Nerd Font] symbols; personally I'm using
[Monaspace] (which is installed by the Brewfile), but any [Nerd Font] will
work.

The Brewfile will install a suite of software I tend to install on all of my
machines. For development, I use [asdf] to manage CLI tool versions, [neovim]
as my editor, [zsh] as my shell, and [tmux] to make my terminal more powerful;
the latest version of these will be installed by the Brewfile, as well as a few
other command line tools I find useful as a developer:
* [bat] - like cat but better
* [fd] - like find but way easier
* [fzf] - fuzzy matching for file names and command completion
* [jq] - parse json on the command line
* [ripgrep] - like grep but way faster
* [thefuck] - for fixing common typos
* [tig] - for navigating git history
* [tldr] - like man pages but more condensed

The Brewfile will also install some other programs that I tend to install on
all of my machines, such as:
* [alfred] - like Spotlight but more powerful
* [discord] - for keeping in touch with friends
* [flux] - save your eyes from the blue light
* [keybase] - encryption with friends
* [obsidian] - for note taking
* [slack] - for work and play
* [stay] - make windows stay put, even when switching monitors
* [tailscale] - private vpn

## Installation
All of the software you'll need is installed by [homebrew], so the first thing
you'll want to do is install that. See the website for instructions.

Clone this repo to your home directory. The name you give the repo doesn't
matter, but it'll make your life easier if it's in your home directory. For
example, this will name the directory `~/.dotfiles`:
```bash
git clone --recurse-submodules https://github.com/bmatcuk/dotfiles.git ~/.dotfiles
```

Next, run the following in this directory to install all the software:
```bash
cd ~/.dotfiles
brew bundle
```

## Setup
After all of the software is installed, you'll need to run a few commands to
setup the software:

Install the tmux-256color.terminfo:
```bash
sudo tic -xe tmux-256color tmux-256color.terminfo
```

## dotfiles
Now that everything is setup, you can use [stow] to create symbolic links to
the dotfiles. These instructions assume that you've cloned this repo to your
home directory as suggested above. If you have not, you'll need to set [stow]'s
"target directory" to your home directory. See [stow]'s documentation.

Note that some of the dotfiles end up in shared directories, which might not
exist yet. For example, `~/.config` or `~/.local`. If these directories do not
exist, [stow] will do the simpliest thing, which is symlink them. Later, when
some other program tries to save something in those directories, they'll end up
copied into this dotfiles repo because of the symlink. To avoid that, we'll
create a few directories first:
```bash
mkdir -p ~/.config/nvim/lua/local

mkdir -p ~/.local/share
mkdir ~/.local/state

mkdir ~/.gnupg
chmod 0700 ~/.gnupg

mkdir ~/.ssh
```

dotfiles for each utility are in their own directory. For example, to install
my zsh dotfiles, you'd simply run the following while in this repo's
directory:
```bash
stow zsh
```

Each dotfile can be installed individually by running [stow] on the appropriate
directories.

In addition to configuration for various command line tools, I also have some
configuration for a few linting tools. These are located in directories named
after the programming language, such as javascript or css.

### bat
If you decide to use the bat dotfiles, you'll need to run the following after
running `stow bat`:
```bash
bat cache --build
```

### tmux
After running `stow tmux` and starting tmux, install plugins by typing
`prefix + I` - that's the tmux prefix (typically Ctrl+B) followed by Shift+i.

### nvim
My [neovim] config requires python2, python3, node, and rust, which can all be
installed via asdf. Mason is also configured to install gopls, which requires
go. But, if you do not have go installed, you'll just get a warning.

You'll also need to install the following python and node
packages. The first time you start neovim, it will automatically install all
the plugins. You may get an error or two, but they should go away automatically
as things are installed.
```bash
pip3 install pynvim
npm install -g neovim
```

### Fortune and Cowsay
The files for fortune and [cowsay] must be linked to the respective `share`
directories. If these were installed via [homebrew], the following will work:
```bash
stow -t "$(brew --prefix fortune)/share" fortune
stow -t "$(brew --prefix cowsay)/share/cowsay" cowsay
```

Otherwise, this will probably work:
```bash
stow -t /usr/local/share fortune
stow -t /usr/local/share cowsay
```

The [cowsay] files come from Paul Kaefer's excellent [cowsay-files] repo. I
have not included the true color cows, and I removed ghostbusters.cow and
vader.cow because my install of cowsay already included them.

## Local Modifications
Sometimes you want to make changes to configs on a per-machine basis. For
example, you might need some work-specific environment variables. Some configs
have support for importing files for this purpose so you don't need to worry
about accidentally committing these things to git:
* `~/.zshrc.local`
* `~/.gitconfig.local`
* `~/.ssh/config.local`
* `~/.config/nvim/local.vim`

## Some Manual Changes
Here are a few manual changes I make when setting up a new system:

### Set the Dock size and make the size immutable
```
defaults write com.apple.dock tilesize -int 32
defaults write com.apple.dock size-immutable -bool yes
killall Dock
```

[Monaspace]: https://monaspace.githubnext.com/
[Nerd Font]: https://github.com/ryanoasis/nerd-fonts
[alfred]: https://www.alfredapp.com/
[asdf]: https://asdf-vm.com/#/
[bat]: https://github.com/sharkdp/bat
[catppuccin]: https://catppuccin.com/
[cowsay-files]: https://github.com/paulkaefer/cowsay-files
[cowsay]: https://github.com/tnalpgge/rank-amateur-cowsay
[discord]: https://discord.com/
[fd]: https://github.com/sharkdp/fd
[flux]: https://justgetflux.com/
[fzf]: https://github.com/junegunn/fzf
[ghostty]: https://ghostty.org/
[homebrew]: https://brew.sh/
[jq]: https://stedolan.github.io/jq/
[keybase]: https://keybase.io/
[neovim]: https://neovim.io/
[obsidian]: https://obsidian.md/
[ripgrep]: https://github.com/BurntSushi/ripgrep
[slack]: https://slack.com/
[stay]: https://cordlessdog.com/stay/
[stow]: https://www.gnu.org/software/stow/
[tailscale]: https://tailscale.com/
[thefuck]: https://github.com/nvbn/thefuck
[tig]: https://jonas.github.io/tig/
[tldr]: https://tldr.sh/
[tmux]: https://tmux.github.io/
[zsh]: https://www.zsh.org/
