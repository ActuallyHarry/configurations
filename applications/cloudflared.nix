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
       credentialsFile = "${config.sops.secrets."cloudflared.json".path}";
       default = "http_status:404";
     };
    };
  };

  # Home DNS Update
  systemd.timers."home-dns-update" = {
    wantedBy = ["timers.target"];
    timerConfig = {
      OnBootSec = "5m";
      OnUnitActiveSec = "5m";
<<<<<<< HEAD
      Unit = "home-dns-update.service"
=======
      Unit = "home-dns-update.service";
>>>>>>> main
    };
  };

  sops.secrets."cloudflare-api-key" = {
<<<<<<< HEAD
    path = ../secrets/cloudflare.yaml;
    
  };

  sops.secrets."cloudlfare-zone-id" = {
    path = ../secrets/cloudflare.yaml;
=======
    sopsFile = ../secrets/cloudflare.yaml;
    
  };

  sops.secrets."cloudflare-zone-id" = {
    sopsFile = ../secrets/cloudflare.yaml;
>>>>>>> main
  };

  systemd.services."home-dns-update" = let
    home-dns-updater = pkgs.writeShellScript "home-dns-updater" ''
      #!/bin/bash
      set -euo pipefail # Exit on error, unset variables, and pipeline errors

      # --- Configuration Variables ---
      # Update these paths to match your sops-nix configuration
      SOPS_TOKEN_FILE="${config.sops.secrets.cloudflare-api-key.path}"
      SOPS_ZONE_ID_FILE="${config.sops.secrets.cloudflare-zone-id.path}"

      # The record name and other non-sensitive settings can remain here or be loaded from another source
<<<<<<< HEAD
      RECORD_NAME="home.example.com" # The A record name to update
=======
      RECORD_NAME="home.zitohouse.net" # The A record name to update
>>>>>>> main
      TTL=3600                       # DNS TTL (seconds)
      PROXY="false"                  # Set to "true" or "false"

      # --- Functions ---
      log_message() {
        logger -t "DDNS_Updater" "$1"
      }

      # --- 1. Load Secrets and Set Headers ---
      # Load the decrypted content from the sops-nix managed files
<<<<<<< HEAD
      AUTH_KEY=$(cat "${SOPS_TOKEN_FILE}")
      ZONE_IDENTIFIER=$(cat "${SOPS_ZONE_ID_FILE}")
=======
      AUTH_KEY=$(cat "''${SOPS_TOKEN_FILE}")
      ZONE_IDENTIFIER=$(cat "''${SOPS_ZONE_ID_FILE}")
>>>>>>> main
      AUTH_HEADER="Authorization: Bearer"

      # --- 2. Get Current Public IP ---
      ipv4_regex='([01]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])\.([01]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])\.([01]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])\.([01]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])'
      IP=$(curl -s -4 https://cloudflare.com/cdn-cgi/trace | grep -E '^ip=' | sed -E "s/^ip=($ipv4_regex)$/\1/" || curl -s https://api.ipify.org || curl -s https://ipv4.icanhazip.com || true)

      if [[ ! "$IP" =~ ^$ipv4_regex$ ]]; then
        log_message "Failed to find a valid IPv4 address. Exiting."
        exit 2
      fi

       # --- 3. Get Existing A Record Details ---
       RECORD_INFO=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$ZONE_IDENTIFIER/dns_records?type=A&name=$RECORD_NAME" \
<<<<<<< HEAD
       -H "${AUTH_HEADER} ${AUTH_KEY}" \
       -H "Content-Type: application/json")

       if echo "$RECORD_INFO" | grep -q "\"count\":0"; then
         log_message "Record ${RECORD_NAME} does not exist for Zone ID ${ZONE_IDENTIFIER}. Please create it first. Exiting."
=======
       -H "''${AUTH_HEADER} ''${AUTH_KEY}" \
       -H "Content-Type: application/json")

       if echo "$RECORD_INFO" | grep -q "\"count\":0"; then
         log_message "Record ''${RECORD_NAME} does not exist for Zone ID ''${ZONE_IDENTIFIER}. Please create it first. Exiting."
>>>>>>> main
         exit 1
       fi

       # Extract old IP and record ID
       OLD_IP=$(echo "$RECORD_INFO" | sed -E 's/.*"content":"(([0-9]{1,3}\.){3}[0-9]{1,3})".*/\1/')
       RECORD_IDENTIFIER=$(echo "$RECORD_INFO" | sed -E 's/.*"id":"([0-9a-f]+)".*/\1/')

       # --- 4. Compare IPs and Update if Necessary ---
       if [[ "$IP" == "$OLD_IP" ]]; then
<<<<<<< HEAD
         log_message "IP ($IP) for ${RECORD_NAME} has not changed. Exiting successfully."
         exit 0
       fi

       log_message "IP change detected: Old IP $OLD_IP, New IP $IP. Attempting update for ${RECORD_NAME}..."

       # --- 5. Perform the Update ---
       UPDATE_RESULT=$(curl -s -X PATCH "https://api.cloudflare.com/client/v4/zones/$ZONE_IDENTIFIER/dns_records/$RECORD_IDENTIFIER" \
       -H "${AUTH_HEADER} ${AUTH_KEY}" \
       -H "Content-Type: application/json" \
       --data "{\"type\":\"A\",\"name\":\"$RECORD_NAME\",\"content\":\"$IP\",\"ttl\":$TTL,\"proxied\":${PROXY}}")

       # --- 6. Report Status ---
       if echo "$UPDATE_RESULT" | grep -q "\"success\":true"; then
         log_message "Successfully updated ${RECORD_NAME} to new IP: $IP."
         exit 0
       else
         log_message "Failed to update ${RECORD_NAME}. Cloudflare API response: $UPDATE_RESULT"
=======
         log_message "IP ($IP) for ''${RECORD_NAME} has not changed. Exiting successfully."
         exit 0
       fi

       log_message "IP change detected: Old IP $OLD_IP, New IP $IP. Attempting update for ''${RECORD_NAME}..."

       # --- 5. Perform the Update ---
       UPDATE_RESULT=$(curl -s -X PATCH "https://api.cloudflare.com/client/v4/zones/$ZONE_IDENTIFIER/dns_records/$RECORD_IDENTIFIER" \
       -H "''${AUTH_HEADER} ''${AUTH_KEY}" \
       -H "Content-Type: application/json" \
       --data "{\"type\":\"A\",\"name\":\"$RECORD_NAME\",\"content\":\"$IP\",\"ttl\":$TTL,\"proxied\":''${PROXY}}")

       # --- 6. Report Status ---
       if echo "$UPDATE_RESULT" | grep -q "\"success\":true"; then
         log_message "Successfully updated ''${RECORD_NAME} to new IP: $IP."
         exit 0
       else
         log_message "Failed to update ''${RECORD_NAME}. Cloudflare API response: $UPDATE_RESULT"
>>>>>>> main
         exit 1
       fi
    '';
  in
  {
    description = "Cloudflare DDNS Update Service";
    path = with pkgs; [coreutils curl logger];
<<<<<<< HEAD
    execStart = "${home-dns-updater}";
=======
    script = "${home-dns-updater}";
>>>>>>> main
    serviceConfig = {
      Type = "oneshot";
      After = ["network.target"];
    };
  };
}
