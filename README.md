# OTA API - Developer Guide

> Check it live at: http://ota-doc.weekendesk.com/

## Getting Started with Slate

### Prerequisites

You're going to need:

 - **Linux or OS X** — Windows may work, but is unsupported.
 - **Ruby, version 2.3.1 or newer**.
 - **Bundler** — If Ruby is already installed, but the `bundle` command doesn't work, just run `gem install bundler` in a terminal.

### Getting Set Up

1. Clone this repository.
2. `cd OTA-API-Developer-Guide`
3. Initialize and start Slate. You can either do this locally, or with Vagrant:

```shell
# either run this to run locally
bundle install
bundle exec middleman server

# OR run this to run with vagrant
vagrant up
```

You can now see the docs at http://localhost:4567. Whoa! That was fast!

Now that `OTA-API-Developer-Guide` is all set up on your machine, you'll probably want to learn more about [editing Slate markdown](https://github.com/lord/slate/wiki/Markdown-Syntax), or [how to publish your docs](https://github.com/lord/slate/wiki/Deploying-Slate).

### Getting started Slate with Docker

> Prerequisites: [Docker and Docker Compose](https://docs.docker.com/engine/installation/)

- Download this repository.
- Run the following command line on the terminal:

      docker-compose up

- Go to [localhost:4567](http://localhost:4567) to see the documentation.

### Live edition

- Open your file editor of preference.
- Edit the files within the [source folder](./source).
- Reload the page.

### Deploy to production

- Upload the generated files to the `gh-pages` branch.
- After that github will upload automatically the changes to the [public domain](https://ota-doc.weekendesk.com/#introduction)

### Deploy to production (Apple Silicon / arm64)

Make sure your changes are merged into `master`, then run:

```shell
./deploy-arm64.sh
```

This script builds the documentation site inside a Docker container (required for compatibility with arm64 Macs) and publishes the generated files to the `gh-pages` branch, which GitHub Pages serves as the public site at [ota-doc.weekendesk.com](https://ota-doc.weekendesk.com).

> Prerequisites: [Docker Desktop](https://www.docker.com/products/docker-desktop/) must be running.