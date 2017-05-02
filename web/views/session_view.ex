defmodule Bzaar.SessionView do
  use Bzaar.Web, :view

  def render("login.json", params) do
    %{user: params.user, jwt: params.jwt, exp: params.exp}
  end

  def render("error.json", user, jwt, exp) do
    %{user: user, jwt: jwt, exp: exp}
  end

end