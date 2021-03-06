defmodule Tooling.Mixfile do
  use Mix.Project

  def project do
    [app: :tooling,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      # 2 needed for producing html documentation from your elixir source code...
      { :ex_doc, "~> 0.12" },
      { :earmark, "~> 1.0", override: true },
      # 2 needed for ExCheck property based function testing...
      { :triq, github: "triqng/triq", only: :test},
      { :excheck,  "~> 0.4.0", only: :test },
    ]
  end
end
