# @summary Portainer Edge Agent
#
# Installs and configures the Portainer Edge Agent
#
# @example
#   include portainer::edge_agent
class portainer::edge_agent(
  String $systemd_unit_path,
  String $systemd_unit_env_file,
) {

  file { 'portainer-edge-agent.service':
    ensure  => file,
    path    => "${portainer::edge_agent::systemd_unit_path}/portainer-edge-agent.service",
    owner   => root,
    group   => root,
    mode    => '0444',
    content => template('portainer/portainer-edge-agent.service.erb'),
    notify  => Service['portainer-edge-agent'],
  }

  service { 'portainer-edge-agent':
    ensure   => 'running',
    enable   => true,
    provider => systemd,
    require  => File['portainer-edge-agent.service'],
  }
}
