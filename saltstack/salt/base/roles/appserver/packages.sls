appserver_packages:
  pkg.installed:
    - pkgs:
      - nginx
      - python-flask
      - python-django
      - python2-pika
      - python34-pika
      - nodejs-rhea
      - rabbitmq-server
      - nodejs
      - python-pymongo
      - postgresql
      - python-psycopg2
  npm:
    pkg.installed:
      - pkgs:
        - mongoose
        - mongodb
        - pg
