defmodule EurExchangeRate.Exchange.EuroRating do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  schema "euro_ratings" do
    field(:currency, :string)
    field(:date, :date)
    field(:rate, :decimal)

    timestamps()
  end

  @doc false
  def changeset(euro_rating, attrs) do
    euro_rating
    |> cast(attrs, [:currency, :rate, :date])
    |> validate_required([:currency, :rate, :date])
    |> unique_constraint(:currency, name: :currency_date_uniq)
  end
end
