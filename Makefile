PACKAGE?=
PLATFORM?=centos
OPTIONS?=--no-deps

EXTENSION?=rpm

build:
	cd $(PACKAGE) && \
		bundle exec fpm-cook --platform $(PLATFORM) $(OPTIONS)

clean:
	cd $(PACKAGE) && \
		bundle exec fpm-cook clean && \
		rm -rf tmp-dest \
			tmp-build \
			cache \
			pkg

build-all:
	set -ex; \
	for i in $$(find . -name recipe.rb | grep -v .gems | cut -d'/' -f2); do \
		PACKAGE=$$i $(MAKE) clean build; \
	done

travis-build:
	set -ex; \
	for i in libgpg-error \
			libassuan \
			libgcrypt \
			libksba \
			npth \
			ntbtls \
			pinentry \
			gnupg \
			gpgme; do \
		PACKAGE=$$i PLATFORM=ubuntu $(MAKE) clean build; \
		sudo dpkg -i $$i/pkg/*deb; \
		cp $$i/pkg/*deb ./; \
	done

generate-installation-docs:
	echo "## Please do read the commands you'll be executing! I'm not responsible for your mishaps.\n" > INSTALL.md
	echo "Install on Ubuntu (tested on 16.04 and 18.04) by acquiring the DEBs and installing them altogether:\n" >> INSTALL.md
	echo '```' >> INSTALL.md
	EXTENSION=deb $(MAKE) --silent urls >> INSTALL.md
	echo 'sudo dpkg -i *.deb' >> INSTALL.md
	echo '```\n' >> INSTALL.md
	echo "Install on CentOS/RHEL (tested on CentOS 7) by acquiring the RPMs and installing them altogether:\n" >> INSTALL.md
	echo '```' >> INSTALL.md
	EXTENSION=rpm $(MAKE) --silent urls >> INSTALL.md
	echo 'sudo yum install *.rpm' >> INSTALL.md
	echo '```' >> INSTALL.md

urls:
	for i in *$(EXTENSION); do \
		echo wget https://github.com/smaslennikov/packages/releases/download/$${TRAVIS_TAG}/$$i; \
	done
