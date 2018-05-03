defmodule Bzaar.User do
  use Bzaar.Web, :model
  alias Bzaar.{Repo, User}

  #https://github.com/elixir-ecto/ecto/issues/840
  @derive {Poison.Encoder, only: [:id, :name, :surname, :email, :active, :shopkeeper]}

  schema "users" do
    field :name, :string
    field :surname, :string
    field :email, :string
    field :active, :boolean, default: false
    field :image, :string, default: "https://image.freepik.com/icones-gratis/perfil-macho-utilizador-sombra_318-40244.jpg"
    field :password, :string, virtual: true
    field :password_hash, :string
    field :facebook_id, :string
    field :shopkeeper, :boolean, default: false
    has_many :stores, Bzaar.Store
    has_many :item_cart, Bzaar.ItemCart
    has_one :credit_card, Bzaar.CreditCard

    timestamps(type: :utc_datetime)
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :surname, :email, :active, :image, :password, :facebook_id, :shopkeeper])
    |> validate_required([:name, :surname, :email, :active, :password])
    |> unique_constraint(:email)
  end

  def registration_changeset(struct, params \\ %{}) do
    struct
    |> changeset(params)
    |> downcase_email
    |> cast(params, ~w(password), [])
    |> validate_length(:password, min: 6)
    |> put_password_hash()
  end

  def downcase_email(changeset) do
    update_change(changeset, :email, &String.downcase/1)
  end

  def facebook_changeset(struct, params \\ %{}) do
    struct
    |> changeset(params)
    |> cast(params, ~w(facebook_id), [])
    |> unique_constraint(:facebook_id)
    |> put_password_hash()
  end

  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))
      _ -> changeset
    end
  end

  def find_and_confirm_password(email, password) do
    user = Repo.get_by(User, email: String.downcase(email))
    cond do
      is_nil(user) -> {:error, "Invalid e-mail!"}
      !Comeonin.Bcrypt.checkpw(password, user.password_hash) -> {:error, "Invalid password"}
      true -> {:ok, user}
    end
  end

  def find_user_by_facebook_user_id(user_id) do
    user = Repo.get_by(User, facebook_id: user_id)
    cond do
      is_nil(user) -> {:error, "User id not found!"}
      true -> {:ok, user}
    end
  end
end
