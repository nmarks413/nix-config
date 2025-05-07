# nix config

this setup allows natalie and chloe to share common configuration between their machines, but also share useful modules between each other.

```
lib/ # reusable functions
modules/ # reusable modules
    +-- macos/   # nix-darwin configurations
    +-- nixos/   # linux configurations
    +-- nixvim/  # neovim configurations
    +-- shared/  # shared between nixos-rebuild & nixos-rebuild
    +-- home-manager.nix # home program presets
users/
    +-- chloe/
    |   +-- user.nix               # info about her
    |   +-- configuration.nix      # for all hosts
    |   +-- home.nix               # for all hosts
    |   +-- sandwich/
    |   |   +-- configuration.nix  # per host
    |   |   +-- home.nix
    |   +-- paperback/
    |       ...
    +-- natalie/
        +-- user.nix               # info about her
        ...
```

A new machine can be added by adding a new definition in `flake.nix`. Note that the user and host `configuration.nix` and `home.nix` files are 

## macOS installation instructions

Install Nix using the upstream Nix (Pick "no" then "yes):

```
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | \
  sh -s -- install
```

Open a new shell and clone the repository:

```
# Install git + other command tools. (Used by many programs)
xcode-select --install

# Clone via HTTPs
git clone https://git.paperclover.net/clo/config.git
# With SSH Authentication
git clone git@git.paperclover.net:clo/config
```

Setup `nix-darwin`
```
# Tell nix-darwin where the flake is at.
sudo mkdir /etc/nix-darwin
sudo ln -s $(realpath flake.nix) /etc/nix-darwin/

# Enable configuration.
nix run .#darwin-rebuild switch
```

Additionally, it may be helpful to disable the unsigned app popup.
```
sudo spctl --master-disable
# then, go to System Settings -> Privacy to allow unsigned apps.
```
