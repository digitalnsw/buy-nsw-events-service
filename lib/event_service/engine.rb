module EventService
  class Engine < ::Rails::Engine
    isolate_namespace EventService
    config.generators.api_only = true
  end
end
