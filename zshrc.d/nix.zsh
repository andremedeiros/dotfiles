# nix
if [ -f /nix/var/nix/profiles/default/etc/profile.d/nix.sh ]; then
  . /nix/var/nix/profiles/default/etc/profile.d/nix.sh
fi

if [ ! -d "${HOME}/.nix-defexpr/channels/nixpkgs" ]; then
  nix-channel --add https://channels.nixos.org/nixpkgs-20.03-darwin nixpkgs
  nix-channel --update
fi

export NIX_PATH="nixpkgs=/Users/andremedeiros/.nix-defexpr/channels/nixpkgs"
