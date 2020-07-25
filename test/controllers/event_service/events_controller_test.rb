require 'test_helper'
require 'mocha/minitest'

module EventService
  class EventsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      admin = OpenStruct.new(id: 1, email: '', roles: ['admin'], token: "test", is_admin?: true)
      EventService::ApplicationController.any_instance.stubs(:session_user).returns(admin)
    end

    test "events" do
      EventService::ApplicationController.any_instance.stubs(:authenticate_service).returns(true)
      get events_url(eventable_type: "SellerVersion", eventable_id: 2), as: :json
      assert_response :success
      
    end

    test "create_event" do
      EventService::ApplicationController.any_instance.stubs(:authenticate_service).returns(true)
      assert_difference('EventService::Event.count') do
        post events_url, params: { eventable_id: 3,
                                         eventable_type: "SellerVersion",
                                         user_id: 3,
                                         category: "Seller",
                                         note: "This is a test" }, as: :json
      end
      assert_response 200
    end
  end
end
