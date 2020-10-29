include .env

REMOTE=root@deployment_host.comp-soc.com

# .SILENT:

tail:
	ssh ${REMOTE} 'docker logs -f --tail 0 service-${SUBDOMAIN}'

logs:
	ssh ${REMOTE} 'docker logs service-${SUBDOMAIN}'

generate-port:
	ssh ${REMOTE} 'ruby -e "require \"socket\"; puts Addrinfo.tcp(\"\", 0).bind {|s| s.local_address.ip_port }"' | tr -d '[:space:]' > .open-port

PORT = $(shell cat .open-port)

initialise: generate-port
	# _Definitely_ prone to race conditions, but this won't be called anywhere near frequently enough for that to matter
	ssh ${REMOTE} 'docker exec postgres createdb -U postgres service-db-${SUBDOMAIN}'
	ssh ${REMOTE} 'docker run -d --name service-${SUBDOMAIN} \
		--network traefik-net \
		--label "traefik.enable=true" \
		-p ${PORT}:${PORT} \
		-e PORT=${PORT} \
		-e "DATABASE_URL=postgresql://postgres:mysecretpassword@postgres:5432/service-db-${SUBDOMAIN}" \
		--label "traefik.http.routers.service-${SUBDOMAIN}.rule=Host(\`${SUBDOMAIN}.dev.comp-soc.com\`)" \
		--label "traefik.http.routers.service-${SUBDOMAIN}.middlewares=traefik-forward-auth" \
		ghcr.io/compsoc-edinburgh/service-${SUBDOMAIN}'
	rm .open-port
	
teardown-db:
	ssh ${REMOTE} 'docker exec postgres dropdb -U postgres service-db-${SUBDOMAIN}'

teardown: teardown-db
	ssh ${REMOTE} 'docker stop service-${SUBDOMAIN}'
	ssh ${REMOTE} 'docker rm service-${SUBDOMAIN}'