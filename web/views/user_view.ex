defmodule Bzaar.UserView do
  use Bzaar.Web, :view

  def render("index.json", %{users: users}) do
    %{data: render_many(users, Bzaar.UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, Bzaar.UserView, "user.json")}
  end

  def render("verified.json", %{user: user}) do
    %{active: user.active}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      name: user.name,
      surname: user.surname,
      email: user.email,
      active: user.active,
      image: user.image,
      password: user.password,
      shopkeeper: user.shopkeeper
    }
  end
end
