{
  config,
  pkgs,
  ...
}: {
  programs.thunderbird = {
    enable = true;
    profiles.harry = {
      isDefault = true;
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
          google.metaData.hidden = true;
        };
        order = ["ddg" "github" "wikipedia" "nix-os" "nix-home-manager"];
      };
    };
  };
}
