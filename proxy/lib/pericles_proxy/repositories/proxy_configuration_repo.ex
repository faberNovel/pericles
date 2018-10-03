defmodule PericlesProxy.ProxyConfigurationRepo do
  alias PericlesProxy.{Repo, ProxyConfiguration}

  @spec for_project(Integer.t) :: ProxyConfiguration.t
  def for_project(project_id) do
    Repo.get_by(ProxyConfiguration, project_id: project_id)
  end
end


