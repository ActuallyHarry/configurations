{
  description = "Device Configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors.url = "github:misterio77/nix-colors";
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

    nvf = {
      url = "github:NotAShelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    authentik-nix = {
      url = "github:nix-community/authentik-nix";
    };

    copyparty.url = "github:9001/copyparty";
  };

  outputs = {
    self,
    nixpkgs,
    sops-nix,
    home-manager,
    nix-colors,
    stylix,
    nvf,
    nix-flatpak,
    authentik-nix,
    copyparty,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
      };
    };
  in {
    #####################################################################
    # MACHINES
    #####################################################################

    nixosConfigurations = {
      # Hypervisor Hosts
      centurion = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          inherit system;
        };

        modules = [
          ./machines/centurion/configuration.nix
        ];
      };

      auxilium = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          inherit system;
        };

        modules = [
          ./machines/auxilium/configuration.nix
        ];
      };

      facultus = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          inherit system;
        };

        modules = [
          ./machines/facultus/configuration.nix
        ];
      };

      # Network Manager
      sentinel = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          inherit system;
        };
        modules = [./machines/sentinel/configuration.nix];
      };

      vanguard = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          inherit system;
        };

        modules = [
          ./machines/vanguard/configuration.nix
        ];
      };

      horreum = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          inherit system;
        };

        modules = [
          ./machines/horreum/configuration.nix
        ];
      };

      spectaculum = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          inherit system;
        };

        modules = [
          ./machines/spectaculum/configuration.nix
        ];
      };

      praxis = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          inherit system;
        };

        modules = [
          ./machines/praxis/configuration.nix
        ];
      };

      nomadica = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          inherit system;
        };

        modules = [
          ./machines/nomadica/configuration.nix
        ];
      };
    };

    ######################################################
    #  Users
    ######################################################
    homeConfigurations = {
      "harry" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages."x86_64-linux";
        extraSpecialArgs = {
          inherit nix-colors;
          inherit nix-flatpak;
          inherit stylix;
          inherit nvf;
        };
        modules = [
          ./users/harry/home.nix
        ];
      };
    };
  };
}
