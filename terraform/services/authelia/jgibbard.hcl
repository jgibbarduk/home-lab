job "authelia-jgibbard" {
  region      = "global"
  datacenters = ["dc1"]
  type        = "service"

  group "authelia" {
    count = 1

    network {
      port "authelia" {
        to = 9091
        static = 9091
        host_network = "tailscale"
      }
    }

    task "authelia" {
      driver = "docker"

      env {
        TZ                                   = "Europe/London"
        AUTHELIA_JWT_SECRET_FILE             = "/config/secrets/JWT_SECRET"
        AUTHELIA_SESSION_SECRET_FILE         = "/config/secrets/SESSION_SECRET"
        AUTHELIA_STORAGE_ENCRYPTION_KEY_FILE = "/config/secrets/STORAGE_ENCRYPTION_KEY"
        AUTHELIA_NOTIFIER_SMTP_PASSWORD_FILE = "/config/secrets/SMTP_PASSWORD"

        // AUTHELIA_IDENTITY_PROVIDERS_OIDC_ISSUER_PRIVATE_KEY_FILE = "/config/secrets/ISSUER_PRIVATE_KEY"
        // AUTHELIA_IDENTITY_PROVIDERS_OIDC_HMAC_SECRET_FILE        = "/config/secrets/HMAC_SECRET"
      }

      config {
        image = "authelia/authelia:latest"
        ports = ["authelia"]

        volumes = [
					"/mnt/shared-nfs/authelia-jgibbard/config:/config",
          "/mnt/shared-nfs/authelia-jgibbard/secrets:/config/secrets"
				]
      }

      service {
        name = "authelia-jgibbard"
        port = "authelia"
        address_mode = "auto"


        tags = [
          "traefik.enable=true",
          "traefik.http.routers.authelia-jgibbard.entrypoints=https",
          "traefik.http.routers.authelia-jgibbard.rule=Host(`auth.jgibbard.me.uk`)",
          "traefik.http.routers.authelia-jgibbard.tls.certResolver=awsresolver",
        ]
      }
    }
  }
}