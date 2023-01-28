# The following configuration uses a provider which provisions [fake] resources
resource "nomad_job" "test" {
  jobspec = file("${path.module}/services/http-echo/jobspec.hcl")
}

resource "nomad_job" "metrics" {
  jobspec = file("${path.module}/services/metrics/jobspec.hcl")
}

resource "nomad_job" "homer" {
  jobspec = file("${path.module}/services/homer/jobspec.hcl")
}

resource "nomad_job" "dashy" {
  jobspec = file("${path.module}/services/dashy/jobspec.hcl")
}

resource "nomad_job" "authelia" {
  jobspec = file("${path.module}/services/authelia/jobspec.hcl")
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


# resource "nomad_job" "nfs_controller" {
#   jobspec = file("${path.module}/storage/nfs-csi/controller.nomad")
# }

# resource "nomad_job" "nfs_node" {
#   jobspec = file("${path.module}/storage/nfs-csi/node.nomad")
# }

# data "nomad_plugin" "nfs" {
#   plugin_id        = "nfs"
#   wait_for_healthy = true
# }

# resource "nomad_volume" "shared_nfs" {
#   depends_on  = [data.nomad_plugin.nfs]

#   volume_id = "nfs" # ID as seen in nomad
#   name      = "Shared NFS" # Display name
#   type      = "csi"
#   plugin_id = "nfs" # Needs to match the deployed plugin

#   external_id = "nfs"

#   capability {
#     access_mode     = "multi-node-multi-writer"
#     attachment_mode = "file-system"
#   }

#   parameters = { # Optional, allows changing owner (etc) during volume creation
#       uid = "1000",
#       gid = "1000",
#       mode = "770"

#   }   
# }