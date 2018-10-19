# Required Variables
bearer_token=eyJhbGciOiJSUzI1NiIsImtpZCI6IiJ9.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJrdWJlLXN5c3RlbSIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VjcmV0Lm5hbWUiOiJwcm9tZXRoZXVzLXRva2VuLWp6bjViIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQubmFtZSI6InByb21ldGhldXMiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC51aWQiOiIxNDFmNzA1MC1jOGI0LTExZTgtOWE2ZC1lZTU2OTViNjcxNzQiLCJzdWIiOiJzeXN0ZW06c2VydmljZWFjY291bnQ6a3ViZS1zeXN0ZW06cHJvbWV0aGV1cyJ9.pypag7Z2hHs940-uDV62SZPBqIbJ6LfIKMo8w0zlYcfzmSU3LDf_gMxdUenvb9Yi2QmxEBpmeHTW_UrNpiUlBMaGh0nBg9n1YdOeU1-_ggO-vcv80r0owamnXteZQysJbJv4BZYxrPEXIdjkOvmuPRJIPhlnSpJLVauqg2EgLWrRTb5hpP8DVOUGKM4JznntbkvZIUfUMF8yB_r-udIdE25UMtwaYnPoivlO8iRqXCwD2rLJ0NZzztiSpkkvjnEsd9ZPUkdQMZNx7ZQkYfvyRSfYDwfW79BKZ1Od3hYHHT1N7necBvmCZY16YP20Z5Czd875ZOMGiuqi3GjWPoG4tQ
prometheus_url=https://prometheus-kube-system.192.168.64.3.nip.io/

block_storage_access_key=a
block_storage_secret_key=b
block_storage_bucket_name=c
block_storage_endpoint_url=d

# Optional Variables
oc_app_name=train-prom-dh-prod
docker_app_name=train-prometheus

docker_build:
	docker build -t ${docker_app_name} .

docker_test:
	docker run ${docker_app_name}

docker_run:
	docker run -ti --rm \
	   --env "BEARER_TOKEN=${bearer_token}" \
	   --env "URL=${prometheus_url}" \
		 --env BOTO_ACCESS_KEY="${block_storage_access_key}" \
		 --env BOTO_SECRET_KEY="${block_storage_secret_key}" \
		 --env BOTO_OBJECT_STORE="${block_storage_bucket_name}" \
		 --env BOTO_STORE_ENDPOINT="${block_storage_endpoint_url}" \
	   ${docker_app_name}:latest

oc_deploy:
	oc new-app --file=./train-prophet-deployment-template.yaml --param APPLICATION_NAME="${oc_app_name}" \
			--param URL="${prometheus_url}" \
			--param BEARER_TOKEN="${bearer_token}" \
			--param BOTO_ACCESS_KEY="${block_storage_access_key}" \
			--param BOTO_SECRET_KEY="${block_storage_secret_key}" \
			--param BOTO_OBJECT_STORE="${block_storage_bucket_name}" \
			--param BOTO_STORE_ENDPOINT="${block_storage_endpoint_url}"

oc_delete_all:
	oc delete all -l app=${oc_app_name}

run_model:
	BEARER_TOKEN=${bearer_token} \
	URL=${prometheus_url} \
	BOTO_ACCESS_KEY=${block_storage_access_key} \
	BOTO_SECRET_KEY=${block_storage_secret_key} \
	BOTO_OBJECT_STORE=${block_storage_bucket_name} \
	BOTO_STORE_ENDPOINT=${block_storage_endpoint_url} \
	python3 ../train-prometheus-prod/train-prometheus/app.py
