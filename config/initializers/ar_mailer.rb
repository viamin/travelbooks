ActionMailer::Base.add_delivery_method :active_record, ArMailerRails3::ActiveRecord, :email_class => Error
ActionMailer::Base.delivery_method = :active_record