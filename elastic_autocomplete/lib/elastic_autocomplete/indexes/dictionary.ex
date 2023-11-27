defmodule ElasticAutocomplete.Indexes.Dictionary do
  @moduledoc """
    Dictionary index.
  """

  alias ElasticAutocomplete.Base

  @index_name "dictionary"
  @default_limit 50

  @doc false
  @spec count() :: {:ok, Integer.t()} | {:error, String.t()}
  def count do
    case Base.count(@index_name) do
      {:ok, %{"count" => count}} -> {:ok, count}
      error -> {:error, "Count records in index #{@index_name} error: #{inspect(error)}"}
    end
  end

  @doc false
  @spec create_many(List.t()) :: {:ok, String.t()} | {:error, String.t()}
  def create_many(words) do
    Base.create_multiple(@index_name, multiple_query(words))
  end

  @doc false
  @spec create(String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def create(word) do
    case Base.create(@index_name, %{
           word: word,
           length: String.length(word)
         }) do
      {:ok, %{"_id" => id, "result" => "created"}} -> {:ok, id}
      error -> {:error, "Create record in index #{@index_name} error: #{inspect(error)}"}
    end
  end

  @doc """
    Search query for words with autocomplete and allowed mistakes(3 max if word length is more than 7).
  """
  @spec search(String.t(), Integer.t()) :: {:ok, List.t()} | {:error, String.t()}
  def search(word, limit \\ @default_limit) do
    with {:ok, %{"hits" => %{"hits" => words}}} <-
           Base.search(@index_name, %{
             query: %{
               bool: %{
                 must: %{
                   multi_match: %{
                     query: word,
                     fields: ["word"],
                     minimum_should_match: "2<-1 4<-2 7<-3"
                   }
                 },
                 filter: [
                   %{
                     range: %{
                       length: %{
                         gte: String.length(word)
                       }
                     }
                   }
                 ]
               }
             },
             sort: [
               %{
                 _score: %{
                   order: "desc"
                 }
               },
               %{
                 length: %{
                   order: "asc"
                 }
               }
             ],
             size: limit
           }),
         pretty_resp <- pretty_response(words) do
      {:ok, pretty_resp}
    else
      error -> {:error, "Something went wrong: #{inspect(error)}"}
    end
  end

  defp pretty_response(words) do
    Enum.map(words, fn %{"_source" => %{"word" => word}, "_score" => score} ->
      %{word: word, score: score}
    end)
  end

  defp multiple_query(words) do
    Enum.map(words, fn word ->
      "{ \"index\": {} }\n{ \"word\": \"#{word}\", \"length\": #{String.length(word)} }\n"
    end)
    |> Enum.join("")
  end

  def data_path do
    "priv/#{@index_name}.txt"
  end

  @doc """
    Index settings.
  """
  @spec index() :: {String.t(), Map.t()}
  def index do
    {@index_name,
     %{
       settings: %{
         index: %{
           max_ngram_diff: 3
         },
         analysis: %{
           analyzer: %{
             default: %{
               type: "custom",
               tokenizer: "standard",
               filter: [
                 "lowercase",
                 "autocomplete"
               ]
             }
           },
           filter: %{
             autocomplete: %{
               type: "ngram",
               min_gram: 2,
               max_gram: 5
             }
           }
         }
       },
       mappings: %{
         properties: %{
           word: %{
             type: "completion",
             analyzer: "default",
             search_analyzer: "default"
           },
           length: %{
             type: "long"
           }
         }
       }
     }}
  end
end
