# frozen_string_literal: true

require 'spec_helper'

describe 'portainer' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
      it do
        is_expected.to contain_file('portainer.service').with({
          'path' => '/etc/systemd/system/portainer.service',
        })
      end
    end
  end
end
