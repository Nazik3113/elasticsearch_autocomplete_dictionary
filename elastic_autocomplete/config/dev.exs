import Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with esbuild to bundle .js and .css sources.
config :elastic_autocomplete, ElasticAutocompleteWeb.Endpoint,
  # Binding to loopback ipv4 address prevents access from other machines.
  # Change to `ip: {0, 0, 0, 0}` to allow access from other machines.
  http: [ip: {0, 0, 0, 0}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "PwzSoiR4VdD9VMX8tOIeEZiU3uQrhwAeXDarKLSVPgAuUZRszYgDg85AHkD0kD0a",
  watchers: []

# ## SSL Support
#
# In order to use HTTPS in development, a self-signed
# certificate can be generated by running the following
# Mix task:
#
#     mix phx.gen.cert
#
# Note that this task requires Erlang/OTP 20 or later.
# Run `mix help phx.gen.cert` for more information.
#
# The `http:` config above can be replaced with:
#
#     https: [
#       port: 4001,
#       cipher_suite: :strong,
#       keyfile: "priv/cert/selfsigned_key.pem",
#       certfile: "priv/cert/selfsigned.pem"
#     ],
#
# If desired, both `http:` and `https:` keys can be
# configured to run both http and https servers on
# different ports.

config :elastic_autocomplete, ElasticAutocomplete.ElasticsearchCluster,
  # The URL where Elasticsearch is hosted on your system
  url: "http://hsa1011-es-container:9200",

  # If you want to mock the responses of the Elasticsearch JSON API
  # for testing or other purposes, you can inject a different module
  # here. It must implement the Elasticsearch.API behaviour.
  api: Elasticsearch.API.HTTP,

  # Customize the library used for JSON encoding/decoding.
  json_library: Jason # or Poison

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n", level: :debug

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime
