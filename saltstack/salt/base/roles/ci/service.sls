jenkins:
  service.running:
    - enable: True
    - watch:
      - ci_packages
