ExUnit.start()

Ecto.Adapters.SQL.Sandbox.mode(EurExchangeRate.Repo, :manual)
ExUnit.configure(exclude: [external: true])
