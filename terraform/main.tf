# The following configuration uses a provider which provisions [fake] resources
resource "nomad_job" "test" {
  jobspec = file("${path.module}/services/http-echo/http-echo.nomad")
}