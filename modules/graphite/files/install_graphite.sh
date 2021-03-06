#!/bin/bash

build_dir="/tmp/graphite"
TMP_File="/opt/graphite/.install"

if [[ ! -f "${TMP_File}" ]]
then 
	carbon_version="0.9.12"
	whisper_version="0.9.12"
	graphite_web_version="0.9.12"
	[[ -d  ${build_dir} ]] && rm -rf "${build_dir}"
	install -d ${build_dir}
	cd ${build_dir}
	curl -s -L https://github.com/graphite-project/carbon/archive/${carbon_version}.tar.gz | tar xz
	curl -s -L https://github.com/graphite-project/whisper/archive/${whisper_version}.tar.gz | tar xz
	curl -s -L https://github.com/graphite-project/graphite-web/archive/${graphite_web_version}.tar.gz | tar xz
	easy_install django-tagging==0.3.1
	easy_install twisted==11.1.0
	easy_install txamqp==0.4

	cd ${build_dir}/graphite-web-${graphite_web_version}
	python setup.py install # subscribe to untar webapp
	cd ${build_dir}/carbon-${carbon_version}
	python setup.py install # subscribe to untar webapp
	cd ${build_dir}/whisper-${whisper_version}
	python setup.py install # subscribe to untar webapp

	cd /opt/graphite/webapp/graphite
	python manage.py syncdb --noinput

	chown -R carbon:carbon /opt/graphite
	chown -R apache:apache /opt/graphite/storage
	chown -R carbon:carbon /opt/graphite/storage/whisper
	chcon -R -h -t httpd_sys_content_t /opt/graphite/storage

	#service httpd restart
	date > ${TMP_File}
fi
