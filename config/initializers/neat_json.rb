module JSON
  def self.stable_pretty_generate(json)
    JSON.neat_generate(json,
      sort: true,
      wrap: true,
      after_colon: 1
    )
  end
end