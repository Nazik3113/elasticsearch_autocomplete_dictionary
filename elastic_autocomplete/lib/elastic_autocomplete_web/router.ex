defmodule ElasticAutocompleteWeb.Router do
  use ElasticAutocompleteWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ElasticAutocompleteWeb do
    pipe_through :api

    get "/dictionary", SearchController, :search
  end
end
