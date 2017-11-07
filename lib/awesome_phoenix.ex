defmodule AwesomePhoenix do
  @input "README.md"
  @output "docs/README.md"
  @regex ~r/https:\/\/github.com\/([a-zA-Z0-9\-\_\.]+)\/([a-zA-Z0-9\-\_\.]+)/

  alias AwesomePhoenix.Repo
  alias AwesomePhoenix.Template

  def main([]) do
    IO.puts "GitHub personal access token is missing."
  end

  def main(args) do
    token = Enum.at(args, 0)

    HTTPoison.start

    client = Tentacat.Client.new(%{access_token: token})

    {:ok, file} = File.open(@output, [:write])
    {:ok, data} = File.read(@input)

    try do
      data
      |> String.split("\n")
      |> Enum.filter(&String.starts_with?(&1, "*"))
      |> Enum.map(&Regex.run(@regex, &1))
      |> Enum.map(&Repo.parse(client, Enum.at(&1, 1), Enum.at(&1, 2)))
      |> Enum.sort_by(&Map.get(&1, :stargazers_count), &>=/2)
      |> Enum.each(&IO.binwrite(file, Template.render_repo(&1)))
    after
      File.close(file)
    end
  end
end
