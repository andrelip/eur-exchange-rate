defmodule EurReferenceRateTest do
  use ExUnit.Case
  @currencies_length 32

  @tag external: true
  test "current/0" do
    list = EurReferenceRate.current()
    assert length(list) == @currencies_length
    first = list |> Enum.sort_by(& &1[:currency]) |> List.first()
    assert Map.keys(first) == [:currency, :rate, :reference_date]
    assert first[:currency] == "AUD"
  end

  @tag external: true
  test "current/1" do
    result = EurReferenceRate.current("USD")
    assert Decimal.cmp(result, 20) == :lt
    assert Decimal.cmp(result, Decimal.new("0.01")) == :gt
  end

  @tag external: true
  test "last90d/0" do
    list = EurReferenceRate.last90d()
    assert list |> List.first() == EurReferenceRate.current() |> List.first()
    assert length(list) > @currencies_length * 60
    assert length(list) < @currencies_length * 90
  end
end
