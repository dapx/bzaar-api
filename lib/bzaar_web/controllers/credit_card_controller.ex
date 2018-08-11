defmodule BzaarWeb.CreditCardController do
  use Bzaar.Web, :controller

  alias Bzaar.CreditCard

  def index(conn, _params) do
    credit_cards = Repo.all(CreditCard)
    render(conn, "index.json", credit_cards: credit_cards)
  end

  def create(conn, %{"credit_card" => credit_card_params}) do
    changeset = CreditCard.changeset(%CreditCard{}, credit_card_params)

    case Repo.insert(changeset) do
      {:ok, credit_card} ->
        conn
        |> put_status(:created)
        #|> put_resp_header("location", credit_card_path(conn, :show, credit_card))
        |> render("show.json", credit_card: credit_card)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(BzaarWeb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    credit_card = Repo.get!(CreditCard, id)
    render(conn, "show.json", credit_card: credit_card)
  end

  def update(conn, %{"id" => id, "credit_card" => credit_card_params}) do
    credit_card = Repo.get!(CreditCard, id)
    changeset = CreditCard.changeset(credit_card, credit_card_params)

    case Repo.update(changeset) do
      {:ok, credit_card} ->
        render(conn, "show.json", credit_card: credit_card)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(BzaarWeb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    credit_card = Repo.get!(CreditCard, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(credit_card)

    send_resp(conn, :no_content, "")
  end
end
