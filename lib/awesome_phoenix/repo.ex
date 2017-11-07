defmodule AwesomePhoenix.Repo do
  @enforce_keys [:owner, :name]
  defstruct [:owner, :name, :description, :created_at, :homepage, :html_url, topics: [],
             stargazers_count: 0, watchers_count: 0, forks_count: 0]

  def parse(client, owner, name) do
    case Tentacat.Repositories.repo_get(owner, name, client) do
      {403, _} -> nil
      data -> new(data)
    end
  end

  def new(data) do
    %__MODULE__{
      owner: get_in(data, ["owner", "login"]),
      name: Map.get(data, "name"),
      description: Map.get(data, "description"),
      created_at: Map.get(data, "created_at"),
      homepage: Map.get(data, "homepage"),
      html_url: Map.get(data, "html_url"),
      topics: Map.get(data, "topics"),
      stargazers_count: Map.get(data, "stargazers_count"),
      watchers_count: Map.get(data, "subscribers_count"),
      forks_count: Map.get(data, "forks_count"),
    }
  end
end
