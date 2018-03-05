defmodule Bzaar.Factory do
  # with Ecto
  use ExMachina.Ecto, repo: Bzaar.Repo

  def user_factory do
    %Bzaar.User{
      name: "foo",
      surname: "baar" ,
      email: "foo@bar.com",
      password: "foobar",
      email: sequence(:email, &"email-#{&1}@example.com")
    }
  end

  def store_factory do
    %Bzaar.Store{
      active: true,
      description: "some content",
      email: "some content",
      logo: "some content",
      name: "some content"
    }
  end

end