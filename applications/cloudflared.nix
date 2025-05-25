{config, pkgs, ...}:
{
  environment.systemPackages = with pkgs;  [ 
    
    cloudflared
  ];

  sops.secrets."cloudflared.json" = {
    sopsFile = ../secrets/cloudflared.json;
    format = "json";
    key = "";
  };

  services.cloudflared = {
    enable = true;
    tunnels = {
     "6d99fdf2-0650-47b2-895a-f9297a57439d" = {
       credentialsFile = "/run/secrets/cloudflared.json";
       default = "http_status:404";
     };
    };
  };
}
