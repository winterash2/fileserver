# Uncomment this to have Agent run once (e.g. when running as an initContainer)
exit_after_auth = true
pid_file = "/home/vault/pidfile"

auto_auth {
    method "kubernetes" {
        mount_path = "auth/kubernetes"
        config = {
            role = "it-operations"
        }
    }

    sink "file" {
        config = {
            path = "/home/vault/.vault-token"
        }
    }
}
template {
  destination = "/etc/secrets/index.html"
  contents = <<EOH
  <html>
  <body>
  <p>IT Operations secrets:</p>
  {{ with secret "k8s-secret/it/operations/config" }}
  <ul>
  <li><pre>username: {{ .Data.data.username }}</pre></li>
  <li><pre>password: {{ .Data.data.password }}</pre></li>
  </ul>
  {{ end }}
  </body>
  </html>  
  EOH
}