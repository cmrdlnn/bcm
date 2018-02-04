install:
	bundle install

console:
	bundle exec bin/console

run:
	bundle exec foreman start

run-dev:
	WEBPACK_DEV=http://0.0.0.0:8080 bundle exec foreman start

test:
	BCM_LOG_LEVEL=unknown bundle exec rspec --fail-fast

.PHONY: doc
doc:
	bin/json_schemas_to_md
	bundle exec yard doc --quiet

.PHONY: doc_stats
doc_stats:
	bundle exec yard stats --list-undoc

migrate:
	bundle exec rake bitcoin_course_monitoring:migrate

webpack-prod:
	npm run prod

webpack:
	npm run dev

webpack-dev:
	@runner=`whoami` ; \
	if test $$runner == "vagrant" ; \
	then \
		echo "***************************************************************" ; \
		echo "* HotReload теряет свою эффективность внутри виртуальной      *" ; \
		echo "* машины, поэтому для чистоты конфигурации данная возможность *" ; \
		echo "* отсутствует.                                                *" ; \
		echo "*                                                             *" ; \
		echo "* Выполните make webpack-dev на хостовой машине.              *" ; \
		echo "***************************************************************" ; \
	else \
		npm run start ; \
	fi
