# Configurations

## File Structure
```
configurations/
├── flake.nix
├── flake.lock
├── README.md
├── modules/
│   ├── updates.nix
│   ├── admin.nix
│   ├── nix_features.nix
|   ├── keyboard.nix
│   ├── localisation.nix
│   └── ...
├── applications/
│   ├── git.nix
│   ├── ssh.nix
│   └── ...
├── systems/
│   ├── system-name/
│   │   ├── configuration.nix
│   │   └── hardware-configuration.nix (ln /etc/nixos/hardware.nix)
│   └── ...
└── lib/
    └── utils.nix
```
### Modules
Contains shared system wide configurations
### Applications
Contains application configuration
### Systems
Contains configuration.nix which only pulls in components form applications and modules, as well as any required specific configurations, includes a hardlink to hardware.nix which should be gitignored.
### Lib
Contians any helper functions required
