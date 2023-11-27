defmodule ElasticAutocompleteWeb.SearchController do
  use ElasticAutocompleteWeb, :controller

  alias ElasticAutocomplete.Indexes.Dictionary

  @doc """
    Route: /api/dictionary?word=<word>&limit=<limit>
  """
  @spec search(Plug.Conn.t(), Map.t()) :: Plug.Conn.t()
  def search(conn, %{ "word" => word, "limit" => limit } = _params) do
    case Dictionary.search(word, limit) do
      {:ok, words} ->
        conn |> json(%{ status: 1, words: words })
      {:error, error} ->
        conn |> json(%{ status: 0, error: error })
    end
  end

  def search(conn, %{ "word" => word } = _params) do
    case Dictionary.search(word) do
      {:ok, words} ->
        conn |> json(%{ status: 1, words: words })
      {:error, error} ->
        conn |> json(%{ status: 0, error: error })
    end
  end
end
