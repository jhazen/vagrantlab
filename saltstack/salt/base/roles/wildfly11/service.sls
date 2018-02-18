wildfly11_srv:
  cmd.run:
    - name: nohup /opt/wildfly-11.0.0.Final/bin/standalone.sh -b=0.0.0.0 -bmanagement=0.0.0.0 &
    - bg: true
    - watch:
      - archive: /opt/

wildfly11_user:
  cmd.run:
    - name: /opt/wildfly-11.0.0.Final/bin/add-user.sh vagrant vagrant
    - watch:
      - archive: /opt/
