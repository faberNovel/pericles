FROM ruby:2.6.3

RUN apt-get update && apt-get install -y curl wget gnupg git build-essential patch ruby-dev zlib1g-dev liblzma-dev libpq-dev
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install -y yarn && \
    apt-get update && \
    apt-get install -y curl graphviz nodejs && \
    bundle config --global frozen 1 && \
    mkdir -p /app

WORKDIR /app

COPY Gemfile Gemfile.lock ./
COPY . .
RUN bundle install && \
    yarn install

RUN ["chmod", "+x", "docker-entrypoint.sh"]
ENTRYPOINT ["./docker-entrypoint.sh"]

CMD bundle exec passenger start -p $PORT --max-pool-size 3
