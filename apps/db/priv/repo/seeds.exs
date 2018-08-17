repo = DB.primary()

if repo.aggregate("intervals", :count, :id) == 0 do
  repo.insert_all("intervals", [
    %{id: Ecto.UUID.bingenerate(), count: 1, unit: "week"},
    %{id: Ecto.UUID.bingenerate(), count: 2, unit: "week"},
    %{id: Ecto.UUID.bingenerate(), count: 1, unit: "month"},
    %{id: Ecto.UUID.bingenerate(), count: 2, unit: "month"},
    %{id: Ecto.UUID.bingenerate(), count: 3, unit: "month"},
    %{id: Ecto.UUID.bingenerate(), count: 6, unit: "month"},
    %{id: Ecto.UUID.bingenerate(), count: 1, unit: "year"}
  ])
end
