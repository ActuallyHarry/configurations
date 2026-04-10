# Configurations

## Machine Lifecycle

### Deploy A Machine
1. Install nixos
2. Add the following to /etc/nixos/configuration.nix
  - `nix.settings.experimental-features = [ "nix-command" "flakes" ];`
  - `services.openssh.enable = true;`
  - `git` into environment.pkgs
3. ssh into the machine
4. `ssh-keygen -t rsa -b 4096 -C "{github email}"`
5. `cat ~/.ssh/id_rsa.pub` and copy into deploy keys for the repository
6. `cd /etc/nixos`
7. `sudo mkdir configurations`
8. `sudo chown admin configurations`
9. `git clone git@github.com:ActuallyHarry/configurations.git`
10. `rm /etc/nixos/configurations/machines/{hostname}/hardware-configuration.nix`
11. `ln /etc/nixos/hardware-configuration.nix /etc/nixos/configurations/machines/{hostname}/hardware-configuration.nix`
12. `sudo nixos-rebuild switch --flake ./#{hostname}`
 
### Create New Machine Configuration
1. Create Branch from main of Name: machine-{hostname}
2. Add the following to flake.nix in the nixosConfigurations setting
```
{hostname} = nixpkgs.lib.nixosSystem {
  specialArgs = {inherit inputs; inherit system; };

  modules = [
    ./machines/{hostname}/configuration.nix
  ];
};
```
3. `mkdir /etc/nixos/configurations/machines/{hostname}`
4. `sudo ln /etc/nixos/hardware-configuration.nix /etc/nixos/configurations/machines/{hostname}/hardware-configuration.nix`
5. `chown admin /etc/nixos/configurations/machines/{hostname}/hardware-configuration.nix`
6. `cp template-configuration.nix /etc/nixos/configurations/machines/vanguard/configuration.nix`
7. `git add --all`
8. `sudo nixos-rebuild switch --flake ./#{hostname}`

### Update Procedure
1. `git pull origin  main`
2. `git checkout machine-{hostname}`
3. `git merge main`
4. `nix flake update`
5. `git add --all`
6. `sudo nixos-rebuild switch --flake ./#{hostname}`
7. commit and push to github
8. create pull request to main

> This way main should always be recreatable but will contain the most up to date lock file, but allows machines to be updated indpendantly on their own branch


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
├── machines/
│   ├── {system-name}/
│   │   ├── configuration.nix
│   │   └── hardware-configuration.nix (ln /etc/nixos/hardware.nix)
│   └── ...
└── lib/
    └── utils.nix
```
### Modules
Contains shared system wide configurations

#### sops
Requires an age key best to copy it from other machine but if need to genetate
- `mkdir -p ~/.config/sops/age`
- `nix shell nixpkgs#age -c age-keygen -o ~/.config/sops/age/keys.txt`
- IMPORTANT: Remove the comments in the file for using it with nix


### Applications
Contains application configuration

#### dns
- In order for DNS to start make sure that /etc/rndc.key is made - it as trouble sometimes

#### Rclone
- If needing to generate a password for an rclone mount you need to do this
- `nix shell nixpkgs#rclone`
- `rclone obscure {mysecretpassword}``

### Machines
Contains configuration.nix which only pulls in components form applications and modules, as well as any required specific configurations, includes a hardlink to hardware.nix which should be gitignored.
### Lib
Contains any helper functions required

