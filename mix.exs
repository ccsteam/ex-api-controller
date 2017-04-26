defmodule ApiController.Mixfile do
  use Mix.Project

  def project do
    [app: :api_controller,
     version: "0.2.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     aliases: aliases(),
     description: description(),
     package: package()]
  end

  def application do
    [applications: [:phoenix]]
  end

  defp deps do
    [{:ex_doc, ">= 0.0.0", only: :dev},
     {:phoenix, "~> 1.2.0"}]
  end

  defp aliases do
    ["test": ["test --no-start"]]
  end

  defp description do
    "Base API Controller for Phoenix"
  end

  defp package do
    [name: :api_controller,
     files: ["lib", "mix.exs"],
     maintainers: ["Andrey Noskov"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/ccsteam/ex-api-controller"}]
  end
end
