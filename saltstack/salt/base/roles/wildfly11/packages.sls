wildfly11_packages:
  pkg.installed:
    - pkgs:
      - java-1.8.0-openjdk
  archive:
    - extracted
    - name: /opt/
    - source: http://download.jboss.org/wildfly/11.0.0.Final/wildfly-11.0.0.Final.tar.gz
    - source_hash: md5=c68224ce162371a1aa7890f847cebca5
    - archive_format: tar
    - options: z
    - if_missing: /opt/wildfly-11.0.0.Final
