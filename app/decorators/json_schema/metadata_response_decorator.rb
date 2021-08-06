module JSONSchema
  class MetadataResponseDecorator < Draper::Decorator
    delegate_all
    decorates_association :metadatum, with: JSONSchema::MetadatumDecorator
  end
end
