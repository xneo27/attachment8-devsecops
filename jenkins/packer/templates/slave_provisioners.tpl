[
  {
    "type" : "file",
    "source" : "${resource_path}/telegraf.conf",
    "destination" : "/tmp/telegraf.conf"
  },
  {
    "type" : "shell",
    "script" : "${resource_path}/setup.sh",
    "execute_command" : "sudo -E -S sh '{{ .Path }}'"
  }
]