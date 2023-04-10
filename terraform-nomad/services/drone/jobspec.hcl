job "drone" {
	region = "global"
	datacenters = ["dc1"]
	type = "service"

	group "drone-server" {
		count = 1

		network {
			port "drone_https" {
				to = 443
				host_network = "tailscale"
			}
			port "drone_http" {
				to = 80
				host_network = "tailscale"
			}
		}

		task "server" {
			driver = "docker"

			env {
				DRONE_SERVER_HOST = "drone.dingous.net"
				DRONE_SERVER_PROTO = "https"
				DRONE_GITEA_SERVER = "https://git.dingous.net"
				DRONE_GIT_ALWAYS_AUTH = true

				DRONE_USER_CREATE = "username:james,admin:true"
				DRONE_RUNNER_PRIVILEGED_IMAGES = "earthly/earthly"

				// DRONE_LOGS_DEBUG=true
				// DRONE_LOGS_TRACE=true 
			}

			config {
				image = "drone/drone:2"
				ports = ["drone_https", "drone_http"]
				volumes = [
					"/mnt/shared-nfs/drone/server:/data"
				]
			}

			template {
				data = <<EOF
				DRONE_RPC_SECRET = "{{with secret "kv/drone/server"}}{{.Data.data.rpc_secret}}{{end}}"
      			DRONE_GITEA_CLIENT_ID = "{{with secret "kv/drone/gitea"}}{{.Data.data.DRONE_GITEA_CLIENT_ID}}{{end}}"
				DRONE_GITEA_CLIENT_SECRET = "{{with secret "kv/drone/gitea"}}{{.Data.data.DRONE_GITEA_CLIENT_SECRET}}{{end}}"
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
				port = "drone_http"

				tags = [
					"traefik.enable=true",
                    "traefik.http.routers.drone.entrypoints=https",
					"traefik.http.routers.drone.rule=Host(`drone.dingous.net`)",
					"traefik.http.routers.drone.tls.certResolver=awsresolver",
					// "traefik.http.routers.drone.middlewares=authelia@file",
					// "traefik.http.middlewares.sslheader.headers.customrequestheaders.X-Forwarded-Proto=https"
				]
			}
		}
	}

	group "drone-runner" {
		count = 1

		network {
			port "drone" {
				to = 3000
				host_network = "tailscale"
			}
		}

		task "runner" {
			driver = "docker"

			resources {
				cpu    = 500
				memory = 1000
			}

			env {
				DRONE_RPC_HOST = "drone.dingous.net"
				DRONE_RPC_PROTO = "https"
				DRONE_RUNNER_CAPACITY = 2
				DRONE_RUNNER_NAME = "runner-1"

				// DRONE_LOGS_DEBUG=true
				// DRONE_LOGS_TRACE=true 

			}

			config {
				image = "drone/drone-runner-docker:1"
				ports = ["drone"]
				volumes = [
					"/var/run/docker.sock:/var/run/docker.sock"
				]
				privileged = true
			}

			template {
				data = <<EOF
				DRONE_RPC_SECRET = "{{with secret "kv/drone/server"}}{{.Data.data.rpc_secret}}{{end}}"
      			DRONE_GITEA_CLIENT_ID = "{{with secret "kv/drone/gitea"}}{{.Data.data.DRONE_GITEA_CLIENT_ID}}{{end}}"
				DRONE_GITEA_CLIENT_SECRET = "{{with secret "kv/drone/gitea"}}{{.Data.data.DRONE_GITEA_CLIENT_SECRET}}{{end}}"
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
				port = "drone"

				tags = [
					// "traefik.enable=true",
                    // "traefik.http.routers.drone-runner.entrypoints=https",
					// "traefik.http.routers.drone.rule=Host(`drone.dingous.net`)",
					// "traefik.http.routers.drone.tls.certResolver=awsresolver",
					// "traefik.http.routers.drone.middlewares=authelia@file",
					// "traefik.http.middlewares.sslheader.headers.customrequestheaders.X-Forwarded-Proto=https"
				]
			}
		}
	}
}