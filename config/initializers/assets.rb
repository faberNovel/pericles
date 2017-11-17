# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
Rails.application.config.assets.precompile += %w( validate_instance.js )
Rails.application.config.assets.precompile += %w( generate_instance.js )
Rails.application.config.assets.precompile += %w( routes/show.js )
Rails.application.config.assets.precompile += %w( validations/new.js )
Rails.application.config.assets.precompile += %w( header_autocomplete.js )
Rails.application.config.assets.precompile += %w( generate_schema.js )
Rails.application.config.assets.precompile += %w( resources/show.js )
Rails.application.config.assets.precompile += %w( mock_profiles/form.js )
Rails.application.config.assets.precompile += %w( responses/form.js )
