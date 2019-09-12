[
  {
    "type" : "file",
    "source" : "${resource_path}/basic-security.groovy",
    "destination" : "/tmp/basic-security.groovy"
  },
  {
    "type" : "file",
    "source" : "${resource_path}/jenkins.install.UpgradeWizard.state",
    "destination" : "/tmp/jenkins.install.UpgradeWizard.state"
  },
  {
    "type" : "file",
    "source" : "${resource_path}/disable-cli.groovy",
    "destination" : "/tmp/disable-cli.groovy"
  },
  {
      "type" : "file",
      "source" : "${resource_path}/update_plugins.groovy",
      "destination" : "/tmp/update_plugins.groovy"
    },
  {
    "type" : "file",
    "source" : "${resource_path}/csrf-protection.groovy",
    "destination" : "/tmp/csrf-protection.groovy"
  },
  {
    "type" : "file",
    "source" : "${resource_path}/disable-jnlp.groovy",
    "destination" : "/tmp/disable-jnlp.groovy"
  },
  {
    "type" : "file",
    "source" : "${resource_path}/jenkins",
    "destination" : "/tmp/jenkins"
  },
  {
    "type" : "file",
    "source" : "${cert_path}",
    "destination" : "/tmp/id_rsa"
  },
  {
    "type" : "file",
    "source" : "${resource_path}/node-agent.groovy",
    "destination" : "/tmp/node-agent.groovy"
  },
  {
    "type": "file",
    "source": "${cert_path}",
    "destination" : "/tmp/slave_id_rsa"
  },
  {
    "type" : "file",
    "source" : "${resource_path}/plugins.txt",
    "destination" : "/tmp/plugins.txt"
  },
  {
    "type" : "file",
    "source" : "${resource_path}/install-plugins.sh",
    "destination" : "/tmp/install-plugins.sh"
  },
  {
    "type" : "file",
    "source" : "${resource_path}/telegraf.conf",
    "destination" : "/tmp/telegraf.conf"
  },
  {
    "type" : "file",
    "source" : "${resource_path}/jobs.yml",
    "destination" : "/tmp/job.yml"
  },
  {
      "type" : "file",
      "source" : "${resource_path}/generate_token.groovy",
      "destination" : "/tmp/generate_token.groovy"
  },
  {
    "type" : "shell",
    "script" : "${resource_path}/setup.sh",
    "execute_command" : "sudo -E -S sh '{{ .Path }}'"
  }
]