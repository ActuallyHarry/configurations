{config, pkgs, zen-browser, ... }:
let
    mkExtensionSettings = builtins.mapAttrs (_: pluginId: {
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/${pluginId}/latest.xpi";
      installation_mode = "force_installed";
    });
in
{
  imports = [zen-browser.homeModules.beta];

  stylix.targets.zen-browser.enable = true;
  stylix.targets.zen-browser.profileNames = ["default"];

  programs.zen-browser = {
    enable = true;
    policies = {
      AutofillAddressEnabled = true;
      AutofillCreditCardEnabled = false;
      DisableAppUpdate = true;
      DisableFeedbackCommands = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DontCheckDefaultBrowser = true;
      NoDefaultBookmarks = true;
      OfferToSaveLogins = false;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      ExtensionSettings = mkExtensionSettings {
         "clipper@obsidian.md" = "web-clipper-obsidian";
      };
    };
    profiles.default = {
       search = {
         force = true;
         default = "ddg";
         engines = {
           nix-os = {
             name = "NixOS";
             urls = [{
               template = "https://search.nixos.org/packages";
               params = [
                 { name = "channel"; value = "unstable";}
                 { name = "query"; value = "{searchTerms}"; }
               ];
             }];
             icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
             definedAliases = [ "@nixos" ];
           };
           nix-home-manager = {
             name = "Nix Home Manager";
             urls = [{
               template = "https://home-manager-options.extranix.com";
               params = [
                 { name = "release"; value = "master"; }
                 { name = "query"; value = "{searchTerms}"; }
               ];
             }];
             iconMapObj."16" = "https://home-manager-options.extranix.com/images/favicon.png";
             definedAliases = ["@nixhm"];
           };
           github = {
             name = "Github";
             urls = [{
               template = "https://github.com/search";
               params = [
                 {name = "type"; value = "repositories"; }
                 {name = "q"; value = "{searchTerms}"; }
               ];
             }];
             iconMapObj."16" = "https://github.com/favicon.ico";
             definedAliases = ["@gh"];
          };
          reddit = {
            name = "Reddit";
            urls = [{
              template = "https://www.reddit.com/search";
              params = [
                {name = "q"; value= "{searchTerms}"; }
              ];
            }];
            iconMapObj."16" = "https://www.redditstatic.com/shreddit/assets/favicon/64x64.png";
            definedAliases = ["@reddit"];
          };
          bing.metaData.hidden = true;
          perplexity.metaData.hidden = true;
          ebay.metaData.hidden = true;
        };
        order = ["ddg" "google"  "github" "wikipedia" "nix-os" "nix-home-manager"];
      };
      containersForce = true;
      containers = {
        personal = {
          id = 1;
          name = "Personal";
          icon = "fingerprint";
          color = "purple";
        };
        isolated = {
          id = 2;
          name = "Isolated";
          icon = "fence";
          color = "toolbar";
        };
        work = {
          id = 3;
          name = "Work";
          icon = "briefcase";
          color = "blue";
        };
        shopping = {
          id = 4;
          name = "Shopping";
          icon = "cart";
          color = "pink";
        };
      };
      spacesForce = true;
      spaces = let
        containers = config.programs.zen-browser.profiles.default.containers;
      in {
       "Personal" = {
          id = "2d52b37e-5c0e-4f15-84e7-b78a8c1b32dd";
          position = 1000;
          container =  containers.personal.id;
          icon = "🫆";
        };
       "Projects" = {
          id = "116c6ccd-adc6-403e-a22b-0986282cdf8b";
          position = 1500;
          container = containers.personal.id;
          icon = "🛠️";
        };
       "Shopping" = {
         id = "e3b73e30-237a-498b-bf01-cbbb8f8c4259";
         position = 2000;
         container = containers.shopping.id;
         icon = "🛒";
       };
       "Work" = {
         id = "7f770b37-70f8-475c-8f9d-fd85f183ae90";
         position = 3000;
         container = containers.work.id;
         icon = "💼";
       };
      };
    };
  }; 

}
