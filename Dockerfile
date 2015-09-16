FROM buildpack-deps:wheezy-curl

RUN sed -i "s/httpredir.debian.org/mirror.evolix.org/" /etc/apt/sources.list

RUN apt-get update && apt-get -y --no-install-recommends install \
    build-essential \
    apt-utils \
    ruby1.8 ruby1.8-dev rubygems1.8 \
    libbz2-dev libcurl4-openssl-dev libxml2-dev libxslt1-dev zlib1g-dev \
    libmysqlclient-dev libmagickcore-dev libmagickwand-dev libreadline-dev \
    libffi-dev \
    git \
    vim \
  && rm -rf /var/lib/apt/lists/*


# skip installing gem documentation
RUN echo 'install: --no-document' >> "$HOME/.gemrc" \
    && echo 'update: --no-document' >> "$HOME/.gemrc"

# install things globally, for great justice
ENV GEM_HOME /usr/local/bundle
ENV PATH $GEM_HOME/bin:$PATH

ENV BUNDLER_VERSION 1.10.6

RUN gem install bundler --version "$BUNDLER_VERSION" \
	&& bundle config --global path "$GEM_HOME" \
	&& bundle config --global bin "$GEM_HOME/bin"

# don't create ".bundle" in all our apps
ENV BUNDLE_APP_CONFIG $GEM_HOME
