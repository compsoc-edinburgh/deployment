include .env

REMOTE=root@deployment_host.comp-soc.com

tail:
	ssh ${REMOTE} 'docker logs -t 0 -f service-${SUBDOMAIN}'

logs:
	ssh ${REMOTE} 'docker logs service-${SUBDOMAIN}'

initialise:
	ssh ${REMOTE} 'docker run -d --name service-${SUBDOMAIN} \
		--network traefik-net \
		--label "traefik.enable=true" \
		-e PORT=0 \
		--label "traefik.http.routers.service-${SUBDOMAIN}.rule=Host(\`${SUBDOMAIN}.dev.comp-soc.com\`)" \
		--label "traefik.http.routers.api-dashboard.middlewares=traefik-forward-auth" \
		ghcr.io/compsoc-edinburgh/service-${SUBDOMAIN}'