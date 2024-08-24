# OmniOpenCon Website

This is the website (landing page) of the OmniOpenCon conference.
It is generated using [Hugo](https://gohugo.io/) and the [`hugo-conference` theme](https://github.com/jweslley/hugo-conference).
The website contents are stored in the `site/` directory.

## Running Locally with Docker

To run the website locally, it is easiest to use [Docker](https://www.docker.com/).
You need to have [Docker installed](https://docs.docker.com/engine/install/).

Then, run:

```console
make
```

This will fire up a Docker container that runs Hugo on the website.
Point your browser to http://localhost:1313 to see thwe website.

Changes you make in the `site/` directory will become visible in the website.

## Runnnig Locally with Hugo

To run the website locally, install [Hugo](https://gohugo.io/installation/).
Then, run the website using:

```console
hugo server --source site/
```

Point your browser to http://localhost:1313 to see thwe website.

In order to have the Google Map visible (in the `Location` section), you need to pass a [GoogleMaps API Key](https://github.com/jweslley/hugo-conference/?tab=readme-ov-file#google-maps) paramenter to Hugo:

## Initializing the Website Contents

The website contents have already been initialized, as currently in the repository.

The first step was to create the `site/` directory:

```
hugo init site
```

Then we added the [`hugo-conference` theme](https://github.com/jweslley/hugo-conference):

```console
git clone --depth=1 https://github.com/jweslley/hugo-conference site/themes/hugo-conference
rm -fr site/themes/hugo-conference/.git
```

Then we did the basic configuration:

* Add configuration file:

  ```console
  rm site/hugo.toml
  cp site/themes/hugo-conference/exampleSite/config.yml site
  ```

* Update older configurations:

  ```console
  sed -i '/\.Hugo\.Generator/d' site/themes/hugo-conference/layouts/index.html
  sed -i 's/template "_internal\/google_analytics_sync.html"/template "_internal\/google_analytics.html"/g' site/themes/hugo-conference/layouts/index.html
  ```

* Add `baseurl` configuration:

  ```console
  sed -i 's/^baseurl: .*$/baseurl: "https:\/\/omniopencon.fra0.kraft.host\/"/g' site/config.yml
  ```

* Copy static files (images):

  ```console
  cp -r site/themes/hugo-conference/exampleSite/static/* site/static/
  ```

* Remove the `exampleSite` files from the theme:

  ```console
  ```
