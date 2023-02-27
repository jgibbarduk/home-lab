# The following configuration uses a provider which provisions resources
resource "nomad_job" "test" {
  jobspec = file("${path.module}/services/http-echo/jobspec.hcl")
}

resource "nomad_job" "metrics" {
  jobspec = file("${path.module}/services/metrics/jobspec.hcl")
}

resource "nomad_job" "homer" {
  jobspec = file("${path.module}/services/homer/jobspec.hcl")
}

resource "nomad_job" "authelia" {
  jobspec = file("${path.module}/services/authelia/dingous.hcl")
}

resource "nomad_job" "authelia-jgibbard" {
  jobspec = file("${path.module}/services/authelia/jgibbard.hcl")
}

resource "nomad_job" "route53dynip" {
  jobspec = file("${path.module}/services/route53dynip/jobspec.hcl")
}

resource "nomad_job" "website" {
  jobspec = file("${path.module}/services/personal-site/jobspec.hcl")
}
resource "nomad_job" "blog" {
  jobspec = file("${path.module}/services/personal-blog/jobspec.hcl")
}

resource "nomad_job" "code-server" {
  jobspec = file("${path.module}/services/code-server/jobspec.hcl")
}

resource "nomad_job" "gitea" {
  jobspec = file("${path.module}/services/gitea/jobspec.hcl")
}
