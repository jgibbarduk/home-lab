job "http-echo" {
  datacenters = ["dc1"]

  group "echo" {
    count = 5
    task "server" {
      driver = "docker"

      config {
        image = "hashicorp/http-echo:latest"
        args  = [
          "-listen", ":${NOMAD_PORT_http}",
          "-text", "Hello and welcome to ${NOMAD_IP_http} running on port ${NOMAD_PORT_http}",
        ]
        volumes = [
        "/mnt/shared-nfs/test:/opt/test"
      ]
      }

      resources {
        network {
          mbits = 10
          port "http" {}
        }
      }



      service {
        name = "http-echo"
        port = "http"

        tags = [
          "traefik.enable=true",
          "traefik.http.routers.http-echo.entrypoints=https",
          "traefik.http.routers.http-echo.rule=Host(`echo.dingous.net`)",
          "traefik.http.routers.http-echo.tls.certResolver=awsresolver"
        
        ]

        check {
          type     = "http"
          path     = "/health"
          interval = "2s"
          timeout  = "2s"
        }
      }
    }
  }
}