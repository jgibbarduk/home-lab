job "homer" {
	region = "global"
	datacenters = ["dc1"]
	type = "service"

	group "homer" {
		count = 1

		network {
			port "homer" {
				host_network = "tailscale"
			}
		}

		task "homer" {
			driver = "docker"

			env {
				PORT = "${NOMAD_PORT_homer}"
			}

			config {
				image = "b4bz/homer:latest"
				ports = ["homer"]

				volumes = [
					"/mnt/shared-nfs/homer:/www/assets"
				]
			}

			service {
				name = "homer"
				port = "homer"

				tags = [
					"traefik.enable=true",
                    "traefik.http.routers.homer.entrypoints=https",
					"traefik.http.routers.homer.rule=Host(`homer.dingous.net`)",
					"traefik.http.routers.homer.tls.certResolver=awsresolver",
                    "traefik.http.routers.homer.middlewares=authelia@file",
				]
			}
		}
	}
}