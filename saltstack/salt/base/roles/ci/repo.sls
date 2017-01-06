ci_repo:
  pkgrepo.managed:
    - name: ci
    - humanname: Jenkins Repo
    - baseurl: http://pkg.jenkins.io/redhat-stable
    - gpgkey: http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key
    - gpgcheck: 1

