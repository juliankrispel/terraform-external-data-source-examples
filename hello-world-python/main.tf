data "external" "python" {
  program = ["python", "${path.module}/data-source.py"]
}

output "external_source" {
  value = data.external.python.result
}