ci_packages:
  pkg.installed:
    - pkgs:
      - jenkins
      - java-1.8.0-openjdk
    - require:
      - pkgrepo: ci
