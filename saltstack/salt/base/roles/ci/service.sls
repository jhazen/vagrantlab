jenkins:
  service.running:
    - enabled: True
    - watch:
      - ci_packages
