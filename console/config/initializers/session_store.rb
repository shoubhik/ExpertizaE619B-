# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_console_session',
  :secret      => '40077f7bb8b513974264ff7312d8b76063dbc371d2e5fa0a0e75bfc2ae276852fbd40a018d72cb32c6b74f0d861dc47f88cac759cf99a4c277793507ce7101a6'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
