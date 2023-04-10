job "devbytes" {
	region = "global"
	datacenters = ["dc1"]
	type = "service"

	group "grav" {
		count = 1

		network {
			port "https" {
				to = 80
				host_network = "tailscale"
			}
		}

		//  volume "user" {
		// 	type      = "host"
		// 	source    = "grav-user-data"
		// 	read_only = false
		// }

		task "grav" {
			driver = "docker"

			resources {
				cpu    = 1000
				memory = 2000
			}

			env {
				DUID = 1000
      			DGID = 1000
				// GRAV_MULTISITE = "subdirectory"
			}

			config {
				image = "git.dingous.net/james/grav:admin"
				force_pull = true
				ports = ["https"]

				volumes = [
					"/opt/grav:/var/www/grav"
				]
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

		task "backup" {
			driver = "docker"

			env {
				BACKUP_CRON_EXPRESSION = "0 2 * * *"
				BACKUP_FILENAME = "grav-backup-%Y-%m-%dT%H-%M-%S.tar.gz"
			}

			config {
				image = "offen/docker-volume-backup:latest"
				volumes = [
					"/opt/grav:/backup/grav:ro",
					"/mnt/shared-nfs/devbytes/grav:/archive"
				]
			}
		}
	}
}