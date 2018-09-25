# Pericles Proxy

Proxy based on proxy configurations of Pericles database. It records raw reports requiring further inspection.

## Installation

This proxy requires Elixir.

To install dependencies run:

```elixir
mix deps.get
```

## Usage

To start the proxy run:

```elixir
mix run --no-halt
```

If you want to use debug, you can insert IEx.pry in the code and start the server with:

```elixir
iex -S mix run --no-halt
```

To run tests:

```elixir
mix test
```

## Deployment

### Heroku

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

Once the proxy is deployed, you need to give it access to your Pericles database. First get the identifier of your Pericles database add-on with:

```
heroku addons -a <YOUR_PERICLES_PROXY_APP>
```

Then attach this add-on to your Pericles proxy app:

```
heroku addons:attach <YOUR_PERICLES_DB_ADD_ON_ID> -a <YOUR_PERICLES_PROXY_APP>
```

### Container

TODO, PR are welcome 😀
