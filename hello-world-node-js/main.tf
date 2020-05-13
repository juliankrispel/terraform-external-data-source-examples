data "external" "js" {
  program = ["node", "${path.module}/data-source.js"]
}

output "external_source" {
  value = data.external.js.result
}