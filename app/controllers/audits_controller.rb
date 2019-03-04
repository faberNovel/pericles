class AuditsController < ApplicationController
  include Authenticated

  def index
    audits = Audited::Audit.where.not(auditable_type: ['Header', 'QueryParameter']).preload(:auditable, :associated).last(1000).reverse
    @audits = audits.map { |audit| map_audit(audit) }
  end

  private

  def map_audit(audit)
    case audit.auditable_type
    when 'Response'
      News::ResponseAuditDecorator.new(audit)
    when 'Route'
      News::RouteAuditDecorator.new(audit)
    when 'Header'
      News::HeaderAuditDecorator.new(audit)
    when 'Attribute'
      News::AttributeAuditDecorator.new(audit)
    when 'Resource'
      News::ResourceAuditDecorator.new(audit)
    when 'AttributesResourceRepresentation'
      News::AttributesResourceRepresentationAuditDecorator.new(audit)
    when 'ResourceRepresentation'
      News::ResourceRepresentationAuditDecorator.new(audit)
    else
      News::AuditDecorator.new(audit)
    end
  end
end
