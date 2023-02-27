job "route53dynip" {
	region = "global"
	datacenters = ["dc1"]
	type = "service"

	constraint {
		attribute  = "${attr.cpu.arch}"
		value     = "amd64"
	}

	group "route53dynip" {
		count = 1

		task "jgibbard-me-uk" {
			driver = "docker"

			config {
				image = "ghcr.io/jgibbarduk/route53dynip:latest"
				args = [
					"*.jgibbard.me.uk"
				]
			}

			template {
				data = <<EOF
				AWS_ACCESS_KEY_ID = "{{with secret "kv/secret/aws/route53"}}{{.Data.data.aws_access_key_id}}{{end}}"
				AWS_SECRET_ACCESS_KEY = "{{with secret "kv/secret/aws/route53"}}{{.Data.data.aws_secret_access_key}}{{end}}"
				EOF

				destination = "secrets/vault.env"
				env         = true
			}

			vault {
				policies      = ["route53dynip"]
				change_mode   = "signal"
				change_signal = "SIGHUP"
			}
		}

		task "dingous-net" {
			driver = "docker"

			config {
				image = "ghcr.io/jgibbarduk/route53dynip:latest"
				args = [
					"*.dingous.net"
				]
			}

			template {
				data = <<EOF
				AWS_ACCESS_KEY_ID = "{{with secret "kv/secret/aws/route53"}}{{.Data.data.aws_access_key_id}}{{end}}"
				AWS_SECRET_ACCESS_KEY = "{{with secret "kv/secret/aws/route53"}}{{.Data.data.aws_secret_access_key}}{{end}}"
				EOF

				destination = "secrets/vault.env"
				env         = true
			}

			vault {
				policies      = ["route53dynip"]
				change_mode   = "signal"
				change_signal = "SIGHUP"
			}
		}
	}
}