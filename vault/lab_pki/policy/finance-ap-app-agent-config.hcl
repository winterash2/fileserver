# Uncomment this to have Agent run once (e.g. when running as an initContainer)
# exit_after_auth = true
pid_file = "/home/vault/pidfile"

auto_auth {
    method "kubernetes" {
        mount_path = "auth/kubernetes"
        config = {
            role = "finance-ap-app"
        }
    }

    sink "file" {
        config = {
            path = "/tmp/.vault-token"
        }
    }
}

template {
  destination = "/etc/secrets/index.html"
  contents = <<EOH
  <html>
  <body>
  <p>Finance AP-App secrets:</p>
  {{ with secret "k8s-secret/finance/ap-app/config" }}
  <ul>
  <li><pre>username: {{ .Data.data.username }}</pre></li>
  <li><pre>password: {{ .Data.data.password }}</pre></li>
  </ul>
  {{ end }}
  </body>
  </html>  
  EOH
}

# Template Stanza for certs
# crt file

# template {
#     destination = "/etc/tls/safe.crt"
#     contents = <<EOH
#     {{ with secret "pki/issue/example-dot-com" "common_name=foo.example.com" }}
#     {{ .Data.certificate }}{{ end }}
#     EOH
# }
# 
# CA cert
# template {
#     destination = "/etc/tls/ca.crt"
#     contents = <<EOH
#     {{ with secret "pki/issue/example-dot-com" "common_name=foo.example.com" }}
#     {{ .Data.issuing_ca }}{{ end }}
#     EOH
# }
# 
# App Private Key
# template {
#     destination = "/etc/tls/safe.key"
#     contents = <<EOH
#     {{ with secret "pki/issue/example-dot-com" "common_name=foo.example.com" }}
#     {{ .Data.private_key }}{{ end }}
#     EOH
# }


