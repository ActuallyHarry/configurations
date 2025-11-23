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

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        # IMPORTANT: we're using "libgbm" and is only available in unstable so ensure
        # to have it up-to-date or simply don't specify the nixpkgs input
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
    };
  };

  };

  outputs = { self, nixpkgs, sops-nix, home-manager, nix-colors, zen-browser, ... }@ inputs: 
    let
      system =  "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = { 
          allowUnfree = true;
        };
      };
    in  {

      #####################################################################
      # MACHINES
      #####################################################################
      
      nixosConfigurations = {

        # Network Manager
        sentinel = nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs; inherit system; };
          modules = [ ./machines/sentinel/configuration.nix ];
        };

        vanguard  = nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs; inherit system; };

          modules = [
            ./machines/vanguard/configuration.nix
          ];
        };

        nomadica  = nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs; inherit system; };

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
          extraSpecialArgs = { inherit nix-colors; inherit zen-browser;};
          modules = [
            ./users/harry/home.nix
          ];
       };
     };
  };
}
