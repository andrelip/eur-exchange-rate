# EurExchangeRate
[![CircleCI](https://circleci.com/gh/andrelip/eur-exchange-rate.svg?style=svg)](https://circleci.com/gh/andrelip/eur-exchange-rate)

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Setup `Postgresql` and set the environment variables `PG_USER_NAME` and `PG_USER_PASSWORD`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Start Phoenix endpoint with `mix phx.server`
  * To update the ratings run `mix fetch_ratings` in your favorite cron-like runner

## Endpoints

Now you can visit from your browser:

  * [`localhost:4000/rates/latest`](http://localhost:4000/rates/latest)

    List the latest ratings
    ```
    {
      "rates": {
      "ZAR": "16.9754",
      "USD": "1.1506",
      "TRY": "7.0963",
      ...
    }
    ```
  * [`localhost:4000/rates/YYYY-MM-DD`](http://localhost:4000/rates/2018-10-05)

    List the ratings for a given date
    ```
    {
      "rates": {
      "ZAR": "16.9754",
      "USD": "1.1506",
      "TRY": "7.0963",
      ...
    }
    ```

  * [`localhost:4000/rates/analyze`](http://localhost:4000/rates/analyze)
    
    Analyze the currencies for a time span of 90 days
    ```
    {
      "rates_analyze": {
      "ZAR": {
      "min": "17.01",
      "max": "17.9906",
      "avg": "16.41912615384615384615384615"
      },
      "USD": {
      "min": "1.137",
      "max": "1.1789",
      "avg": "1.161864615384615384615384615"
      },
      ...
    }
    ```
