class ProxyConfiguration < ApplicationRecord
  belongs_to :project, required: true

  # TODO: Clément Villain 16/02/18
  # validates url
  validates :target_base_url, presence: true

  validates :proxy_port, presence: true, if: -> { proxy_hostname.present? }
  validates :proxy_hostname, presence: true, if: -> { proxy_port.present? || proxy_username.present? }
  validates :proxy_password, presence: true, if: -> { proxy_username.present? }
  validates :proxy_username, presence: true, if: -> { proxy_password.present? }

  def use_http_proxy?
    proxy_hostname.present? && proxy_port.present?
  end

  def http_proxy_fields
    fields = [proxy_hostname, proxy_port]
    fields += [proxy_username, proxy_password] if proxy_username.present?
    fields
  end
end
