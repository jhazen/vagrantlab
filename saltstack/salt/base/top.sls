base:
  '*':
  - general.hosts

  'app*':
  - roles.appserver

  'db*':
  - roles.dbserver

  'ci*':
  - roles.ci

  'lb*':
  - roles.lb

  'roles:lb':
  - match: grain
  - roles.lb

  'roles:ci':
  - match: grain
  - roles.ci

  'roles:app':
  - match: grain
  - roles.appserver

  'roles:db':
  - match: grain
  - roles.dbserver
