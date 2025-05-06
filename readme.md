# nix config

meow.

## macOS installation instructions

Install Nix using the upstream nix (Pick "no" then "yes):

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
