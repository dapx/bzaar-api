defmodule Bzaar.S3Uploader do

  def generate_url(path, mimetype) do
    bucket = Application.get_env(:ex_aws, :bucket)
    {:ok, url} = ExAws.S3.presigned_url(ExAws.Config.new(:s3), :put, bucket, path, query_params: [{"ACL", "authenticated-read"}, {"contentType", mimetype}], virtual_host: true)
  end

end