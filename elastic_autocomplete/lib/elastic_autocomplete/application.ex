defmodule ElasticAutocomplete.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      ElasticAutocompleteWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: ElasticAutocomplete.PubSub},
      # Start the Endpoint (http/https)
      ElasticAutocompleteWeb.Endpoint,
      ElasticAutocomplete.ElasticsearchCluster
      # Start a worker by calling: ElasticAutocomplete.Worker.start_link(arg)
      # {ElasticAutocomplete.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ElasticAutocomplete.Supervisor]
    start_res = Supervisor.start_link(children, opts)

    ElasticAutocomplete.Indexes.Base.create()
    ElasticAutocomplete.Indexes.Base.fill()
    ElasticAutocomplete.Indexes.Base.indexed?()

    start_res
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ElasticAutocompleteWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
