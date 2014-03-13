APP_ROOT = ENV['URL']

# Check all the required environment variables are set
before do
  required_env_vars = [ENV['LP_DIRECT_PRINT_CODE'], ENV['DASHBOARD_USERNAME'], ENV['DASHBOARD_PASSWORD']]
  required_env_vars.each do |env_var|
    unless env_var
      halt erb :setup
    end
  end
  # This sets all routes as protected with basic auth
  protected!
end

# The dashboard - currently just tells you if you're set up correctly or not
get '/' do
  erb :home
end

# This handles the incoming mail
post '/letterbox' do
  @style   = "email"
  @body    = params[:"body-plain"]
  @subject = params[:subject]
  @sender  = params[:from]
  send_message
end

post '/smsbox' do
  @style   = "sms"
  @body    = params[:"body"]
  @subject = "SMS Message"
  @sender  = params[:from]
  send_message
end

not_found do
  erb :"404"
end

# Set some variables for use in test routes
before '/mailtest/*' do
  @style   = "email"
  @subject = "Dinner"
  @body    = "Hello!\n\nThanks for dinner last night. We had a great time! See you soon."
  @sender  = "Barry"
end

before '/smstest/*' do
  @style   = "sms"
  @subject = "SMS Message"
  @body    = "Hello! Thanks for dinner last night. We had a great time! See you soon."
  @sender  = "Jonathan Austin"
end

# Show a test message in the browser
get '*/show-junkmail/?' do
  case @style
  when "sms"
      erb :sms, :layout => nil
  when "email"
      erb :stationery, :layout => nil
  end
end

# Print a test SMS
get '*/print-junkmail/?' do
  send_message
end
