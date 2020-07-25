Rails.application.routes.draw do
  mount EventService::Engine => "/event_service"
end
