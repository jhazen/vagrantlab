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

mongoose:
  npm.installed
mongodb:
  npm.installed
pg:
  npm.installed
