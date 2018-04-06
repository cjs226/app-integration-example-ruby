# Choose the site being integrated. Values include:
# 'https://secure.affinipay.com', 'https://secure.lawpay.com', 'https://secure.cpacharge.com'

# You may enter values in this file, and pass these values via the command line or shell environment.
# Command line values override values set in this file.
# For example runs the tests using the SITE varible from the command line.
# $ SITE='https://secure.affinipay.com' rspec spec/* --format doc

# OAuth credentials, site and redirect URI are not optional.
ENV['SITE']                       ||= ''
ENV['OAUTH2_CLIENT_ID']           ||= ''
ENV['OAUTH2_CLIENT_SECRET']       ||= ''
ENV['OAUTH2_CLIENT_REDIRECT_URI'] ||= ''

# Gateway credentials are optional. If not specified, they will be defaulted when the
# Connect flow is performed in the app.
ENV['GATEWAY_URI']        ||= ''
ENV['GATEWAY_PUBLIC_KEY'] ||= ''
ENV['GATEWAY_SECRET_KEY'] ||= ''

# API key optional. If not specified, the demoApi endpoints will return 401.
ENV['API_APPLICATION_ID'] ||= ''
ENV['API_CLIENT_KEY']     ||= ''
ENV['ACCESS_TOKEN']       ||= ''
