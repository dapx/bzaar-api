defmodule Bzaar.DispatcherController do
  use Bzaar.Web, :controller

  alias Bzaar.Dispatcher

  def index(conn, _params) do
    dispatchers = Repo.all(Dispatcher)
    render(conn, "index.json", dispatchers: dispatchers)
  end

  def create(conn, %{"dispatcher" => dispatcher_params}) do
    changeset = Dispatcher.changeset(%Dispatcher{}, dispatcher_params)

    case Repo.insert(changeset) do
      {:ok, dispatcher} ->
        conn
        |> put_status(:created)
        #|> put_resp_header("location", dispatcher_path(conn, :show, dispatcher))
        |> render("show.json", dispatcher: dispatcher)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Bzaar.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    dispatcher = Repo.get!(Dispatcher, id)
    render(conn, "show.json", dispatcher: dispatcher)
  end

  def update(conn, %{"id" => id, "dispatcher" => dispatcher_params}) do
    dispatcher = Repo.get!(Dispatcher, id)
    changeset = Dispatcher.changeset(dispatcher, dispatcher_params)

    case Repo.update(changeset) do
      {:ok, dispatcher} ->
        render(conn, "show.json", dispatcher: dispatcher)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Bzaar.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    dispatcher = Repo.get!(Dispatcher, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(dispatcher)

    send_resp(conn, :no_content, "")
  end
end
