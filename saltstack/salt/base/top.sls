base:
  '*':
  - general.hosts

  'app*':
  - roles.appserver

  'db*':
  - roles.dbserver

  'roles:lb':
  - match: grain
  - roles.lb

  'roles:ci':
  - match: grain
  - roles.ci
