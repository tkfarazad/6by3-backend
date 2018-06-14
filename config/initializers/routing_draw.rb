# frozen_string_literal: true

# Adds draw method into Rails routing
# It allows us to keep routing splitted into files
module ActionDispatch::Routing
  class Mapper
    def draw(route_name)
      path = Rails.root.join('config', 'routes', "#{route_name}.rb")
      file = File.read(path)

      instance_eval(file)
    end
  end
end
