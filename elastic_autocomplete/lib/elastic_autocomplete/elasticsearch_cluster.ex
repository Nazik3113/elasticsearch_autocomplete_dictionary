defmodule ElasticAutocomplete.ElasticsearchCluster do
  use Elasticsearch.Cluster, otp_app: :elastic_autocomplete
end
