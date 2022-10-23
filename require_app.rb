# frozen_string_literal: true

# Requires all ruby files in specified app folders
def require_app
  Dir.glob('./lib/**/*.rb').each do |file|
    require file
  end
end
