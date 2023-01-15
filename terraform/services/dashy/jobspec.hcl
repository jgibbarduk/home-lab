job "dashy" {
	region = "global"
	datacenters = ["dc1"]
	type = "service"

	group "dashy" {
		count = 1

		network {
			port "dashy" {
				host_network = "tailscale"
			}
		}

		task "homer" {
			driver = "docker"

			env {
				PORT = "${NOMAD_PORT_dashy}"
			}

			config {
				image = "lissy93/dashy:latest"
				ports = ["dashy"]

				volumes = [
					"/mnt/shared-nfs/dashy:/app/public"
				]
			}

			// template {
			// 	data = "{{ key `homer/config.yml` }}"
			// 	destination = "local/config.yml"
			// }

			service {
				name = "dashy"
				port = "dashy"

				tags = [
					"traefik.enable=true",
                    "traefik.http.routers.dashy.entrypoints=https",
					"traefik.http.routers.dashy.rule=Host(`dashy.dingous.net`)",
					"traefik.http.routers.dashy.tls.certResolver=awsresolver",
                    "traefik.http.routers.dashy.middlewares=authelia@file",
				]
			}
		}
	}
}