job "metrics" {
    datacenters = ["dc1"]

    group "prometheus" {
        network {
            mode = "bridge"
        }

        service {
            name = "prometheus"
            port = "9090"

            connect {
                sidecar_service {}
            }

        }

        task "web" {
            driver = "docker"
            config {
                image = "prom/prometheus:latest"
            }
        }
    }


    group "grafana" {
        network {
            mode ="bridge"
            port "http" {
                static = 3000
                to     = 3000
                host_network = "tailscale"
            }
        }

        service {
            name = "grafana"
            port = "3000"

            connect {
                    sidecar_service {
                    proxy {
                        upstreams {
                            destination_name = "prometheus"
                            local_bind_port  = 9090
                        }
                    }
                }
            }


            tags = [
                "traefik.enable=true",
                "traefik.connect=true",
                "traefik.consulcatalog.connect=true",
                "traefik.http.routers.grafana.entrypoints=https",
                "traefik.http.routers.grafana.rule=Host(`grafana.dingous.net`)",
                "traefik.http.routers.grafana.tls.certResolver=awsresolver",
                "traefik.http.routers.grafana.middlewares=internal-whitelist@file",

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
                mounts = [
                    {
                        type = "bind"
                        target = "/var/lib/grafana"
                        source = "/mnt/shared-nfs/grafana/data"
                        readonly = false
                        bind_options {
                        propagation = "rshared"
                        }
                    }
                ]

            }
        }
    }
}