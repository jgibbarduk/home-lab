job "workflow" {
	region = "global"
	datacenters = ["dc1"]
	type = "service"

	group "n8n" {
		count = 1

		network {
			port "https" {
				to = 5678
				host_network = "tailscale"
			}
		}

		task "n8n" {
			driver = "docker"

			resources {
				cpu    = 1000
				memory = 2000
			}

			env {
				DB_TYPE = "postgresdb"
				DB_POSTGRESDB_DATABASE = "n8n"
				DB_POSTGRESDB_HOST = "100.91.185.3"
				DB_POSTGRESDB_PORT = 5433
				DB_POSTGRESDB_USER = "postgres"
				DB_POSTGRESDB_PASSWORD = "qwNJcjZZg7ru5sm9&wX*"
				// DB_POSTGRESDB_SCHEMA=<POSTGRES_SCHEMA> \

				GENERIC_TIMEZONE = "Europe/London"
				TZ = "Europe/London"
				N8N_EDITOR_BASE_URL = "https://n8n.dingous.net"
				WEBHOOK_URL = "https://n8n.dingous.net"
			}

			config {
				image = "n8nio/n8n"
				force_pull = true
				ports = ["https"]

				volumes = [
					"/opt/n8n:/home/node/.n8n"
				]
			}

			service {
				name = "n8n"
				port = "https"

				tags = [
					"traefik.enable=true",
                    "traefik.http.routers.n8n.entrypoints=https",
					"traefik.http.routers.n8n.rule=Host(`n8n.dingous.net`)",
					"traefik.http.routers.n8n.tls.certResolver=awsresolver",
					"traefik.http.routers.n8n.middlewares=authelia@file",
					// "traefik.http.routers.n8n.middlewares=n8n-cors@file",
				]
			}
		}
	}
}