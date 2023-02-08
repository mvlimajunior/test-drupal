## Drupal Test

Drupal application with custom docker image with mysql and nginx runs directly.
Content generated content with drush's devel generate
## Installation - First use

* docker compose up --build
* default address **http://localhost:8160/**

## Feature

- Data Sample generation
    - drush genc 10 --bundles=actor
    - drush genc 20 --bundles=movie