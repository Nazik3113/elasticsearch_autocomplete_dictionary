defmodule ElasticAutocomplete.Base do
  @moduledoc """
    Main elastic apis.
  """

  def count(index) do
    Elasticsearch.get(ElasticAutocomplete.ElasticsearchCluster, "/#{index}/_count")
  end

  @doc """
    Create record in index by name and query.
  """
  @spec create(String.t(), Map.t()) ::
          {:ok, Map.t()} | {:error, String.t()} | {:error, Elasticsearch.Exception.t()}
  def create(index, query) do
    Elasticsearch.post(
      ElasticAutocomplete.ElasticsearchCluster,
      "/#{index}/_doc",
      query
    )
  end

  @doc """
    Create multiple records in index by name and query.
  """
  @spec create_multiple(String.t(), String.t()) ::
          {:ok, Map.t()} | {:error, String.t()} | {:error, Elasticsearch.Exception.t()}
  def create_multiple(index, query) do
    Elasticsearch.post(
      ElasticAutocomplete.ElasticsearchCluster,
      "/#{index}/_bulk",
      query
    )
  end

  @doc """
    Search query by index.
  """
  @spec search(String.t(), Map.t()) ::
          {:ok, Map.t()} | {:error, String.t()} | {:error, Elasticsearch.Exception.t()}
  def search(index, query) when is_bitstring(index) and is_map(query) do
    Elasticsearch.post(
      ElasticAutocomplete.ElasticsearchCluster,
      "/#{index}/_search",
      query
    )
  end

  def search(_, _), do: {:error, "Invalid index or query."}

  @doc false
  @spec create_index(String.t(), Map.t()) ::
          :ok | {:error, String.t()} | {:error, Elasticsearch.Exception.t()}
  def create_index(name, settings) when is_bitstring(name) and is_map(settings) do
    Elasticsearch.Index.create(
      ElasticAutocomplete.ElasticsearchCluster,
      name,
      settings
    )
  end

  def create_index(_, _), do: {:error, "Invalid index name or settings."}
end
