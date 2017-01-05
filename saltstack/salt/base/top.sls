base:
  '*':
  - general.hosts

  'app*':
  - roles.appserver

  'db*':
  - roles.dbserver
