defmodule EurReferenceRate do
  @moduledoc """
  EurReferenceRate keeps the contexts that that are responsible
  to retrieve and persist Eur exchange rate.
  """

  require Logger
  import XmlNode, only: [attr: 2, all: 2, from_string: 1]

  @url "https://www.ecb.europa.eu/stats/eurofxref/eurofxref-hist-90d.xml"

  @doc """
  Get a up to date list of exchange rates
  iex> EurReferenceRate.current
  [
    %{currency: "USD", rate: #Decimal<1.1506>, reference_date: ~D[2018-10-05]},
    %{currency: "JPY", rate: #Decimal<131.03>, reference_date: ~D[2018-10-05]},
    %{currency: "BGN", ...},
    %{...},
    ...
  ]
  """
  def current do
    list = last90d()
    most_recent_date = list |> List.first() |> Map.get(:reference_date)
    list |> Enum.filter(&(&1[:reference_date] == most_recent_date))
  end

  @doc """
  Get the up to date exchange rate of a given currency

  iex> EurReferenceRate.current("USD")
  #Decimal<1.1696>

  Available options:
  ["USD", "JPY", "BGN", "CZK", "DKK", "GBP", "HUF", "PLN", "RON", "SEK", "CHF",
  "ISK", "NOK", "HRK", "RUB", "TRY", "AUD", "BRL", "CAD", "CNY", "HKD", "IDR",
  "ILS", "INR", "KRW", "MXN", "MYR", "NZD", "PHP", "SGD", "THB", "ZAR"]
  """
  def current(currency) do
    last90d()
    |> Enum.sort_by(& &1[:reference_date])
    |> Enum.find(&(&1[:currency] |> String.downcase() == currency |> String.downcase()))
    |> Map.get(:rate)
  end

  @doc """
  Requests European Central Bank and returns a list of ratings from the last 90 days.

  iex> EurReferenceRate.last90d
  [
    %{currency: "USD", rate: #Decimal<1.1506>, reference_date: ~D[2018-10-05]},
    %{currency: "JPY", rate: #Decimal<131.03>, reference_date: ~D[2018-10-05]},
    %{currency: "BGN", ...},
    %{...},
    ...
  ]
  """
  def last90d do
    Logger.debug(fn ->
      "EurReferenceRate downloading new data from #{@url}"
    end)

    with {:ok, 200, _headers, client_ref} <- :hackney.get(@url, [], "", follow_redirect: true),
         {:ok, body} <- :hackney.body(client_ref),
         {:ok, parsed_text} <- parse_xml(body) do
      Logger.debug(fn -> "EurReferenceRate data downloaded" end)
      parsed_text
    else
      {:ok, code, _, _} -> {:error, "Error requesting the rate. Response with code #{code}"}
      err -> err
    end
  end

  defp parse_xml(raw_data) do
    parsed_data = parse_xml!(raw_data)
    {:ok, parsed_data}
  rescue
    _ ->
      Logger.debug(fn ->
        "EurReferenceRate couldn't parse xml:\n #{raw_data}"
      end)

      {:error, "couldn't parse text"}
  end

  defp parse_xml!(data) do
    data
    |> from_string()
    |> all("//gesmes:Envelope/Cube/*")
    |> Enum.map(&parse_month/1)
    |> List.flatten()
  end

  defp parse_month(month) do
    reference_date = month |> attr("time") |> Date.from_iso8601!()

    month
    |> all("//Cube/*")
    |> Enum.map(&format_rate_node(&1, reference_date))
  end

  defp format_rate_node(node, reference_date) do
    %{
      reference_date: reference_date,
      currency: node |> attr("currency"),
      rate: node |> attr("rate") |> Decimal.new()
    }
  end
end
