defmodule AuthWeb.TokenView do
  use AuthWeb, :view
  alias AuthWeb.TokenView

  def render("show.json", %{token: token}) do
    %{token: token}
  end
end
