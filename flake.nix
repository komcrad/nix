# flake.nix
{
  description = "My Home Manager configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.05";
    # nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    nixgl.url = "github:nix-community/nixGL";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    nixgl,
    ...
  }: let
    lib = nixpkgs.lib;
    system = "x86_64-linux";
    #system = "aarch64-darwin";
    #pkgs = import nixpkgs {
    #  inherit system;
    #  overlays = [nixgl.overlay];
    #};
    unstable = import nixpkgs-unstable {inherit system;};
  in {
    defaultPackage.x86_64-linux = home-manager.defaultPackage.x86_64-linux;
    defaultPackage.aarch64-darwin = home-manager.defaultPackage.aarch64-darwin;
    homeConfigurations = {
      linux = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          inherit system;
          overlays = [nixgl.overlay];
        };
        extraSpecialArgs = {
          inherit unstable;
        };
        modules = [
          ./home.nix
          ./linux.nix
        ];
      };
      mac = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          inherit system;
        };
        extraSpecialArgs = {
          inherit unstable;
        };
        modules = [
          ./home.nix
          ./mac.nix
        ];
      };
    };
  };
}
