job "wikijs" {
	region = "global"
	datacenters = ["dc1"]
	type = "service"

	group "wikijs" {
		count = 1

		network {
			port "wikijs" {
				to = 3000
				host_network = "tailscale"
			}
		}

		task "wikijs" {
			driver = "docker"

			env {
				DB_TYPE = "postgres"
				DB_HOST = "100.91.185.3"
				DB_PORT = 5433
				DB_USER = "wikijs"
				DB_PASS = "n23RJp8g8GVEJ4mixztH"
				DB_NAME = "wiki"
			}

			config {
				image = "ghcr.io/requarks/wiki:2"
				ports = ["wikijs"]
			}

			service {
				name = "wikijs"
				port = "wikijs"

				tags = [
					"traefik.enable=true",
                    "traefik.http.routers.wikijs.entrypoints=https",
					"traefik.http.routers.wikijs.rule=Host(`wiki.dingous.net`)",
					"traefik.http.routers.wikijs.tls.certResolver=awsresolver",
                    "traefik.http.routers.wikijs.middlewares=authelia@file",
				]
			}
		}
	}
}