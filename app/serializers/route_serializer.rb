class RouteSerializer < ActiveModel::Serializer
  attributes(
    :id,
    :url,
    :http_method,
    :resource_id
  )
end
