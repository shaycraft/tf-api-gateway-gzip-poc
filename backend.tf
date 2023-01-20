terraform {
  cloud {
    organization = "mr-gav-meow"

    workspaces {
      name = "tf-api-gateway-gzip-poc"
    }
  }
}
