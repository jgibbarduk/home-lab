job "metrics" {
    datacenters = ["dc1"]

    group "prometheus" {
        network {
            port "prometheus" {
                to = 9090
                host_network = "tailscale"
            }
        }

        service {
            name = "prometheus"
            port = "prometheus"
        }

        task "web" {
            driver = "docker"
            config {
                image = "prom/prometheus:latest"
                ports = ["prometheus"]
            }
        }
    }


    group "grafana" {
        network {
            port "grafana" {
                to     = 3000
                host_network = "tailscale"
            }
        }

        service {
            name = "grafana"
            port = "grafana"

            // connect {
            //         sidecar_service {
            //         proxy {
            //             upstreams {
            //                 destination_name = "prometheus"
            //                 local_bind_port  = 9090
            //             }
            //         }
            //     }
            // }


            tags = [
                "traefik.enable=true",
                // "traefik.connect=true",
                // "traefik.consulcatalog.connect=true",
                "traefik.http.routers.grafana.entrypoints=https",
                "traefik.http.routers.grafana.rule=Host(`grafana.dingous.net`)",
                "traefik.http.routers.grafana.tls.certResolver=awsresolver",
                "traefik.http.routers.grafana.middlewares=authelia@file",

            ]
            // check {
            //     type     = "http"
            //     path     = "/api/health"
            //     interval = "2s"
            //     timeout  = "2s"
            // }
        }

        task "dashboard" {
            driver = "docker"
            config {
                image = "grafana/grafana:latest"
                ports = ["grafana"]
                volumes = [
                    "/mnt/shared-nfs/grafana/data:/var/lib/grafana",
                    "/mnt/shared-nfs/grafana/config:/etc/grafana"
                ]

                // mounts = [
                //     {
                //         type = "bind"
                //         target = "/var/lib/grafana"
                //         source = "/mnt/shared-nfs/grafana/data"
                //         readonly = false
                //         bind_options {
                //             propagation = "rshared"
                //         }
                //     }
                // ]

            }
        }
    }
}