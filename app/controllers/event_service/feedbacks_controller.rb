require_dependency "event_service/application_controller"

module EventService
  class FeedbacksController < EventService::ApplicationController
    # This controller does not have CSRF check by purpose!
    # This is to avoid blocking feedbacks in case of any issue with CSRF protection
    skip_before_action :verify_authenticity_token, raise: false

    def create
      mailer_params = feedback_params
      mailer_params[:email] = session_user.email if session_user

      problem = EventService::ProblemReport.new(
        { user_id: session_user&.id }.merge(mailer_params)
      )

      if problem.save
        mailer_params[:issue_id] = problem.id
        mailer = ::NewProblemMailer.with(mailer_params)
        mailer.report_email.deliver_later
        render json: { feedback: { id: problem.id } }
      else
        render json: { errors: problem.errors&.messages&.map{|k,v| k.to_s + ' ' + v.first.to_s } }, status: :unprocessable_entity
      end
    end

    private

    def feedback_params
      params[:feedback].permit(
        :email,
        :issue,
        :task,
        :url,
        :referer,
        :browser,
        attachment_ids: [],
      ).to_h.symbolize_keys
    end
  end
end
