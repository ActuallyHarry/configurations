# Configurations

## Machine Lifecycle

### Deploy A Machine
1. Install nixos
2. Add the following to /etc/nixos/configuration.nix
  a. `nix.settings.experimental-features = [ "nix-command" "flakes" ];`
  b. `services.openssh.enable = true;`
  c. `git` into environment.pkgs
3. ssh into the machine
4. `ssh-keygen -t rsa -b 4096 -C "{github email}"`
5. `cat ~/.ssh/id_rsa.pub` and copy into deploy keys for the repository
6. `cd /etc/nixos`
7. `sudo mkdir configurations`
8. `sudo chown admin configurations`
9. `git clone git@github.com:ActuallyHarry/configurations.git`

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
