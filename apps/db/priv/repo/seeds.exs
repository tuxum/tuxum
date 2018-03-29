repo = DB.primary()

if repo.aggregate("delivery_intervals", :count, :id) == 0 do
  repo.insert_all("delivery_intervals", [
    %{id: 1, name: "weekly", interval_days: 7},
    %{id: 2, name: "bi-weekly", interval_days: 14},
    %{id: 3, name: "monthly", interval_days: 30},
    %{id: 4, name: "bi-monthly", interval_days: 60},
    %{id: 5, name: "every-three-months", interval_days: 90},
    %{id: 6, name: "bi-annualy", interval_days: 183},
    %{id: 7, name: "yearly", interval_days: 365}
  ])
end
