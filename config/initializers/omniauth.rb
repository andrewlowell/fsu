Rails.application.config.middleware.use OmniAuth::Builder do
  provider :familysearch, ENV["fs_app_token"], '', :client_options => { :site => 'https://sandbox.familysearch.org' }
end
