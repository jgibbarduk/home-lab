job "devbytes" {
	region = "global"
	datacenters = ["dc1"]
	type = "service"

	group "ghost" {
		count = 1

		network {
			port "https" {
				to = 2368
				host_network = "tailscale"
			}
		}

		//  volume "user" {
		// 	type      = "host"
		// 	source    = "grav-user-data"
		// 	read_only = false
		// }

		task "ghost" {
			driver = "docker"

			resources {
				cpu    = 1000
				memory = 2000
			}

			env {
				database__client = "mysql"
				database__connection__host = "100.91.185.3"
				database__connection__user = "ghost"
				database__connection__port = 3307
				database__connection__password = "n2CSyJtb9CD_kaf2k3PQg"
				database__connection__database = "devbytes_ghost"
				# this url value is just an example, and is likely wrong for your environment!
				url = "https://www.devbytes.co.uk"
			}

			config {
				image = "ghost:5-alpine"
				force_pull = true
				ports = ["https"]
			}

			service {
				name = "devbytes"
				port = "https"

				tags = [
					"traefik.enable=true",
                    "traefik.http.routers.devbytes.entrypoints=https",
					"traefik.http.routers.devbytes.rule=Host(`www.devbytes.co.uk`) || Host(`devbytes.co.uk`)",
					"traefik.http.routers.devbytes.tls.certResolver=awsresolver",
				]
			}
		}
	}
}