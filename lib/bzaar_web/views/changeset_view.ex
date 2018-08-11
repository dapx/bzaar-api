defmodule BzaarWeb.ChangesetView do
  use Bzaar.Web, :view

  @doc """
  Traverses and translates changeset errors.

  See `Ecto.Changeset.traverse_errors/2` and
  `Bzaar.ErrorHelpers.translate_error/1` for more details.
  """
  def translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, &translate_error/1)
  end

  def render("error.json", %{changeset: changeset}) do
    # When encoded, the changeset returns its errors
    # as a JSON object. So we just pass it forward.

    errors = error_string_from_changeset(changeset)
    %{error: errors}
  end

  defp error_string_from_changeset(changeset) do
    changeset.errors
    |> Enum.map(fn {k, v} ->
       "#{Phoenix.Naming.humanize(k)} #{translate_error(v)}"
    end)
    |> Enum.join(". ")
  end
end
