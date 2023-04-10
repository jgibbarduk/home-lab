job "web-stats" {
	region = "global"
	datacenters = ["dc1"]
	type = "service"

	group "jgibbard" {
		count = 1

		network {
			port "ackee" {
				to = 3000
				host_network = "tailscale"
			}
			port "mongo" {
				to = 27017
				host_network = "tailscale"
			}
		}

		task "ackee" {
			driver = "docker"

			env {
				ACKEE_MONGODB="mongodb://${NOMAD_ADDR_mongo}/ackee"
				ACKEE_USERNAME="james"
				ACKEE_PASSWORD="machimpex"
			}

			config {
				image = "electerious/ackee:latest"
				ports = ["ackee"]
			}

			service {
				name = "ackee"
				port = "ackee"

				tags = [
					"traefik.enable=true",
                    "traefik.http.routers.ackee.entrypoints=https",
					"traefik.http.routers.ackee.rule=Host(`stats.jgibbard.me.uk`)",
					"traefik.http.routers.ackee.tls.certResolver=awsresolver",
					"traefik.http.routers.ackee.middlewares=authelia-jgibbard@file",
					"traefik.http.routers.ackee.middlewares=website-cors@file",
				]
			}
		}

		task "mongo" {
			driver = "docker"

			env {
			}

			config {
				image = "mongo:latest"
				ports = ["mongo"]
				
				
				volumes = [
					"/mnt/shared-nfs/mongo:/data/db"
				]
			}

			service {
				name = "mongo"
				port = "mongo"
			}
		}
	}
}