defmodule EurExchangeRateWeb.EuroRatingController do
  use EurExchangeRateWeb, :controller

  alias EurExchangeRate.Exchange

  action_fallback(EurExchangeRateWeb.FallbackController)

  def latest(conn, _params) do
    euro_ratings = Exchange.latest_ratings()
    render(conn, "show_daily_ratings.json", euro_ratings: euro_ratings)
  end

  def analyze_ratings_from_last90d(conn, _params) do
    analyzed_currencies = Exchange.analyze_last_90d_ratings()
    render(conn, "analyze_ratings_from_last90d.json", analyzed_currencies: analyzed_currencies)
  end

  def show(conn, %{"date" => date}) do
    euro_ratings = Exchange.get_euro_ratings(date)
    render(conn, "show_daily_ratings.json", euro_ratings: euro_ratings)
  end
end
