# Required Variables
bearer_token=oc sa get-token "prometheus" -n "kube-system"
bearer_token=eyJhbGciOiJSUzI1NiIsImtpZCI6IiJ9.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJrdWJlLXN5c3RlbSIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VjcmV0Lm5hbWUiOiJwcm9tZXRoZXVzLXRva2VuLXJmMnc0Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQubmFtZSI6InByb21ldGhldXMiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC51aWQiOiIxYWI2YTM1OS1kNDUxLTExZTgtODE2Zi1jYWU0M2E1NDkzZmUiLCJzdWIiOiJzeXN0ZW06c2VydmljZWFjY291bnQ6a3ViZS1zeXN0ZW06cHJvbWV0aGV1cyJ9.ewUWXFTCx01uoyTlR8zR1ejUPjVZs9Gs5vi4KGJKn4w0MxsLkg5SKKIA3-9FbUmI05BdgyQKhk5aL7vPN5Ir1przKpo1t4h5zyyXT74cHYy7mlUflTVxCVlNz9yEB476L5WjlLS2EsJ9txueRh7MeHEsJJJmFG2Rj3hNKnrzEI7CCOJ16W6EQfnqKPHMqKly46kCwUoh2qe1A3dmSO2kuOrdXOk2Cslbk0K7Ttab3XvD9wO-kVHE61Y60In3On0SSVDGj8m2_HqBnSKOyTKsRAGXui_KzUIeCbuUNLhVckzaqt0tJ-i9y2kMXEdJHw9X2g6MmzWmHj4Mp294G7GAR
prometheus_url=http://prometheus.istio-system.svc:9090/

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
	oc process -f train-prophet-deployment-template.yaml --param APPLICATION_NAME="${oc_app_name}" \
			--param URL="${prometheus_url}" \
			--param GIT_URI=https://github.com/durandom/prometheus-anomaly-detector.git \
			--param STORE_INTERMEDIATE_DATA=False \
			--param METRIC_NAME=\
			--param TRAINING_REPEAT_HOURS=1 \
			--param GET_OLDER_DATA=False \
			--param BEARER_TOKEN="${bearer_token}" \
			--param BOTO_ACCESS_KEY="${block_storage_access_key}" \
			--param BOTO_SECRET_KEY="${block_storage_secret_key}" \
			--param BOTO_OBJECT_STORE="${block_storage_bucket_name}" \
			--param BOTO_STORE_ENDPOINT="${block_storage_endpoint_url}" | oc apply -f -

oc_delete_all:
	oc delete all -l app=${oc_app_name}

METRIC_NAME=node_load1
BEARER_TOKEN=eyJhbGciOiJSUzI1NiIsImtpZCI6IiJ9.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJrdWJlLXN5c3RlbSIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VjcmV0Lm5hbWUiOiJwcm9tZXRoZXVzLXRva2VuLXYybTVtIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQubmFtZSI6InByb21ldGhldXMiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC51aWQiOiI0ZWZmMjlhOC1kNDNmLTExZTgtOTE1Yy03MjM4NzNkMzgwN2IiLCJzdWIiOiJzeXN0ZW06c2VydmljZWFjY291bnQ6a3ViZS1zeXN0ZW06cHJvbWV0aGV1cyJ9.qH_fEpYMp3fVGzU0K-OlZR1n-PChd0MojlRyUF2FMDeiTowljZemuMCGXOMI9CAZ_ScVUACiL3AZUMIk-mcTWV40Ii2Ym7duThvTlK3BIrZrc27tL-1hPQRZCI5UdFpazdEKgg-IvAGBuqAlVwam--qB_seWupoS2ek3J58-9hzrSWVa7Prl0wOUv8I4u3r6_l_K63MMLeld_1tsmwQrWbwyLBIzZpIaS4aauFp8q8LIAGeLmXLjKPv_Ogn2KNR_syG_OU9wEkeGZ67CkHfOuj-Hf6VArvcOpox48lU9zlW2YXP3hxWnViFnKOd0HAYn4sqEZmVoqt3U33ASFX0piw
URL=https://prometheus-kube-system.192.168.64.3.nip.io/
BOTO_ACCESS_KEY=a
BOTO_SECRET_KEY=b
BOTO_OBJECT_STORE=d
BOTO_STORE_ENDPOINT=f
run_model:
	METRIC_NAME=node_load1 \
	BEARER_TOKEN=${bearer_token} \
	URL=${prometheus_url} \
	BOTO_ACCESS_KEY=${block_storage_access_key} \
	BOTO_SECRET_KEY=${block_storage_secret_key} \
	BOTO_OBJECT_STORE=${block_storage_bucket_name} \
	BOTO_STORE_ENDPOINT=${block_storage_endpoint_url} \
	pipenv run python3 ./app.py
