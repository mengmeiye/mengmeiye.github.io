# Local preview environment, used by docker-compose.yml.
# (GitHub Actions does not use this file; it builds the site directly.)
FROM ruby:3.4-slim

# Compilers for the few gems with native extensions (e.g. eventmachine for live reload)
RUN apt-get update \
 && apt-get install -y --no-install-recommends build-essential \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /srv/jekyll
COPY Gemfile Gemfile.lock ./
RUN bundle install

EXPOSE 8080 35729
CMD ["bundle", "exec", "jekyll", "serve", "--host", "0.0.0.0", "--port", "8080", "--livereload", "--force_polling"]
