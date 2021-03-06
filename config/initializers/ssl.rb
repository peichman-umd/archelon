# Configures an SSL context for use with HTTPS connections

# Load the configuration
SSL_CONFIG = Archelon::Application.config_for :ssl

SSL_CONTEXT = OpenSSL::SSL::SSLContext.new

SSL_CONTEXT.verify_mode = SSL_CONFIG['verify_mode']
if SSL_CONFIG['ca_file']
  SSL_CONTEXT.ca_file = SSL_CONFIG['ca_file']
else
  cert_store = OpenSSL::X509::Store.new
  cert_store.set_default_paths
  SSL_CONTEXT.cert_store = cert_store
end

SSL_CONFIG['client_certs'].each do |config|
  if config['cert'] && config['key']
    SSL_CONTEXT.add_certificate(
        OpenSSL::X509::Certificate.new(File.read(config['cert'])),
        OpenSSL::PKey.read(File.read(config['key']))
    )
  end
end
