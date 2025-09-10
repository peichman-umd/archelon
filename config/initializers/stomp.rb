# STOMP server and destinations
STOMP_CONFIG = Archelon::Application.config_for(:stomp).with_indifferent_access

# Convenient shorthand for passing host and port to Stomp::Client and Stomp::Connection
STOMP_SERVER = { host: STOMP_CONFIG['host'], port: STOMP_CONFIG['port'] }.freeze

archelon_url = STOMP_CONFIG['archelon_url'] || 'http://archelon-local:3000/'

archelon_uri = URI(archelon_url)
valid_url = (archelon_uri.scheme == 'http' || archelon_uri.scheme == 'https') &&
            archelon_uri.host && archelon_uri.port
raise "'#{archelon_url}' cannot be parsed as a valid URL." unless valid_url

ARCHELON_SERVER = { protocol: archelon_uri.scheme, host: archelon_uri.host, port: archelon_uri.port }.freeze
STATUS_CALLBACK_BASE_URL = STOMP_CONFIG[:status_callback_base_url] || archelon_url
