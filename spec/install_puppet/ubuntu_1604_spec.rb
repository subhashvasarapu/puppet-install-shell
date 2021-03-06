require "serverspec"
require "docker"

describe "Dockerfile.ubuntu_1604" do
  before(:all) do
    @image = Docker::Image.build_from_dir('.',
      {
        'dockerfile' => 'Dockerfile.ubuntu_1604'
      }
    )

    set :os, family: :debian
    set :backend, :docker
    set :docker_image, @image.id
  end

  context 'install_puppet.sh' do
    describe command('DEBIAN_FRONTEND=noninteractive bash -c "./install_puppet.sh"') do
      its(:stdout) { should match /Version parameter not defined, assuming latest/ }
      its(:stdout) { should match /The following NEW packages will be installed:/ }
      its(:stdout) { should match /puppet/ }
      its(:exit_status) { should eq 0 }
    end

    describe command('/usr/bin/puppet --version') do
      its(:stdout) { should match /^3\./ }
      its(:stderr) { should be_empty }
    end
  end
end
