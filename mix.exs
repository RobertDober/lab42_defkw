defmodule Kwfuns.Mixfile do
  use Mix.Project

  def project do
    [app: :kwfuns,
     version: "0.0.1",
     elixir: "~> 1.1",
     description: description,
     package: package,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
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
    []
  end

  def description do
    """
    Macros to create functions with syntax based keyword parameters with default values
    E.g.
    defkw make_liste_elem( parent, text, spaced: false, type: :ul ) do ...
    """
  end

  def package do
    [
     maintainers: ["Robert Dober, robert.dober@gmail.com"],
     licenses: ["Apache 2.0"],
     links: %{github: "https://github.com/RobertDober/lab42_defkw"}
     ]
end

