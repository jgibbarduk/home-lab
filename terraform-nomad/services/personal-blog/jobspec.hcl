job "personal-blog" {
	region = "global"
	datacenters = ["dc1"]
	type = "service"

	group "personal-blog" {
		count = 1

		network {
			port "blog" {
				to = 2368
				host_network = "tailscale"
			}
		}

		task "personal-blog" {
			driver = "docker"

			env {
				PORT = "${NOMAD_PORT_blog}"
				url = "https://blog.jgibbard.me.uk"
			}

			config {
				image = "ghost:4-alpine"
				ports = ["blog"]

				volumes = [
					"/mnt/shared-nfs/personal-blog:/var/lib/ghost/content"
				]
			}


			service {
				name = "blog"
				port = "blog"

				tags = [
					"traefik.enable=true",
                    "traefik.http.routers.blog.entrypoints=https",
					"traefik.http.routers.blog.rule=Host(`blog.jgibbard.me.uk`)",
					"traefik.http.routers.blog.tls.certResolver=awsresolver",
					// "traefik.http.routers.blog.middlewares=authelia@file",
				]
			}
		}
	}
}