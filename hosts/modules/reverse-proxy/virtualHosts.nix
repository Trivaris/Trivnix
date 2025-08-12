{ cfg, activeServices }:
let
  isSunshine = service:
    (service.domain or "") == (cfg.sunshine.domain or "");
in
builtins.listToAttrs (map (service: {
  name = service.domain;
  value = {
    forceSSL = true;
    useACMEHost = service.domain;

    listen = [{
      addr = "0.0.0.0";
      port = if service.externalPort != null
             then service.externalPort
             else cfg.reverseProxy.port;
      ssl = true;
    }];

    locations =
      if isSunshine service then {
        "/" = {
          extraConfig = ''
            access_by_lua_block {
              local last = ngx.shared.wol:get("last") or 0
              local now  = ngx.time()
              if now - last > 30 then
                local mac_str = [[${cfg.sunshine.hostMac}]]
                local hex = mac_str:gsub("[:%-%.]", ""):lower()
                if #hex == 12 then
                  local mac = {}
                  for i = 1, 12, 2 do
                    mac[#mac+1] = string.char(tonumber(hex:sub(i,i+1), 16))
                  end
                  mac = table.concat(mac)
                  local magic = string.rep(string.char(0xFF), 6) .. mac:rep(16)
                  local udp = ngx.socket.udp()
                  udp:settimeout(100)
                  assert(udp:setpeername("255.255.255.255", 9))
                  assert(udp:send(magic))
                  udp:close()
                  ngx.shared.wol:set("last", now)
                end
              end
            }
            content_by_lua_block {
              ngx.status = 200
              ngx.header.content_type = "text/html"
              ngx.say("<!doctype html><meta charset='utf-8'><title>Sunshine</title><h1>Sunshine is starting…</h1>")
            }
          '';
        };
      } else {
        "/" = {
          proxyPass = "http://${service.ipAddress}:${toString service.port}";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_set_header Accept-Encoding gzip;
          '';
        };
      };
  };
}) activeServices)
