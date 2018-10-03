web: bundle exec passenger start -p $PORT --max-pool-size 3
worker: bundle exec rails jobs:work
release: rake db:migrate
