defmodule Bzaar.SessionView do
  use Bzaar.Web, :view

  def render("show.json", %{sessions: sessions}) do
    %{data: render_many(sessions, Bzaar.SessionView, "login.json")}
  end

  def render("show.json", %{session: session}) do
    %{data: render_one(session, Bzaar.SessionView, "login.json")}
  end

  def render("login.json", %{session: session}) do
    %{
      user: session.user,
      jwt: session.jwt,
      exp: session.exp
    }
  end
end