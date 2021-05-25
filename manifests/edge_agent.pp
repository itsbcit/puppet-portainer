# @summary Portainer Edge Agent
#
# Installs and configures the Portainer Edge Agent
#
# @example
#   include portainer::edge_agent
class portainer::edge_agent(
  String $systemd_unit_path,
  String $systemd_unit_env_file,
  String $data_path,
  String $edge_id,
  String $edge_key,
) {

  file { 'portainer-edge-agent.service':
    ensure  => file,
    path    => "${portainer::edge_agent::systemd_unit_path}/portainer-edge-agent.service",
    owner   => root,
    group   => root,
    mode    => '0444',
    content => template('portainer/portainer-edge-agent.service.erb'),
    notify  => [
      Service['portainer-edge-agent'],
      Exec['edge-agent-daemon-reload'],
    ],
  }

  file { 'portainer-edge-agent env':
    ensure  => file,
    path    => $portainer::edge_agent::systemd_unit_env_file,
    owner   => root,
    group   => root,
    mode    => '0444',
    content => template('portainer/portainer-edge-agent-env.erb'),
    notify  => Service['portainer-edge-agent'],
  }

  file { 'portainer-edge-agent-data':
    ensure => directory,
    path   => $portainer::edge_agent::data_path,
    owner  => root,
    group  => root,
    mode   => '0750',
  }

  exec { 'edge-agent-daemon-reload':
    command     => 'systemctl daemon-reload',
    path        => '/bin:/sbin:/usr/bin:/usr/sbin',
    refreshonly => true,
  }

  service { 'portainer-edge-agent':
    ensure   => 'running',
    enable   => true,
    provider => systemd,
    require  => [
      File['portainer-edge-agent.service'],
      File['portainer-edge-agent-data'],
      File['portainer-edge-agent env'],
    ],
  }
}
