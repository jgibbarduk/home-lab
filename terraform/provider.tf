# The following variable is used to configure the provider's authentication
# token. You don't need to provide a token on the command line to apply changes,
# though: using the remote backend, Terraform will execute remotely in Terraform
# Cloud where your token is already securely stored in your workspace!

# Configure the Nomad provider
provider "nomad" {
  # address = "https://nomad.dingous.net"
  address = "http://100.93.151.41:4646"
  
}