import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :elastic_autocomplete, ElasticAutocompleteWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "wDVWetJIYnPW99SmorsXfrCW2w2znNgwy92Y7B4so9OsMdCQdvse+BXjrrqLQ81r",
  server: false

# Print only warnings and errors during test
config :logger, level: [:emergency, :alert, :critical, :error, :debug]

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
