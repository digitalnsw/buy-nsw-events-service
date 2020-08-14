module EventService
  class ProblemReport < EventService::ApplicationRecord
    self.table_name = 'problem_reports'
    include AASM

    aasm column: :state do
      state :open, initial: true
      state :resolved

      event :resolve do
        transitions from: :open, to: :resolved
      end
    end

    # belongs_to :user, optional: true
    # belongs_to :resolved_by, class_name: 'User', optional: true

    validate :validate_presence_of_task_or_issue
    validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
    validates :issue, format: { with: /\A[A-Za-z0-9 .,'":;+~*\-_|()@#$%&\/\s]{0,1000}\z/ }
    validates :task, format: { with: /\A[A-Za-z0-9 .,'":;+~*\-_|()@#$%&\/\s]{0,1000}\z/ }
    validates :url, format: { with: URI.regexp }, allow_blank: true
    validates :referer, format: { with: URI.regexp }, allow_blank: true
    validates :browser, format: { with: /\A[A-Za-z0-9 .,'":;+~*\-_|()@#$%&\/\s]{0,1000}\z/ }, allow_blank: true
    validates :attachment_ids, 'shared_modules/json': { schema: ['integer'] }

    # scope :in_state, ->(state) { where(state: state) }
    # scope :with_tag, ->(tag) { where(":tag = ANY(tags)", tag: tag) }

    def set_json_error attribute, error
      errors.add attribute, "JSON validation failed"
    end

    def validate_presence_of_task_or_issue
      if task.blank? && issue.blank?
        errors.add(:base, 'must have a task or issue')
      end
    end
  end
end
