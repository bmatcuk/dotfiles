# My dotfiles
These dotfiles are configured for OSX, but you may find that some of it applies
to other *NIX systems. I'm using [alacritty] as my terminal, and the [nord]
theme. The configuration relies on [Nerd Font] symbols; personally I'm using
[Hack] (which is installed by the Brewfile), but any [Nerd Font] will work.

The Brewfile will install a suite of software I tend to install on all of my
machines. For development, I use [asdf] to manage CLI tool versions, [neovim]
as my editor, [bash] as my shell, and [tmux] to make my terminal more powerful;
the latest version of these will be installed by the Brewfile, as well as a few
other command line tools I find useful as a developer:
* [bat] - like cat but better
* [docker] - installs Docker for Mac; no virtualbox required
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
* [flux] - save your eyes from the blue light
* [keybase] - encryption with friends
* [stay] - make windows stay put, even when switching monitors

## Installation
All of the software you'll need is installed by [homebrew], so the first thing
you'll want to do is install that. See the website for instructions.

Clone this repo to your home directory. The name you give the repo doesn't
matter, but it'll make your life easier if it's in your home directory. For
example, this will name the directory `~/.dotfiles`:
```bash
git clone https://github.com/bmatcuk/dotfiles.git ~/.dotfiles
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

To use the version of [bash] installed by [homebrew] instead of OSX's default
(outdated) version of bash, run:
```bash
echo "/usr/local/bin/bash" | sudo tee -a /etc/shells
chsh -s /usr/local/bin/bash
```

## dotfiles
Now that everything is setup, you can use [stow] to create symbolic links to
the dotfiles. These instructions assume that you've cloned this repo to your
home directory as suggested above. If you have not, you'll need to set [stow]'s
"target directory" to your home directory. See [stow]'s documentation.

dotfiles for each utility are in their own directory. For example, to install
my bash dotfiles, you'd simply run the following while in this repo's
directory:
```bash
stow bash
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

### bash and fzf
After installing fzf and running `stow bash`, you need to install the fzf bash
scripts:
```bash
$(brew --prefix fzf)/install --no-zsh --no-fish
```

Answer yes to auto-completion and key bindings, but answer no to updating the
shell configuration file.

### tmux
After running `stow tmux` and starting tmux, install plugins by typing
`prefix + I` - that's the tmux prefix (typically Ctrl+B) followed by Shift+i.

### nvim
Before running `stow nvim`, you'll want to create a directory for the nvim
config, otherwise [vim-plug] will end up creating a directory that'll be
symlinked back into this repo.
```bash
mkdir -p ~/.config/nvim
stow nvim
```

After running `stow nvim`, you'll need to install python3 and node (maybe via
asdf, homebrew, or your favorite method). Next, you'll need to install
[vim-plug] and then run:
```bash
pip3 install pynvim
nvim +PlugInstall +UpdateRemotePlugins
```

### gnupg
Like nvim, you'll want to create the config directory before running stow:
```bash
mkdir ~/.gnupg
chmod 0700 ~/.gnupg
stow gnupg
```

### Fortune and Cowsay
The files for fortune and [cowsay] must be linked using `/usr/local/share` as
the [stow] target directory. To do that, run:
```bash
stow -t /usr/local/share fortune
stow -t /usr/local/share cowsay
```

If you're on OSX and fortune/[cowsay] have been installed via [homebrew], stow
will complain that it does not "own" the appropriate directories because
they're already symlinks. Instead, you'll need to use the full path into the
[homebrew] "Cellar":
```bash
stow -t "$(brew --prefix fortune)/share" fortune
stow -t "$(brew --prefix cowsay)/share" cowsay
```

The [cowsay] files come from Paul Kaefer's excellent [cowsay-files] repo. I
have not included the true color cows, and I removed ghostbusters.cow and
vader.cow because my install of cowsay already included them.

## Local Modifications
Sometimes you want to make changes to configs on a per-machine basis. For
example, you might need some work-specific environment variables. Some configs
have support for importing files for this purpose so you don't need to worry
about accidentally committing these things to git:
* `~/.bash_profile.local`
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

[Hack]: http://sourcefoundry.org/hack/
[Nerd Font]: https://github.com/ryanoasis/nerd-fonts
[alacritty]: https://github.com/jwilm/alacritty
[alfred]: https://www.alfredapp.com/
[asdf]: https://asdf-vm.com/#/
[bash]: https://www.gnu.org/software/bash/
[bat]: https://github.com/sharkdp/bat
[cowsay-files]: https://github.com/paulkaefer/cowsay-files
[cowsay]: https://github.com/tnalpgge/rank-amateur-cowsay
[docker]: https://www.docker.com/community-edition
[fd]: https://github.com/sharkdp/fd
[flux]: https://justgetflux.com/
[fzf]: https://github.com/junegunn/fzf
[homebrew]: https://brew.sh/
[jq]: https://stedolan.github.io/jq/
[keybase]: https://keybase.io/
[neovim]: https://neovim.io/
[nord]: https://www.nordtheme.com/
[ripgrep]: https://github.com/BurntSushi/ripgrep
[stay]: https://cordlessdog.com/stay/
[stow]: https://www.gnu.org/software/stow/
[thefuck]: https://github.com/nvbn/thefuck
[tig]: https://jonas.github.io/tig/
[tldr]: https://tldr.sh/
[tmux]: https://tmux.github.io/
[vim-plug]: https://github.com/junegunn/vim-plug
