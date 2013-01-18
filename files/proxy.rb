$:.unshift File.expand_path('../lib', __FILE__)
require 'kage'
require 'yaml'

Kage::ProxyServer.start do |server|
  config = YAML.load_file(File.expand_path("../config.yml", __FILE__))[ENV['RAILS_ENV']]

  server.port = 8090
  server.host = config[:host]
  server.debug = false

  # backends can share the same host/port
  server.add_master_backend(:production, config[:production], 8080)
  server.add_backend(:sandbox, config[:sandbox], 80)

  server.client_timeout = 15
  server.backend_timeout = 10

  # Dispatch all GET requests to multiple backends, otherwise only :production
  server.on_select_backends do |request, headers|
    if request[:method] == 'GET' && rand(9) == 0
      [:production, :sandbox]
    else
      [:production]
    end
  end
end
