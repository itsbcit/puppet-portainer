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

    it { is_expected.to contain_file('portainer-edge-agent env')
      .with({'path' => '/etc/sysconfig/portainer-edge-agent'})
      .with_content(/^EDGE=1$/)
      .with_content(/^CAP_HOST_MANAGEMENT=1$/)
      .with_content(/^# .*portainer::edge_agent::edge_id.*/)
      .with_content(/^# EDGE_ID=$/)
      .with_content(/^# .*portainer::edge_agent::edge_key.*/)
      .with_content(/^# EDGE_KEY=$/)
    }

    it { is_expected.to contain_file('portainer-edge-agent-data')
      .with({
        'ensure' => 'directory',
        'path'   => '/var/lib/portainer-edge-agent',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0750'
      })
    }
  end

  context "with custom parameters" do
    let(:params) {{
      'systemd_unit_path'     => '/foo/bar/system',
      'systemd_unit_env_file' => '/qux/corge/edge-agent.env',
      'data_path'             => '/someother/place',
      'edge_id'               => 'bazquxcorge',
      'edge_key'              => 'foo-bar-baz'
    }}
    it { is_expected.to contain_file('portainer-edge-agent.service')
      .with({'path' => '/foo/bar/system/portainer-edge-agent.service'})
      .with_content(/^Description=Portainer CE Edge Agent$/)
      .with_content(/^EnvironmentFile=\/qux\/corge\/edge-agent.env/)
    }
    it { is_expected.to contain_file('portainer-edge-agent env')
      .with({'path' => '/qux/corge/edge-agent.env'})
      .with_content(/^EDGE_ID=bazquxcorge$/)
      .with_content(/^EDGE_KEY=foo-bar-baz$/)
    }
    it { is_expected.to contain_file('portainer-edge-agent-data')
      .with({'path' => '/someother/place'})
    }
  end
end
