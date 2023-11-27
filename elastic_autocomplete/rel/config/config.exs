import Config

if config_env() == :prod do
  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  config :passport_login, ElasticAutocompleteWeb.Endpoint,
    http: [
      port: String.to_integer(System.get_env("PORT") || "4000")
    ],
    url: [host: System.get_env("HOST"), port: System.get_env("PORT") || "4000"],
    server: true,
    root: ".",
    secret_key_base: secret_key_base
end
