repo = DB.primary()

if repo.aggregate("delivery_intervals", :count, :id) == 0 do
  repo.insert_all("delivery_intervals", [
    %{id: Ecto.UUID.bingenerate(), name: "weekly", interval_days: 7},
    %{id: Ecto.UUID.bingenerate(), name: "bi-weekly", interval_days: 14},
    %{id: Ecto.UUID.bingenerate(), name: "monthly", interval_days: 30},
    %{id: Ecto.UUID.bingenerate(), name: "bi-monthly", interval_days: 60},
    %{id: Ecto.UUID.bingenerate(), name: "every-three-months", interval_days: 90},
    %{id: Ecto.UUID.bingenerate(), name: "bi-annualy", interval_days: 183},
    %{id: Ecto.UUID.bingenerate(), name: "yearly", interval_days: 365}
  ])
end
