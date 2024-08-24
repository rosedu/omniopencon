# OmniOpenCon Website

This is the website (landing page) of the OmniOpenCon conference.
It is generated using [Hugo](https://gohugo.io/) and the [`hugo-conference` theme](https://github.com/jweslley/hugo-conference).

## Running Locally with Docker

To run the website locally, it is easiest to use [Docker](https://www.docker.com/).
You need to have [Docker installed](https://docs.docker.com/engine/install/).

Then, run:

```console
make
```

This will fire up a Docker container that runs Hugo on the website.
Hugo generates the website contents in the `public/` directory.
And then it starts a custom web server to serve the generated contents.
Point your browser to http://localhost:1313 to see thwe website.

Changes you make in the `public/` directory will become visible in the website.

## Runnnig Locally with Hugo

To run the website locally, install [Hugo](https://gohugo.io/installation/).
Then, generate and serve the website using:

```console
hugo server
```

Point your browser to http://localhost:1313 to see the website.

## Initializing the Website Contents

The website contents have already been initialized, as currently in the repository.

The first step was to create the initial Hugo website contents in the current directory:

```
hugo init .
```

Then we added the [`hugo-conference` theme](https://github.com/jweslley/hugo-conference):

```console
git clone --depth=1 https://github.com/jweslley/hugo-conference themes/hugo-conference
rm -fr themes/hugo-conference/.git
```

Then we did the basic configuration:

* Add configuration file:

  ```console
  rm hugo.toml
  cp themes/hugo-conference/exampleSite/config.yml .
  ```

* Update older configurations:

  ```console
  sed -i '/\.Hugo\.Generator/d' themes/hugo-conference/layouts/index.html
  sed -i 's/template "_internal\/google_analytics_sync.html"/template "_internal\/google_analytics.html"/g' themes/hugo-conference/layouts/index.html
  ```

* Add `baseurl` configuration:

  ```console
  sed -i 's/^baseurl: .*$/baseurl: "https:\/\/omniopencon.fra0.kraft.host\/"/g' config.yml
  ```

* Copy static files (images):

  ```console
  cp -r themes/hugo-conference/exampleSite/static/* static/
  ```

* Remove the `exampleSite` files from the theme:

  ```console
  rm -fr themes/hugo-conference/exampleSite
  ```
