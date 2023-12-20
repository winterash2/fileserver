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

