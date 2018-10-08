defmodule EurExchangeRateWeb.Router do
  use EurExchangeRateWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", EurExchangeRateWeb do
    # Use the default browser stack
    pipe_through(:browser)

    get("/rates/latest", EuroRatingController, :latest)
    get("/rates/analyze", EuroRatingController, :analyze_ratings_from_last90d)
    get("/rates/:date", EuroRatingController, :show)
  end

  # Other scopes may use custom stacks.
  # scope "/api", EurExchangeRateWeb do
  #   pipe_through :api
  # end
end
