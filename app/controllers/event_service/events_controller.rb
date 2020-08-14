require_dependency "event_service/application_controller"

module EventService
  class EventsController < EventService::ApplicationController
    skip_before_action :verify_authenticity_token, raise: false, only: [:create]
    before_action :authenticate_service, only: [:create, :index]
    before_action :authenticate_user, only: [:documents_requested]

    def index
      render json: EventService::Event.where(
          eventable_type: params["eventable_type"].camelize,
          eventable_id: params["eventable_id"]
        ).order('created_at DESC')
    end

    def create
      render json: EventService::Event.create!(
        eventable_id: params["eventable_id"],
        eventable_type: params["eventable_type"],
        user_id: params["user_id"].to_i,
        category: params["category"],
        note: params["note"],
      )
    end

    def documents_requested
      if session_user && session_user.can_buy?
        EventService::Event.create!(
          eventable_id: params[:seller_id].to_i,
          eventable_type: "Seller",
          user_id: session_user.id,
          category: "Event::Seller",
          note: "Copy of documents requested by " + session_user.email
        )
        EventService::Event.create!(
          eventable_id: session_user.buyer_id,
          eventable_type: "BuyerApplication",
          user_id: session_user.id,
          category: "Event::Buyer",
          note: "Requested supplier documents: " + params[:seller_id].to_i.to_s
        )
        ::BuyerRequestedDocumentsMailer.with(seller_id: params[:seller_id]).supplier_email.deliver_later
        # This is commented because it goes to zendesk!
        # ::BuyerRequestedDocumentsMailer.with(seller_id: params[:seller_id], user_email: session_user.email).
        #   buy_nsw_email.deliver_later
      end
    end
  end
end
