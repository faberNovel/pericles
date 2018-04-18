#!/bin/bash
bundle exec rake db:migrate

exec "$@"
