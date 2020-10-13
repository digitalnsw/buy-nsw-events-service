module EventService
  class Event < EventService::ApplicationRecord

    acts_as_paranoid column: :discarded_at

    validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :issue, format: { with: /\A[A-Za-z0-9 .,'":;+~*\-_|()@#$%&\/\s]{0,1000}\z/ }
    validates :task, format: { with: /\A[A-Za-z0-9 .,'":;+~*\-_|()@#$%&\/\s]{0,1000}\z/ }
    validates :url, format: { with: /\A[A-Za-z0-9 .,'":;+~*\-_|()@#$%&\/\s]{0,1000}\z/ }
    validates :referer, format: { with: /\A[A-Za-z0-9 .,'":;+~*\-_|()@#$%&\/\s]{0,1000}\z/ }
    validates :browser, format: { with: /\A[A-Za-z0-9 .,'":;+~*\-_|()@#$%&\/\s]{0,1000}\z/ }
    validates :attachment_ids, 'shared_modules/json': { schema: [ 'integer'] }

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
