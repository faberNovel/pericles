class AuditsRepository
  def news_of_project(project)
    Audited::Audit
      .of_project(project)
      .where.not(auditable_type: ['Header', 'QueryParameter'])
      .preload(:auditable, :associated)
      .order(created_at: :desc)
  end
end
