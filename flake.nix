{
  description = "Device Configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    sops-nix = {
       url = "github:Mic92/sops-nix";
       inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, sops-nix, ... }@ inputs: 
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
    };
}
