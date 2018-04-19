#!/bin/bash
bundle exec rake db:migrate
bundle exec rails assets:precompile

exec "$@"
