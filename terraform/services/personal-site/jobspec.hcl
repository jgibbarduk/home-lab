job "personal-site" {
	region = "global"
	datacenters = ["dc1"]
	type = "service"

	group "personal-site" {
		count = 1

		network {
			port "website" {
				to = 8080
				host_network = "tailscale"
			}
		}

		task "personal-site" {
			driver = "docker"

			env {
				PORT = "${NOMAD_PORT_website}"
			}

			config {
				image = "trafex/php-nginx:latest"
				ports = ["website"]

				volumes = [
					"/mnt/shared-nfs/personal-site:/var/www/html"
				]
			}


			service {
				name = "website"
				port = "website"

				tags = [
					"traefik.enable=true",
                    "traefik.http.routers.website.entrypoints=https",
					"traefik.http.routers.website.rule=Host(`www.jgibbard.me.uk`)",
					"traefik.http.routers.website.tls.certResolver=awsresolver",
					// "traefik.http.routers.website.middlewares=authelia@file",
				]
			}
		}
	}
}