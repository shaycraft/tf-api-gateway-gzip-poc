variable "src_path" {
  type        = string
  description = "Path to lambda source directory"
}

variable "name" {
  type        = string
  description = "Lambda name"
}

variable "description" {
  type        = string
  description = "Lambda description"
}

variable "runtime" {
  type        = string
  description = "Lambda Runtime"

  default = "nodejs16.x"

  validation {
    condition     = contains(["nodejs14.x", "nodejs16.x", "nodejs18.x", "python3.7", "python3.8", "python3.9"], var.runtime)
    error_message = "Unsupported runtime"
  }
}

variable "api_gateway_id" {
  type        = string
  description = "Api Gateway Id"
}