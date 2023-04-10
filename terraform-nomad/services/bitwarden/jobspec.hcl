job "bitwarden" {
	region = "global"
	datacenters = ["dc1"]
	type = "service"

	group "bitwarden" {
		count = 1

		network {
			port "http" {
				to = 80
				host_network = "tailscale"
			}
			port "websocket" {
				to = 3012
				host_network = "tailscale"
			}
		}

		task "bitwarden" {
			driver = "docker"

			resources {
				cpu    = 500
				memory = 1000
			}

			env {
				WEBSOCKET_ENABLED = true 
				SIGNUPS_ALLOWED = false
			}

			config {
				image = "vaultwarden/server:latest"
				ports = ["http", "websocket"]
				volumes = [
					"/mnt/shared-nfs/bitwarden:/data"
				]
			}

			service {
				name = "bitwarden"
				port = "http"

				tags = [
					"traefik.enable=true",

					# Routers & Services
					"traefik.http.routers.bitwarden-ui-http.rule=Host(`bitwarden.dingous.net`)",
					"traefik.http.routers.bitwarden-ui-http.entrypoints=https",
					"traefik.http.routers.bitwarden-ui-http.tls.certResolver=awsresolver",

					"traefik.http.routers.bitwarden-websocket-https.rule=Host(`bitwarden.dingous.net`) && Path(`/notifications/hub/negotiate`)",
      				"traefik.http.routers.bitwarden-websocket-https.entrypoints=https",
				]
				# https://github.com/Brettdah/vaultwarden-traefiked/blob/main/docker-compose.yml
			}

			service {
				name = "bitwarden-websocket"
				port = "websocket"

				tags = [
					"traefik.enable=true",
                    
					# Redirect to get the certs
					"traefik.http.middlewares.sslheader.headers.customrequestheaders.X-Forwarded-Proto=https",

					# Routers & Services
					"traefik.http.routers.bitwarden-websocket.rule=Host(`bitwarden.dingous.net`) && Path(`/notifications/hub`)",
      				"traefik.http.routers.bitwarden-websocket.entrypoints=https",
				]
				# https://github.com/Brettdah/vaultwarden-traefiked/blob/main/docker-compose.yml
			}
			
		}
	}
}