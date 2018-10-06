defmodule EurReferenceRate do
  @moduledoc """
  EurReferenceRate keeps the contexts that that are responsible
  to retrieve and persist Eur exchange rate.
  """

  require Logger

  @url "https://www.ecb.europa.eu/stats/eurofxref/eurofxref-hist-90d.xml"

  def download_data do
    Logger.debug("EurReferenceRate downloading new data from #{@url}")
    {:ok, 200, _headers, client_ref} = :hackney.get(@url, [], "", follow_redirect: true)
    {:ok, body} = :hackney.body(client_ref)
    Logger.debug("EurReferenceRate data downloaded.")
    body
  end

  def parse_data do
  end
end
