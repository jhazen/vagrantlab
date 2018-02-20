vagrant_db:
  postgres_database.present:
    - name: vagrant
    - db_user: vagrant
    - db_password: vagrant
    - db_host: 0.0.0.0
    - db_port: 5432
    - watch:
      - postgresql

postgresql:
  service.running:
    - enable: True
    - watch:
      - postgresql_config
      - postgresql_hba_config

postgresql_data:        
  postgres_initdb.present:
    - name: /var/lib/pgsql/data
    - auth: password
    - user: vagrant
    - password: vagrant
    - encoding: UTF8
    - locale: C
    - runas: postgres
    - watch:
      - dbserver_packages
