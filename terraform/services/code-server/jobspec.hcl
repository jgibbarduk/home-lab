job "code-server" {
	region = "global"
	datacenters = ["dc1"]
	type = "service"

	group "code-server" {
		count = 1

		network {
			port "codeserver" {
				to = 8443
				host_network = "tailscale"
			}
		}

		task "lister-shared-nfs" {
			driver = "docker"

			env {
				PORT = "${NOMAD_PORT_codeserver}"
				DEFAULT_WORKSPACE = "/config/workspace"
				PUID = 1000
      			PGID = 1000
				TZ = "Europe/London"
			}

			config {
				image = "linuxserver/code-server:latest"
				ports = ["codeserver"]

				volumes = [
					"/mnt/shared-nfs:/config/workspace"
				]
			}

			service {
				name = "codeserver"
				port = "codeserver"

				tags = [
					"traefik.enable=true",
                    "traefik.http.routers.shared-code-server.entrypoints=https",
					"traefik.http.routers.shared-code-server.rule=Host(`shared.code.dingous.net`)",
					"traefik.http.routers.shared-code-server.tls.certResolver=awsresolver",
					"traefik.http.routers.shared-code-server.middlewares=authelia@file",
					"traefik.http.middlewares.sslheader.headers.customrequestheaders.X-Forwarded-Proto=https"
				]
			}
		}
	}
}