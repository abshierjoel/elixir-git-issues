defmodule Issues.CLI do
  @default_count 4

  @moduledoc """
  Handle the command line parsing and the dispatch to
  the various funcitons that end up genereating a
  table of the last _n_ issues in a github project
  """

  def run(argv) do
    argv
    |> parse_args
    |> process
  end

  @doc """
  `argv` can be -h or --help, which returns :help.

  Otherwise it is a github user name, project name, and (optionally)
  the number of entries to format.any()
  Return a tuple of `{ user, project, count }`, or `:help` if help was given
  """

  def parse_args(argv) do
    OptionParser.parse(argv, switches: [help: :boolean], aliases: [h: :help])
    |> elem(1)
    |> args_to_interal_representation()
  end

  defp args_to_interal_representation([user, project, count]),
    do: {user, project, String.to_integer(count)}

  defp args_to_interal_representation([user, project]),
    do: {user, project, @default_count}

  defp args_to_interal_representation(_),
    do: :help

  defp process(:help) do
    IO.puts("""
    usage: issues <user> <project> [ count | #{@default_count} ]
    """)

    System.halt(0)
  end

  defp process({user, project, _count}) do
    Issues.GithubIssues.fetch(user, project)
  end
end
