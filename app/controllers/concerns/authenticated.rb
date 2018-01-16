module Authenticated
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!

    rescue_from Pundit::NotAuthorizedError do
      render file: 'public/403.html', status: :forbidden, layout: false
    end
  end
end