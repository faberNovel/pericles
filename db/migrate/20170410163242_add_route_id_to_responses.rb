class AddRouteIdToResponses < ActiveRecord::Migration[5.0]
  def change
    add_reference :responses, :route, foreign_key: true
  end
end
