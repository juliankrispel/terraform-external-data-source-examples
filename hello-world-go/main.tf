data "external" "go" {
  program = ["go", "run", "${path.module}/data-source.go"]
}

output "external_source" {
  value = data.external.go.result
}