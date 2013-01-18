class kage::install {
  package { 'kage':
    ensure => installed,
    provider => "gem",
  }

  vcsrepo { "/opt/kage":
    ensure   => present,
    provider => git,
    source   => "git://github.com/cookpad/kage.git",
    require  => Package["kage"];
  }

  file {
    "/opt/kage/proxy.rb":
      source  => "puppet:///modules/kage/proxy.rb",
      require => Vcsrepo["/opt/kage"];
    "/opt/kage/config.yml":
      source  => "puppet:///modules/kage/config.yml",
      require => Vcsrepo["/opt/kage"];
  }
}
