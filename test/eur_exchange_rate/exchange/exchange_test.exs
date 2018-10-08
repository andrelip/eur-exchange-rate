defmodule EurExchangeRate.ExchangeTest do
  use EurExchangeRate.DataCase

  alias EurExchangeRate.Exchange

  describe "euro_ratings" do
    alias EurExchangeRate.Exchange.EuroRating

    @valid_attrs %{currency: "USD", date: ~D[2018-05-10], rate: "10.0"}
    @update_attrs %{currency: "some updated currency", date: ~D[2011-05-18], rate: "456.7"}
    @invalid_attrs %{currency: nil, date: nil, rate: nil}

    def euro_rating_fixture(attrs \\ %{}) do
      {:ok, euro_rating} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Exchange.create_euro_rating()

      euro_rating
    end

    test "list_euro_ratings/0 returns all euro_ratings" do
      euro_rating = euro_rating_fixture()
      assert Exchange.list_euro_ratings() == [euro_rating]
    end

    test "get_euro_ratings/1 returns the euro_rating with given id" do
      euro_rating = euro_rating_fixture()
      assert Exchange.get_euro_ratings(euro_rating.date) == [euro_rating]
    end

    test "create_euro_rating/1 with valid data creates a euro_rating" do
      assert {:ok, %EuroRating{} = euro_rating} = Exchange.create_euro_rating(@valid_attrs)
      assert euro_rating.currency == "USD"
      assert euro_rating.date == ~D[2018-05-10]
      assert euro_rating.rate == Decimal.new("10.0")
    end

    test "create_euro_rating/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Exchange.create_euro_rating(@invalid_attrs)
    end
  end
end
