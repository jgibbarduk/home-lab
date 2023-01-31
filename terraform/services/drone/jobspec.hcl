job "drone" {
	region = "global"
	datacenters = ["dc1"]
	type = "service"

	group "drone-server" {
		count = 1

		network {
			port "https" {
				to = 443
				host_network = "tailscale"
			}
			port "http" {
				to = 443
				host_network = "tailscale"
			}
		}

		task "server" {
			driver = "docker"

			env {
				DRONE_SERVER_HOST = "drone.dingous.net"
				DRONE_SERVER_PROTO = "https"
			}

			config {
				image = "drone/drone:2"
				volumes = [
					"/mnt/shared-nfs/drone-server:/data"
				]
			}

			template {
				data = <<EOF
				DRONE_RPC_SECRET = "{{with secret "kv/drone/server"}}{{.Data.data.rpc_secret}}{{end}}"
      			DRONE_GITHUB_CLIENT_ID = "{{with secret "kv/drone/github"}}{{.Data.data.client_id}}{{end}}"
				DRONE_GITHUB_CLIENT_SECRET = "{{with secret "kv/drone/github"}}{{.Data.data.client_secret}}{{end}}"
				EOF

				destination = "secrets/vault.env"
				env         = true
			}

			vault {
				policies      = ["route53dynip"]
				change_mode   = "signal"
				change_signal = "SIGHUP"
			}

			service {
				name = "drone"
				port = "https"

				tags = [
					"traefik.enable=true",
                    "traefik.http.routers.drone.entrypoints=https",
					"traefik.http.routers.drone.rule=Host(`drone.dingous.net`)",
					"traefik.http.routers.drone.tls.certResolver=awsresolver",
					// "traefik.http.routers.drone.middlewares=authelia@file",
				]
			}
		}
	}
}