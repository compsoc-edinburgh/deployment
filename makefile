include .env

REMOTE=root@deployment_host.comp-soc.com

tail:
	ssh ${REMOTE} 'docker logs -t 0 -f service-${SUBDOMAIN}'

logs:
	ssh ${REMOTE} 'docker logs service-${SUBDOMAIN}'