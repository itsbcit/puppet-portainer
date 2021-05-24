# frozen_string_literal: true

require 'spec_helper'

describe 'portainer::edge_agent' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
    end
  end

  context "with default parameters" do
    it { is_expected.to contain_file('portainer-edge-agent.service')
      .with({'path' => '/etc/systemd/system/portainer-edge-agent.service'})
      .with_content(/^Description=Portainer CE Edge Agent$/)
      .with_content(/^EnvironmentFile=\/etc\/sysconfig\/portainer-edge-agent/)
    }
  end
end
