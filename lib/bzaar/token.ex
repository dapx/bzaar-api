defmodule Bzaar.Token do
  @moduledoc """
  Handles creating and validating tokens.
  """

  alias Bzaar.User

  def generate_new_account_token(%User{ id: user_id }) do
    Phoenix.Token.sign(Bzaar.Endpoint, get_salt(), user_id)
  end

  def verify_new_account_token(token) do
    max_age = 86_400 # tokens that are older than a day should be invalid
    Phoenix.Token.verify(Bzaar.Endpoint, get_salt(), token, max_age: max_age)
  end

  defp get_salt do
    Application.get_env(:bzaar, Bzaar.Endpoint)[:secret_key_base]
  end

end