![latest](https://github.com/lbausch/laravel-ci/actions/workflows/docker-registry.yml/badge.svg)

# lbausch/laravel-ci <!-- omit in toc -->

A Docker Image for Continuous Integration based on Debian 13 (trixie) or Debian 12 (bookworm).

- [Features](#features)
- [Tags](#tags)
- [Usage](#usage)
  - [GitLab CI/CD](#gitlab-cicd)

## Features
+ PHP 5.6 to 8.5 with the extensions bcmath, curl, dom, gd, gmp, imap, intl, ldap, mbstring, mysql, redis, soap, sqlite, tidy, xdebug and zip
+ Composer 2 (2.2 LTS for PHP < 7.2.5)
+ Node.js 24
+ npm 10
+ Yarn
+ Supports [Laravel Dusk](https://laravel.com/docs/master/dusk) (Chromium)


## Tags
Every PHP version is built on Debian 13 (trixie) and Debian 12 (bookworm). All images are rebuilt weekly.

| PHP | Debian 13 (trixie)                    | Debian 12 (bookworm) |
|-----|---------------------------------------|----------------------|
| 8.5 | `latest`, `php85`, `php85-trixie`     | `php85-bookworm`     |
| 8.4 | `php84`, `php84-trixie`               | `php84-bookworm`     |
| 8.3 | `php83`, `php83-trixie`               | `php83-bookworm`     |
| 8.2 | `php82`, `php82-trixie`               | `php82-bookworm`     |
| 8.1 | `php81`, `php81-trixie`               | `php81-bookworm`     |
| 8.0 | `php80`, `php80-trixie`               | `php80-bookworm`     |
| 7.4 | `php74`, `php74-trixie`               | `php74-bookworm`     |
| 7.3 | `php73`, `php73-trixie`               | `php73-bookworm`     |
| 7.2 | `php72`, `php72-trixie`               | `php72-bookworm`     |
| 7.1 | `php71`, `php71-trixie`               | `php71-bookworm`     |
| 7.0 | `php70`, `php70-trixie`               | `php70-bookworm`     |
| 5.6 | `php56`, `php56-trixie`               | `php56-bookworm`     |

Tags without a Debian suffix (e.g. `php85`) and `latest` always use the newest Debian release, so their Debian release changes when a new one is added. Use a tag with a Debian suffix (e.g. `php85-trixie`) to stay on a specific Debian release.


## Usage

### GitLab CI/CD
See [.gitlab-ci.yml](https://github.com/lbausch/laravel-ci/blob/master/docs/.gitlab-ci.yml) in the `docs/` directory of the `master` branch for a reference configuration.
