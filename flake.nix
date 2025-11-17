{
  description = "Device Configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=24.05";

    sops-nix = {
       url = "github:Mic92/sops-nix";
       inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-on-droid = {
      url = "github:nix-community/nix-on-droid/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nix-on-droid, sops-nix, ... }@ inputs: 
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
      };

     nixOnDroidConfigurations = {
       odyssey = nix-on-droid.lib.nixOnDroidConfiguration {
         pkgs = import nixpkgs { system = "aarch64-linux"; };
          modules = [ ./machines/odyssey/nix-on-droid.nix ];
       };
     };


    };
}
