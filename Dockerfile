FROM ruby:2.5

RUN curl -sL https://deb.nodesource.com/setup_7.x | bash
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y yarn

RUN apt-get update && \
    apt-get install -y curl && \
    apt-get install -y graphviz && \
    apt-get install -y nodejs

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

RUN mkdir -p /app && cd /app
WORKDIR /app

COPY Gemfile Gemfile.lock ./
COPY . .
RUN bundle install
RUN yarn install
RUN ["chmod", "+x", "docker-entrypoint.sh"]
ENTRYPOINT ["./docker-entrypoint.sh"]

CMD ["bundle exec rails s"]
