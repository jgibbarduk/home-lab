job "gitea" {
	region = "global"
	datacenters = ["dc1"]
	type = "service"

	group "gitea" {
		count = 1

		network {
			port "gitea" {
				to = 3000
				host_network = "tailscale"
			}
		}

		task "gitea" {
			driver = "docker"

			env {
				USER_UID = 1000
      			USER_GID = 1000
				TZ = "Europe/London"
			}

			config {
				image = "gitea/gitea:latest"
				ports = ["gitea"]

				volumes = [
					"/mnt/shared-nfs/gitea:/data",
					"/etc/timezone:/etc/timezone:ro",
					"/etc/localtime:/etc/localtime:ro"
				]
			}

			service {
				name = "gitea"
				port = "gitea"

				tags = [
					"traefik.enable=true",
                    "traefik.http.routers.gitea.entrypoints=https",
					"traefik.http.routers.gitea.rule=Host(`git.dingous.net`)",
					"traefik.http.routers.gitea.tls.certResolver=awsresolver",
					"traefik.http.routers.gitea.middlewares=authelia@file",
				]
			}
		}
	}
}