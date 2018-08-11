defmodule Bzaar.User do
  use Bzaar.Web, :model
  alias Bzaar.{Repo, User, Store, ItemCart, UserAddress, CreditCard}

  @default_image "https://image.freepik.com/icones-gratis/perfil-macho-utilizador-sombra_318-40244.jpg"

  import Ecto.Query
  #https://github.com/elixir-ecto/ecto/issues/840
  @derive {Poison.Encoder, only: [:id, :name, :surname, :email, :active, :shopkeeper, :address]}
  schema "users" do
    field :name, :string
    field :surname, :string
    field :email, :string
    field :active, :boolean, default: false
    field :image, :string, default: @default_image
    field :password, :string, virtual: true
    field :password_hash, :string
    field :facebook_id, :string
    field :shopkeeper, :boolean, default: false
    has_many :stores, Store
    has_many :item_cart, ItemCart
    has_many :address, UserAddress, on_delete: :delete_all, on_replace: :delete
    has_one :credit_card, CreditCard

    timestamps(type: :utc_datetime)
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :surname, :active, :image, :facebook_id, :shopkeeper])
    |> cast_assoc(:address, required: false)
    |> validate_required([:name, :surname, :active])
    |> unique_constraint(:email)
  end

  def registration_changeset(struct, params \\ %{}) do
    struct
    |> changeset(params)
    |> cast(params, ~w(password email), [])
    |> downcase_email
    |> validate_required([:password, :email])
    |> validate_length(:password, min: 6)
    |> put_password_hash()
  end

  def downcase_email(changeset) do
    update_change(changeset, :email, &String.downcase/1)
  end

  def facebook_changeset(struct, params \\ %{}) do
    struct
    |> changeset(params)
    |> cast(params, ~w(facebook_id password email), [])
    |> unique_constraint(:facebook_id)
    |> put_password_hash()
    |> validate_required([:facebook_id, :password_hash, :email])
  end

  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))
      _ -> changeset
    end
  end

  def mark_as_verified(user) do
    change(user, %{active: true})
  end

  def find_and_confirm_password(email, password) do
    user = User
    |> from()
    |> preload([:address])
    |> Repo.get_by(email: String.downcase(email))
    cond do
      is_nil(user) -> {:error, "Invalid e-mail!"}
      !Comeonin.Bcrypt.checkpw(password, user.password_hash) -> {:error, "Invalid password"}
      true -> {:ok, user}
    end
  end

  defp generate_random_password do
    32
    |> :crypto.strong_rand_bytes()
    |> Base.encode64()
    |> binary_part(0, 32)
  end

  defp generate_facebook_user(user) do
    %{
      facebook_id: user["id"],
      name: user["first_name"],
      surname: user["last_name"],
      email: user["email"],
      active: user["verified"],
      password: generate_random_password()
    }
  end

  def find_or_register_facebook_user(facebook_user) do
    %{"id" => user_id} = facebook_user
    user_by_facebook = User
    |> from()
    |> preload([:address])
    |> Repo.get_by(facebook_id: user_id)
    case user_by_facebook do
      nil ->
        params = facebook_user
        |> generate_facebook_user()
        |> insert_preload_address()
      user ->
        user
        |> Repo.preload(:address)
        {:ok, user}
    end
  end

  defp insert_preload_address(params) do
    user = %User{}
      |> User.facebook_changeset(params)
      |> Repo.insert!()
      |> Repo.preload(:address)
    {:ok, user}
  end
end
