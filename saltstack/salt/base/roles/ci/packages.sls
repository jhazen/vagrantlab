ci_packages:
  pkg.installed:
    - pkgs:
      - jenkins
      - java
    - require:
      - pkgrepo: ci
