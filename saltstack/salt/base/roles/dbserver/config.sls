postgresql_config:
  file.managed:
    - source: salt://conf/postgres/postgresql.conf
    - name: /var/lib/pgsql/data/postgresql.conf
    - watch:
      - postgresql_data

postgresql_hba_config:
  file.managed:
    - source: salt://conf/postgres/pg_hba.conf
    - name: /var/lib/pgsql/data/pg_hba.conf
    - watch:
      - postgresql_data
