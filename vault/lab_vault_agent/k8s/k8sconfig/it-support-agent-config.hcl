# Uncomment this to have Agent run once (e.g. when running as an initContainer)
# exit_after_auth = true
pid_file = "/home/vault/pidfile"

auto_auth {
    method "kubernetes" {
        mount_path = ""
        config = {
            role = ""
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
  <p>IT Support secrets:</p>
  <ul>
  <li><pre>username: </pre></li>
  <li><pre>password: </pre></li>
  </ul>
  {{ end }}
  </body>
  </html>  
  EOH
}

