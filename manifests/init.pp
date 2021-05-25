# @summary Portainer CE Server
#
# Portainer CE Server in a docker container managed by systemd
#
# @example
#   include portainer
class portainer(
  String $systemd_unit_path,
  String $data_path,
  String $pki_mount_path,
) {
  file { 'portainer.service':
    path    => "${portainer::systemd_unit_path}/portainer.service",
    owner   => root,
    group   => root,
    mode    => '0444',
    content => template('portainer/portainer.service.erb'),
    notify  => [
      Exec['daemon-reload'],
      Service['portainer'],
    ],
  }

  file { 'data_path':
    ensure => directory,
    path   => $portainer::data_path,
    owner  => root,
    group  => root,
    mode   => '0750',
  }

  exec { 'daemon-reload':
    command     => 'systemctl daemon-reload',
    path        => '/bin:/sbin:/usr/bin:/usr/sbin',
    refreshonly => true,
  }

  service { 'portainer':
    ensure   => running,
    enable   => true,
    provider => systemd,
    require  => File['portainer.service'],
  }
}
