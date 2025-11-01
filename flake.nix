# flake.nix
{
  description = "My Home Manager configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.11";
    # nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    mac-app-util.url = "github:hraban/mac-app-util";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl = {
      url = "github:nix-community/nixGL";
    };
  };

  outputs = {
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    mac-app-util,
    nixgl,
    ...
  }: let
    lib = nixpkgs.lib;
    system = "x86_64-linux";
    #system = "aarch64-linux";
    #system = "aarch64-darwin";
    unstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfreePredicate = pkg:
        builtins.elem (lib.getName pkg) [
          "snowsql"
          "intelephense"
        ];
    };
    nixgl-pkgs = import nixgl.inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };

    nixgl-custom = import nixgl {
      pkgs = nixgl-pkgs;
    };
  in {
    defaultPackage.x86_64-linux = home-manager.defaultPackage.x86_64-linux;
    defaultPackage.aarch64-linux = home-manager.defaultPackage.aarch64-linux;
    defaultPackage.aarch64-darwin = home-manager.defaultPackage.aarch64-darwin;
    homeConfigurations = {
      linux = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        extraSpecialArgs = {
          inherit unstable;
          nixgl = (import nixgl { pkgs = nixgl-pkgs; });
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
          mac-app-util.homeManagerModules.default
          ./home.nix
          ./mac.nix
        ];
      };
      work = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          inherit system;
        };
        extraSpecialArgs = {
          inherit unstable;
        };
        modules = [
          mac-app-util.homeManagerModules.default
          ./home.nix
          ./work.nix
        ];
      };
    };
  };
}
