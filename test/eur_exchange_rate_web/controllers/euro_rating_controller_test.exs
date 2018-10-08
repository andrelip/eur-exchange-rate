defmodule EurExchangeRateWeb.EuroRatingControllerTest do
  use EurExchangeRateWeb.ConnCase

  alias EurExchangeRate.Exchange
  alias EurExchangeRate.Exchange.EuroRating

  @create_attrs %{currency: "some currency", date: ~D[2010-04-17], rate: "120.5"}
  @update_attrs %{currency: "some updated currency", date: ~D[2011-05-18], rate: "456.7"}
  @invalid_attrs %{currency: nil, date: nil, rate: nil}

  def fixture(:euro_rating) do
    {:ok, euro_rating} = Exchange.create_euro_rating(@create_attrs)
    euro_rating
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  defp create_euro_rating(_) do
    euro_rating = fixture(:euro_rating)
    {:ok, euro_rating: euro_rating}
  end
end
