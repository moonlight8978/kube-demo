.PHONY: init-web

init-web:
	docker-compose run --rm web rails new . -f -B -T -d mysql --skip-turbolinks --skip-webpack-install
