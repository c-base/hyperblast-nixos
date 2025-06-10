# XXX: This requires a SYSTEM-WIDE Pipewire installation
{
  selfpkgs,
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (selfpkgs) relaxx;
in
{
  services.mpd = {
    enable = true;
    network.listenAddress = "0.0.0.0";
    extraConfig = ''
      audio_output {
              type            "pipewire"
              name            "PipeWire Sound Server"
      }
    '';
  };
  users.users.${config.services.mpd.user}.extraGroups = [ "pipewire" ];

  networking.firewall.allowedTCPPorts = [
    80
    6600
  ];
  services = {
    nginx = {
      enable = true;
      virtualHosts."hyperblast" = {
        root = relaxx;
        locations = {
          "~ \\.(?:css|js|mjs|svg|gif|png|jpg|jpeg|ico|wasm|tflite|map|html|ttf|bcmap|mp4|webm|ogg|flac)$".extraConfig =
            ''
              expires 6M;
              access_log off;
              location ~ \.mjs$ {
                      default_type text/javascript;
              }
              location ~ \.wasm$ {
                      default_type application/wasm;
              }
            '';
          "/" = {
            extraConfig = ''
              fastcgi_pass unix:${config.services.phpfpm.pools.relaxx.socket};
              fastcgi_index index.php;
              include ${pkgs.nginx}/conf/fastcgi.conf;
            '';
          };
        };
      };
    };
    phpfpm = {
      pools.relaxx = {
        user = config.services.nginx.user;
        settings = {
          "listen.owner" = config.services.nginx.user;
          "pm" = "dynamic";
          "pm.max_children" = 32;
          "pm.max_requests" = 500;
          "pm.start_servers" = 2;
          "pm.min_spare_servers" = 2;
          "pm.max_spare_servers" = 5;
          "php_admin_value[error_log]" = "stderr";
          "php_admin_flag[log_errors]" = true;
          "catch_workers_output" = true;
        };
        #phpEnv."PATH" = lib.makeBinPath []; # extra packages for relaxx
        phpEnv."CONFIG_PATH" = "/var/lib/relaxx/config.xml";
      };
    };
  };
  systemd.tmpfiles.rules = [
    "d /var/lib/relaxx 0750 ${config.services.nginx.user} ${config.services.nginx.group} - -"
  ];
}
