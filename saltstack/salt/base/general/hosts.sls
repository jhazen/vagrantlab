hosts:
  file.managed:
    - name: /etc/hosts
    - source: salt://general/hosts.conf
