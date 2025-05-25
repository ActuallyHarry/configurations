{config, pkgs, ...}:
{
  environment.systemPackages = with pkgs;  [ 
    
    cloudflared
  ];

  services.cloudflared = {
    enable = true;
    tunnels = {
     "6d99fdf2-0650-47b2-895a-f9297a57439d" = {
       credentialsFile = "/var/lib/cloudflare.json";
       default = "http_status:404";
     };
    };
  };
}
