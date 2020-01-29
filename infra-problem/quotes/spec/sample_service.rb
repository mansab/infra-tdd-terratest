require "serverspec"
require "docker"

describe "Dockerfile-Builder" do
  before(:all) do
    image = Docker::Image.build_from_dir('..', opts = {'target'=>'builder', 'dockerfile'=>'quotes/Dockerfile'})

    # .build(commands, opts = {}, connection = Docker.connection, &block) ⇒ Object

    set :os, family: :alpine
    set :backend, :docker
    set :docker_image, image.id

  end

  it "has java 11.0" do
    expect(java_version).to include("11")
  end

  it "has lein 2.9" do
    expect(lein_version).to include("2.9")
  end

  def java_version()
    command("java --version").stdout
  end

  def lein_version()
    command("lein -version").stdout
  end

  describe file('/usr/src/common-utils/project.clj') do
    it {should exist}
    it {should be_mode 644}
  end

end
