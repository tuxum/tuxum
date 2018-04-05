defmodule APIWeb.ErrorHelpers do
  @moduledoc """
  Conveniences for translating and building error messages.
  """

  def translate_errors(:not_found), do: "Not Found"

  def translate_errors(:unauthorized), do: "Unauthorized"

  def translate_errors(changeset) do
    changeset
    |> Ecto.Changeset.traverse_errors(&translate_error/1)
    |> Enum.map(fn {key, message} ->
      %{
        message: message,
        attribute: key
      }
    end)
  end

  @doc """
  Translates an error message using gettext.
  """
  def translate_error({msg, opts}) do
    if count = opts[:count] do
      Gettext.dngettext(APIWeb.Gettext, "errors", msg, msg, count, opts)
    else
      Gettext.dgettext(APIWeb.Gettext, "errors", msg, opts)
    end
  end
end
