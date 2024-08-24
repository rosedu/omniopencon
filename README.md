# OmniOpenCon Website

This is the website (landing page) of the OmniOpenCon conference.
It is generated using [Hugo](https://gohugo.io/).

## Running Locally

To run the website locally, install [Hugo](https://gohugo.io/installation/).
Then, run the website using:

```console
hugo server --source site/
```

Point your browser to http://localhost:1313 to see thwe website.

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
