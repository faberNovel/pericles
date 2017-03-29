# When upgrading to ams ~> 0.9 this is required to have root and meta keys in the json responses - see ams documentation on meta
ActiveModel::Serializer.config.adapter = :json