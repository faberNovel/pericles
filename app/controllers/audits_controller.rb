class AuditsController < ApplicationController
  include Authenticated
  include ProjectRelated

  def index
    @audits = Audited::Audit
               .of_project(project)
               .where.not(auditable_type: ['Header', 'QueryParameter'])
               .preload(:auditable, :associated)
               .page(params[:page]).per(200)
               .order(created_at: :desc)
  end
end
