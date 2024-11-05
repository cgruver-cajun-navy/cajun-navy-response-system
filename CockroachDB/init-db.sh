#!/usr/bin/env bash

mkdir -p ${PROJECTS_ROOT}/cockroach/ca ${PROJECTS_ROOT}/cockroach/certs ${PROJECTS_ROOT}/cockroach/data

cockroach cert create-ca --certs-dir=${PROJECTS_ROOT}/cockroach/certs --ca-key=${PROJECTS_ROOT}/cockroach/ca/ca.key

cockroach cert create-node localhost 127.0.0.1 --certs-dir=${PROJECTS_ROOT}/cockroach/certs --ca-key=${PROJECTS_ROOT}/cockroach/ca/ca.key

cockroach cert create-client cockroach --certs-dir=${PROJECTS_ROOT}/cockroach/certs --ca-key=${PROJECTS_ROOT}/cockroach/ca/ca.key

cockroach start-single-node --certs-dir=${PROJECTS_ROOT}/cockroach/certs --listen-addr=localhost:26257 --http-addr=0.0.0.0:8080 --store=${PROJECTS_ROOT}/cockroach/data

