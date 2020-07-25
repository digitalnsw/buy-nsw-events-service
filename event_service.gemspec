$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "event_service/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "event_service"
  s.version     = EventService::VERSION
  s.authors     = ["Arman"]
  s.email       = ["arman.sarrafi@customerservice.nsw.gov.au"]
  s.homepage    = ""
  s.summary     = "Summary of EventService."
  s.description = "Description of EventService."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
end
