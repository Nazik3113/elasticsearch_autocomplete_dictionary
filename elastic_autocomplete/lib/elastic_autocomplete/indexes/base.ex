defmodule ElasticAutocomplete.Indexes.Base do
  @moduledoc """
    Module for Elasticsearch indexes creation from configs.
  """

  alias ElasticAutocomplete.Base

  require Logger

  @indexes Application.compile_env!(:elastic_autocomplete, :indexes)

  def indexed? do
    Enum.each(@indexes, fn index_module ->
      case index_module.count() do
        {:ok, count} when count > 300000 ->
          Enum.each(0..100, fn _ ->
            Logger.debug("Index #{index_module.index() |> elem(0)} already indexed and are reqdy to accept requests.")
          end)
        error ->
          :timer.sleep(2000)
          indexed?()
      end
    end)
  end

  def fill() do
    Enum.each(@indexes, fn index_module ->
      case index_module.count() do
        {:ok, count} when count == 0 ->
          {name, _settings} = index_module.index()

          Logger.debug("Index #{name} filling...")

          File.stream!(index_module.data_path(), [], :line)
          |> Stream.map(&String.trim_trailing/1)
          |> Stream.chunk_every(50000)
          |> Enum.each(fn words ->
            index_module.create_many(words)
          end)

          Logger.debug("Index #{name} filled!")

        {:ok, count} when count > 0 ->
          {name, _settings} = index_module.index()

          Logger.debug("Index #{name} already filled.")

        error ->
          {name, _settings} = index_module.index()

          Logger.error("Index #{name} fill error: Something went wrong: #{inspect(error)}")
          :timer.sleep(5000)
          fill()
      end
    end)
  end

  @doc """
    Create indexex frpm configs.
  """
  @spec create() :: {:ok, String.t()} | {:error, String.t()}
  def create() do
    Enum.each(@indexes, fn index_module ->
      {name, settings} = index_module.index()

      case Base.create_index(name, settings) do
        :ok ->
          Logger.debug("Index #{name} created.")

        {:error, %Elasticsearch.Exception{type: "resource_already_exists_exception"}} ->
          Logger.debug("Index #{name} already exists.")

        error ->
          Logger.error("Index create error: Something went wrong: #{inspect(error)}")
          :timer.sleep(5000)
          create()
      end
    end)
  end
end
