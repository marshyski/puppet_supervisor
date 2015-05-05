class puppet_supervisor {

  yumrepo { 'epel':
    ensure         => 'present',
    descr          => 'Extra Packages for Enterprise Linux 6 - $basearch',
    enabled        => '1',
    failovermethod => 'priority',
    gpgcheck       => '0',
    gpgkey         => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6',
    mirrorlist     => 'http://mirrors.fedoraproject.org/mirrorlist?repo=epel-6&arch=$basearch',
  }

  package { 'supervisor':
    ensure  => latest,
    require => Yumrepo['epel'],
  }

  file {'/var/log/supervisor':
    ensure  => directory,
    owner   => root,
    group   => root,
    mode    => '0755',    
    require => Package['supervisor'],
  }

  file {'/etc/supervisor.d':
    ensure  => directory,
    owner   => root,
    group   => root,
    mode    => '0755',
    require => Package['supervisor'],
  }

  file { '/etc/supervisord.conf':
    ensure  => present,
    content => template('puppet_supervisor/supervisord.conf'),
    require => File['/etc/supervisor.d'],
  }

  service { 'supervisord':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    subscribe  => File['/etc/supervisord.conf'],
    require    => File['/etc/supervisord.conf'],
  }

}
