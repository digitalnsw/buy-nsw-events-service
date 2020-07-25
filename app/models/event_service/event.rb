module EventService
  class Event < EventService::ApplicationRecord

    acts_as_paranoid column: :discarded_at

    def locale_name
      # "events.messages.#{type.demodulize.underscore}"
    end

    def user
      # TODO: Make RemoteUser for this
      # User.with_deleted.find_by(id: self[:user_id])
    end

    # Default implementation
    def message
      # I18n.t(locale_name)
    end
  end
end
