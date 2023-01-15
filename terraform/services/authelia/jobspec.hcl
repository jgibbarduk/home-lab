job "authelia" {
  region      = "global"
  datacenters = ["dc1"]
  type        = "service"

  group "authelia" {
    count = 1

    // volume "authelia-config" {
    //   type      = "host"
    //   source    = "authelia-config"
    //   read_only = false
    // }

    network {
      port "authelia" {
        to = 9091
        static = 9091
        host_network = "tailscale"
      }
    }

    task "authelia" {
      driver = "docker"

    //   volume_mount {
    //     volume      = "authelia-config"
    //     destination = "/config"
    //     read_only   = false
    //   }

    

      env {
        // TZ                                   = "Europe/London"
        AUTHELIA_JWT_SECRET_FILE             = "/config/secrets/JWT_SECRET"
        AUTHELIA_SESSION_SECRET_FILE         = "/config/secrets/SESSION_SECRET"
        AUTHELIA_STORAGE_ENCRYPTION_KEY_FILE = "/config/secrets/STORAGE_ENCRYPTION_KEY"
        AUTHELIA_NOTIFIER_SMTP_PASSWORD_FILE = "/config/secrets/SMTP_PASSWORD"
      }

      config {
        image = "authelia/authelia:latest"
        ports = ["authelia"]

        volumes = [
					"/mnt/shared-nfs/authelia/config:/config",
                    "/mnt/shared-nfs/authelia/secrets:/config/secrets"
				]
      }

      service {
        name = "authelia"
        port = "authelia"
        address_mode = "auto"


        tags = [
          "traefik.enable=true",
          "traefik.http.routers.authelia.entrypoints=https",
          "traefik.http.routers.authelia.rule=Host(`auth.dingous.net`)",
          "traefik.http.routers.authelia.tls.certResolver=awsresolver",
        ]
      }
    }
  }
}