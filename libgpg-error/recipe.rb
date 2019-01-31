#!/usr/bin/env ruby

class Libgpgerror < FPM::Cookery::Recipe
  name              'libgpgerror'
  description       'GnuPG package for RHEL/CentOS 7: libgpg-error dependency'
  maintainer        'Svyatoslav I. Maslennikov <me@smaslennikov.com>'
  section           'main'

  version           '1.35'
  revision          '1'
  arch              'all'

  source            "https://gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-#{version}.tar.bz2"
  sha256            'cbd5ee62a8a8c88d48c158fff4fc9ead4132aacd1b4a56eb791f9f997d07e067'

  replaces          'libgpg-error',
                    'libgpg-error-devel'
  conflicts         'libgpg-error',
                    'libgpg-error-devel'

  def build
    #configure :prefix => prefix, 'disable-install-doc' => true
    configure
    make
  end

  def install
    #make :install, 'DESTDIR' => destdir
    make :install
  end
end
