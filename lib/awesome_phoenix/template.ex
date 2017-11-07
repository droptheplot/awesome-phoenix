defmodule AwesomePhoenix.Template do
  alias AwesomePhoenix.Repo

  def render_repo(%Repo{} = repo) do
    """
    ## [#{repo.owner}/#{repo.name}](#{repo.html_url})
    #{render_homepage(repo)}
    #{repo.description}

    #{render_stargazers(repo)} #{render_watchers(repo)} #{render_forks(repo)} #{render_date(repo)}

    """
  end

  def render_homepage(%Repo{homepage: nil}), do: ""
  def render_homepage(%Repo{homepage: ""}), do: ""
  def render_homepage(%Repo{} = repo) do
    "\n[#{repo.homepage}](#{repo.homepage})\n"
  end

  defp render_stargazers(%Repo{} = repo) do
    "&#11088; #{repo.stargazers_count}"
  end

  defp render_watchers(%Repo{} = repo) do
    "&#128065; #{repo.watchers_count}"
  end

  defp render_forks(%Repo{} = repo) do
    "&#127860; #{repo.forks_count}"
  end

  defp render_date(%Repo{} = repo) do
    {:ok, dt, 0} = DateTime.from_iso8601(repo.created_at)

    "&#128336; #{dt.day}-#{dt.month}-#{dt.year}"
  end
end
