app_name=dashboard

project_dir=$(CURDIR)
build_dir=$(CURDIR)/build/artifacts
appstore_dir=$(build_dir)/appstore
source_dir=$(build_dir)/source
sign_dir=$(build_dir)/sign
package_name=$(app_name)
cert_dir=$(HOME)/.nextcloud/certificates
github_account=nextcloud
branch=master
version+=6.0.0


all: composer npm appstore

release: appstore github-release github-upload

github-release:
	github-release release \
		--user $(github_account) \
		--repo $(app_name) \
		--target $(branch) \
		--tag v$(version) \
		--name "$(app_name) v$(version)"

github-upload:
	github-release upload \
		--user $(github_account) \
		--repo $(app_name) \
		--tag v$(version) \
		--name "$(app_name)-$(version).tar.gz" \
		--file $(build_dir)/$(app_name)-$(version).tar.gz

clean:
	rm -rf $(build_dir)
	rm -rf node_modules components vendor

npm:
	npm install gridstack
	cp node_modules/gridstack/dist/gridstack.all.js ./js/
	cp node_modules/gridstack/dist/gridstack.css ./css/
	npm install nnattawat/flip
	cp node_modules/flip/dist/jquery.flip.js ./js/

# composer packages
composer:
	composer install --prefer-dist

appstore: composer npm clean
	mkdir -p $(sign_dir)
	rsync -a \
	--exclude=/build \
	--exclude=/docs \
	--exclude=/l10n/templates \
	--exclude=/l10n/.tx \
	--exclude=/tests \
	--exclude=/.git \
	--exclude=/.github \
	--exclude=/composer.json \
	--exclude=/composer.lock \
	--exclude=/node_modules \
	--exclude=/l10n/l10n.pl \
	--exclude=/CONTRIBUTING.md \
	--exclude=/issue_template.md \
	--exclude=/README.md \
	--exclude=/.gitattributes \
	--exclude=/.gitignore \
	--exclude=/.scrutinizer.yml \
	--exclude=/.travis.yml \
	--exclude=/Makefile \
	$(project_dir)/ $(sign_dir)/$(app_name)
	tar -czf $(build_dir)/$(app_name)-$(version).tar.gz \
		-C $(sign_dir) $(app_name)
	@if [ -f $(cert_dir)/$(app_name).key ]; then \
		echo "Signing package…"; \
		openssl dgst -sha512 -sign $(cert_dir)/$(app_name).key $(build_dir)/$(app_name)-$(version).tar.gz | openssl base64; \
	fi
