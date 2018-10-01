class CreateRestRoutesTransaction
  include Dry::Transaction

  check :resource_has_no_routes
  tee :create_index, catch: ActiveRecord::ActiveRecordError
  tee :create_create, catch: ActiveRecord::ActiveRecordError
  tee :create_show, catch: ActiveRecord::ActiveRecordError
  tee :create_update, catch: ActiveRecord::ActiveRecordError
  tee :create_delete, catch: ActiveRecord::ActiveRecordError


  def resource_has_no_routes(input)
    input[:resource].routes.empty?
  end

  def create_index(input)
    route = Route.create!(index_hash(input))
    route.responses.create!(
      default_response_hash(input).merge(is_collection: true, root_key: root_key_from_url(input).pluralize)
    )
  end

  def create_create(input)
    route = Route.create!(create_hash(input))
    route.responses.create!(
      default_response_hash(input).merge(status_code: 201)
    )
  end

  def create_show(input)
    route = Route.create!(show_hash(input))
    route.responses.create!(
      default_response_hash(input)
    )
  end

  def create_update(input)
    route = Route.create!(update_hash(input))
    route.responses.create!(
      default_response_hash(input)
    )
  end

  def create_delete(input)
    route = Route.create!(delete_hash(input))
    route.responses.create!(
      default_response_hash(input).merge(status_code: 204, resource_representation_id: nil)
    )
  end

  private

  def default_response_hash(input)
    {
      status_code: 200,
      is_collection: false,
      root_key: root_key_from_url(input),
      resource_representation_id: input[:response_resource_representation].id
    }
  end

  def collection_url(input)
    input[:url].pluralize
  end
  def resource_url(input)
    input[:url].pluralize + '/:id'
  end

  def root_key_from_url(input)
    url = input[:url]
    url.split('/').last.singularize
  end

  def index_hash(input)
    {
      http_method: :GET,
      url: collection_url(input),
      resource_id: input[:resource].id,
      request_resource_representation_id: nil,
      request_is_collection: false,
      request_root_key: nil,
    }
  end

  def create_hash(input)
    {
      http_method: :POST,
      url: collection_url(input),
      resource_id: input[:resource].id,
      request_resource_representation_id: input[:request_resource_representation].id,
      request_is_collection: false,
      request_root_key: root_key_from_url(input),
    }
  end

  def show_hash(input)
    {
      http_method: :GET,
      url: resource_url(input),
      resource_id: input[:resource].id,
      request_resource_representation_id: nil,
      request_is_collection: false,
      request_root_key: nil,
    }
  end

  def update_hash(input)
    {
      http_method: :PUT,
      url: resource_url(input),
      resource_id: input[:resource].id,
      request_resource_representation_id: input[:request_resource_representation].id,
      request_is_collection: false,
      request_root_key: root_key_from_url(input),
    }
  end

  def delete_hash(input)
    {
      http_method: :DELETE,
      url: resource_url(input),
      resource_id: input[:resource].id,
      request_resource_representation_id: nil,
      request_is_collection: false,
      request_root_key: nil,
    }
  end
end
