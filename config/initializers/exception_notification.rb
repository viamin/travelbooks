Travelbooks::Application.config.middleware.use ExceptionNotifier,
    :email_prefix => "[Travelbooks] ",
    :sender_address => %("TravellerBook Application Error" <do-not-reply@travellerbook.com>),
    :exception_recipients => %w( support@travellerbook.com )
    