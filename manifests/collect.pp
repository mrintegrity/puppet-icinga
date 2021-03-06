# == Class: icinga::collect
#
# This class provides resource collection.
#
class icinga::collect {
  if $::icinga::server {
    # Set defaults for collected resources.
    Nagios_host <<| |>>              { notify => Service[$::icinga::service_server] }
    Nagios_service <<| |>>           { notify => Service[$::icinga::service_server] }
    Nagios_hostextinfo <<| |>>       { notify => Service[$::icinga::service_server] }
    Nagios_command <<| |>>           { notify => Service[$::icinga::service_server] }
    Nagios_contact <<| |>>           { notify => Service[$::icinga::service_server] }
    Nagios_contactgroup <<| |>>      { notify => Service[$::icinga::service_server] }
    Nagios_hostdependency <<| |>>    { notify => Service[$::icinga::service_server] }
    Nagios_hostescalation <<| |>>    { notify => Service[$::icinga::service_server] }
    Nagios_hostgroup <<| |>>         { notify => Service[$::icinga::service_server] }
    Nagios_servicedependency <<| |>> { notify => Service[$::icinga::service_server] }
    Nagios_serviceescalation <<| |>> { notify => Service[$::icinga::service_server] }
    Nagios_serviceextinfo <<| |>>    { notify => Service[$::icinga::service_server] }
    Nagios_servicegroup <<| |>>      { notify => Service[$::icinga::service_server] }
    Nagios_timeperiod <<| |>>        { notify => Service[$::icinga::service_server] }
  }

  Nagios_service {
    host_name           => $::icinga::collect_hostname,
    use                 => 'generic-service',
    notification_period => $::icinga::notification_period,
    target              => "${::icinga::targetdir}/services/${::fqdn}.cfg",
  }

  if $::icinga::client {
    @@nagios_host { $::icinga::collect_hostname:
      ensure             => present,
      alias              => $::hostname,
      address            => $::icinga::collect_ipaddress,
      max_check_attempts => $::icinga::max_check_attempts,
      check_command      => 'check-host-alive',
      use                => 'linux-server',
      hostgroups         => 'linux-servers',
      action_url         => '/pnp4nagios/graph?host=$HOSTNAME$',
      target             => "${::icinga::targetdir}/hosts/host-${::fqdn}.cfg",
    }

    @@nagios_hostextinfo { $::icinga::collect_hostname:
      ensure          => present,
      icon_image_alt  => $::operatingsystem,
      icon_image      => "os/${::operatingsystem}.png",
      statusmap_image => "os/${::operatingsystem}.png",
      target          => "${::icinga::targetdir}/hosts/hostextinfo-${::fqdn}.cfg",
    }

    @@nagios_service { "check_ping_${::hostname}":
      check_command       => 'check_ping!100.0,20%!500.0,60%',
      service_description => 'Ping',
      action_url          => '/pnp4nagios/graph?host=$HOSTNAME$&srv=$SERVICEDESC$',
    }
  }
}

