require "serverspec"
require "docker"
require "docker/compose"
require "rspec/wait"

set :backend, :docker
set :docker_container, 'sample-service'

RSpec.configure do |config|
    config.wait_timeout = 15
    compose = Docker::Compose.new
  
    describe "sample-service" do
      set :os, family: :alpine
      set :backend, :docker
      set :docker_container, 'sample-service'
    
      config.before(:all) do
        compose.up(detached: true, build: true)
        sleep 3
      end

    
      config.after(:all) do
        compose.kill
        compose.rm(force: true)
      end

      describe package('curl') do
        it {should be_installed}
      end

      describe port(3000) do
        it {should be_listening}
      end

      it 'should return Hello World!' do
        wait_for(
            website_content(3000)
        ).to include("Hello World!")
      end
    end
  end


  def website_content(port)
    puts("querying curl http://localhost:#{port}/")
    # puts( "Error: #{command("curl http://localhost:#{port}/").stderr}")
    command("curl http://localhost:#{port}/").stdout
  end