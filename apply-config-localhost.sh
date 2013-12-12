#!/bin/bash
# Request localhost url's to set all configuration fragments after doing a godel clean run
curl 'http://localhost:8081/configuration-fragments?action=apply&config-name=analytics-repository'
curl 'http://localhost:8081/configuration-fragments?action=apply&config-name=audit-repository'
curl 'http://localhost:8081/configuration-fragments?action=apply&config-name=search-annotations-repository'
curl 'http://localhost:8081/configuration-fragments?action=apply&config-name=security-repositories'
curl 'http://localhost:8081/configuration-fragments?action=apply&config-name=system-repository'
curl 'http://localhost:8081/configuration-fragments?action=apply&config-name=ui-metadata-repository'
