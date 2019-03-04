class AuditsController < ApplicationController
  include Authenticated

  def index
    audits = Audited::Audit.last(100).reverse
    @audits = audits.map { |audit| map_audit(audit) }
  end

  private

  def map_audit(audit)
    case audit.auditable_type
    when 'Response'
      News::ResponseAuditDecorator.new(audit).to_s
    when 'Route'
      News::RouteAuditDecorator.new(audit).to_s
    when 'Header'
      News::HeaderAuditDecorator.new(audit).to_s
    when 'Attribute'
      News::AttributeAuditDecorator.new(audit).to_s
    when 'Resource'
      News::ResourceAuditDecorator.new(audit).to_s
    when 'AttributesResourceRepresentation'
      News::AttributesResourceRepresentationAuditDecorator.new(audit).to_s
    when 'ResourceRepresentation'
      News::ResourceRepresentationAuditDecorator.new(audit).to_s
    else
      News::AuditDecorator.new(audit).to_s
    end
  end
end
