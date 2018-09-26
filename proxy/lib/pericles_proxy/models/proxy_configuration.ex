defmodule PericlesProxy.ProxyConfiguration do
  use Ecto.Schema

  schema "proxy_configurations" do
    field(:project_id, :integer)
    field(:target_base_url, :string)
    field(:proxy_hostname, :string)
    field(:proxy_port, :integer)
    field(:proxy_username, :string)
    field(:proxy_password, :string)
    field(:ignore_ssl, :boolean)
  end
end
