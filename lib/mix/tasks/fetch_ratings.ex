defmodule Mix.Tasks.FetchRatings do
  @moduledoc false
  use Mix.Task
  alias EurExchangeRate.Exchange

  @shortdoc "Simply runs the EurExchangeRate.Exchange.fetch_ratings/0 function"
  def run(_) do
    Mix.Task.run("app.start")
    Exchange.fetch_ratings()
  end
end
