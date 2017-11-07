class Response < ApplicationRecord
end

class AddRootKeyToResponses < ActiveRecord::Migration[5.0]
  def change
    add_column :responses, :root_key, :string

    Response.find_each do |r|
      begin
        r.root_key = ActiveSupport::JSON.decode(r.body_schema).fetch('required', nil)&.first
      rescue JSON::ParserError
        r.root_key = ''
      end
      r.save
    end
  end
end
