defmodule EurExchangeRate.Exchange do
  @moduledoc """
  Have functions to handle the persistence layer for the ratings
  """

  import Ecto.Query, warn: false
  alias EurExchangeRate.Repo
  alias EurExchangeRate.Exchange.EuroRating

  @doc """
  Fetches the last 90 days ratings using `EurReferenceRate` and persists that to the database.
  """
  def fetch_ratings do
    recente_ratings = EurReferenceRate.last90d()

    recent_dates =
      recente_ratings
      |> Enum.map(& &1[:reference_date])
      |> Enum.uniq()

    existing_dates =
      EuroRating
      |> where([rating], rating.date in ^recent_dates)
      |> select([rating], rating.date)
      |> Repo.all()

    new_dates = recent_dates -- existing_dates

    recente_ratings
    |> Enum.filter(&Enum.member?(new_dates, &1[:reference_date]))
    |> Enum.each(fn rating ->
      rating
      |> Map.put_new(:date, rating.reference_date)
      |> create_euro_rating()
    end)
  end

  @doc """
  Get a list of all the latest ratings sorted in ascending order

  iex> EurExchangeRate.Exchange.latest_ratings
  [
    %EurExchangeRate.Exchange.EuroRating{
      __meta__: #Ecto.Schema.Metadata<:loaded, "euro_ratings">,
      currency: "USD",
      date: ~D[2018-10-05],
      id: 1,
      inserted_at: ~N[2018-10-07 23:42:48.468212],
      rate: #Decimal<1.1506>,
      updated_at: ~N[2018-10-07 23:42:48.468224]
    },
    %EurExchangeRate.Exchange.EuroRating{...},
    ...
  ]
  """
  def latest_ratings do
    latest_date =
      EuroRating
      |> order_by([rating], desc: rating.date)
      |> limit(1)
      |> select([rating], rating.date)
      |> Repo.one()

    EuroRating
    |> where([rating], rating.date == ^latest_date)
    |> Repo.all()
    |> Enum.sort_by(& &1.rate)
  end

  @doc """
  Returns the complete list of euro_ratings.

  ## Examples

      iex> list_euro_ratings()
      [%EuroRating{}, ...]

  """
  def list_euro_ratings do
    Repo.all(EuroRating)
  end

  @doc """
  Gets all the ratings for a given date sorted in ascending order.
  The date format should be "YYYY-MM-DD"

  ## Examples

      iex> get_euro_rating("2018-10-05")
      [
        %EurExchangeRate.Exchange.EuroRating{
          __meta__: #Ecto.Schema.Metadata<:loaded, "euro_ratings">,
          currency: "USD",
          date: ~D[2018-10-05],
          id: 1,
          inserted_at: ~N[2018-10-07 23:42:48.468212],
          rate: #Decimal<1.1506>,
          updated_at: ~N[2018-10-07 23:42:48.468224]
        },
        %EurExchangeRate.Exchange.EuroRating{...},
        ...
      ]

  """
  def get_euro_ratings(date) do
    EuroRating
    |> where([rating], rating.date == ^date)
    |> Repo.all()
    |> Enum.sort_by(& &1.rate)
  end

  def analyze_last_90d_ratings() do
    data = EurReferenceRate.last90d()

    data
    |> Enum.group_by(fn x -> x.currency end)
    |> Map.to_list()
    |> Enum.into(%{}, &analyze_currency_ratings/1)
  end

  defp analyze_currency_ratings({currency, currency_ratings}) do
    {min, max} = Enum.min_max_by(currency_ratings, & &1.rate)

    avg =
      currency_ratings
      |> Enum.reduce(0, fn rating, acc -> Decimal.add(rating.rate, acc) end)
      |> Decimal.div(length(currency_ratings))

    output = %{min: min.rate, max: max.rate, avg: avg}

    {currency, output}
  end

  @doc """
  Creates a euro_rating.

  ## Examples

      iex> create_euro_rating(%{field: value})
      {:ok, %EuroRating{}}

      iex> create_euro_rating(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_euro_rating(attrs \\ %{}) do
    %EuroRating{}
    |> EuroRating.changeset(attrs)
    |> Repo.insert()
  end
end
