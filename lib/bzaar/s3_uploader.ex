defmodule Bzaar.S3Uploader do

  def generate_url(path, mimetype) do
    bucket = Application.get_env(:ex_aws, :bucket)
    {:ok, url} = ExAws.S3.presigned_url(ExAws.Config.new(:s3), :put, bucket, path, query_params: [{"ACL", "authenticated-read"}, {"contentType", mimetype}], virtual_host: true)
  end

  def get_access_bucket(path) do
    bucket = Application.get_env(:ex_aws, :bucket)
    endpoint = get_access_endpoint(path)
    "#{endpoint}#{bucket}/#{path}"
  end

  defp get_access_endpoint(path) do
    s3_endpoint = Application.get_env(:ex_aws, :s3)
    "#{s3_endpoint[:scheme]}s3-${s3_endpoint[:region]}.amazonaws.com/"
  end

end