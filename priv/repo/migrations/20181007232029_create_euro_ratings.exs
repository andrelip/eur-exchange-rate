defmodule EurExchangeRate.Repo.Migrations.CreateEuroRatings do
  use Ecto.Migration

  def change do
    create table(:euro_ratings) do
      add(:currency, :string, null: false)
      add(:rate, :decimal, null: false)
      add(:date, :date, null: false)

      timestamps()
    end

    create(unique_index(:euro_ratings, [:currency, :date], name: :currency_date_uniq))
  end
end
