defmodule EurExchangeRateWeb.EuroRatingView do
  use EurExchangeRateWeb, :view
  alias EurExchangeRateWeb.EuroRatingView

  def render("show_daily_ratings.json", %{euro_ratings: euro_ratings}) do
    %{base: "EUR", rates: Enum.into(euro_ratings, %{}, &{&1.currency, &1.rate})}
  end

  def render("analyze_ratings_from_last90d.json", %{analyzed_currencies: analyzed_currencies}) do
    %{base: "EUR", rates_analyze: analyzed_currencies}
  end
end
