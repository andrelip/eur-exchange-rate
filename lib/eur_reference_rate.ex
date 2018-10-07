defmodule E do
  @moduledoc """
  EurReferenceRate keeps the contexts that that are responsible
  to retrieve and persist Eur exchange rate.
  """

  require Logger
  import XmlNode, only: [attr: 2, all: 2, from_string: 1]

  @url "https://www.ecb.europa.eu/stats/eurofxref/eurofxref-hist-90d.xml"

  def get_rate do
    Logger.debug("EurReferenceRate downloading new data from #{@url}")

    with {:ok, 200, _headers, client_ref} <- :hackney.get(@url, [], "", follow_redirect: true),
         {:ok, body} <- :hackney.body(client_ref),
         {:ok, parsed_text} <- parse_xml(body) do
      Logger.debug("EurReferenceRate data downloaded.")
      parsed_text
    else
      {:ok, code, _, _} -> {:error, "Error requesting the rate. Response with code #{code}"}
      err -> err
    end
  end

  defp parse_xml(raw_data) do
    try do
      parsed_data = parse_xml!(raw_data)
      {:ok, parsed_data}
    rescue
      _ ->
        Logger.debug("EurReferenceRate couldn't parse xml:\n #{raw_data}")
        {:error, "couldn't parse text"}
    end
  end

  defp parse_xml!(data) do
    data
    |> from_string()
    |> all("//gesmes:Envelope/Cube/*")
    |> Enum.map(&parse_month/1)
    |> List.flatten()
  end

  defp parse_month(month) do
    reference_date = attr(month, "time") |> Date.from_iso8601!()

    month
    |> all("//Cube/*")
    |> Enum.map(&format_rate_node(&1, reference_date))
  end

  defp format_rate_node(node, reference_date) do
    %{
      reference_date: reference_date,
      currency: attr(node, "currency"),
      rate: attr(node, "rate") |> Decimal.new()
    }
  end
end
