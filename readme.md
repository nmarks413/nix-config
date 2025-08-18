# nix config

this setup allows natalie and chloe to share common configuration between their
machines, but also share useful modules between each other.

```
lib/ # reusable functions
modules/ # reusable modules
    +-- home/    # home program configurations
    +-- macos/   # nix-darwin configurations
    +-- neovim/  # nvf configurations
    +-- nixos/   # linux configurations
    +-- shared/  # shared between nixos-rebuild & darwin-rebuild
users/
    +-- chloe/
    |   +-- user.nix               # info about her
    |   +-- configuration.nix      # for all hosts (system)
    |   +-- home.nix               # for all hosts (userspace)
    |   +-- vim.nix                # for neovim
    |   +-- sandwich/
    |   |   +-- configuration.nix  # per host
    |   |   +-- home.nix
    |   +-- paperback/
    |       ...
    +-- natalie/
        +-- user.nix               # info about her
        ...
```

A new machine can be added by adding a new definition in `flake.nix`. Note that
the user and host `configuration.nix` and `home.nix` files are

## macOS installation instructions

Install Nix using the upstream Nix (Pick "no" then "yes):

```
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | \
  sh -s -- install
```

While this installs, now is a good time to perform manual setup steps:

- Setup your SSH keys in `~/.ssh`
- Configure the device hostname in System Settings in
  - About -> Name
  - General -> Sharing -> Local Hostname
- Make sure you're logged into iCloud / Mac App Store
- `xcode-select --install` to make sure Git and other utilities are available.
- Optional: Disable app verification with `sudo spctl --master-disable`, then,
  go to System Settings -> Privacy to allow unsigned apps.

Once Nix is installed, open a new shell and clone the repository:

```
# Clone via HTTPs
git clone https://git.paperclover.net/clo/config.git
# With SSH Authentication
git clone git@git.paperclover.net:clo/config
```

The location of the cloned repository must match what is in your `user.nix`
file.

Setup `nix-darwin` using the `switch` helper:

```
./switch
```

## Neovim configuration

By default, neovim is configured to all machines in `$PATH`. Neovim can be run
directly via `nix run`, which skips needing to build the whole system
configuration.

```
nix run .#nvim-natalie  # run by user
./nvim                  # run based on your username
```
