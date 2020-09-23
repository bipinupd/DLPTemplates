#!/bin/bash
PROJECT_ID=$1
API_ROOT_URL="https://dlp.googleapis.com"
ALL_API_CALL_SUCCESS=0;

for template in `find /workspace/DLPTemplates/deIdentify_templates_output -name *.json`; do

  templateId=$(cat "$template" | jq '.templateId' | sed 's/"//g')
  API_KEY=`gcloud auth print-access-token`
  TEMPLATE_API="${API_ROOT_URL}/v2/projects/${PROJECT_ID}/deidentifyTemplates"
  
  template_exists=$(curl -H "Content-Type: application/json" -H "Authorization: Bearer ${API_KEY}"  "${TEMPLATE_API}/$templateId" --write-out '%{http_code}' --silent --output /dev/null)
  method="POST"

  if [[ $template_exists == "200" ]]; then
    method="PATCH"
    TEMPLATE_API="${API_ROOT_URL}/v2/projects/${PROJECT_ID}/deidentifyTemplates/$templateId"
    jq 'del(.templateId)' "$template" > "$template".tmp && mv "$template".tmp "$template"
  fi

  DEID_CONFIG_PAYLOAD="@${template}"

  api_status=$(curl -X $method -H "Content-Type: application/json" \
  -H "Authorization: Bearer ${API_KEY}"  "${TEMPLATE_API}" \
  -d "${DEID_CONFIG_PAYLOAD}" --write-out '%{http_code}' --silent --output /dev/null)
  
  if [[ ${api_status} -gt 299 ]]; then
    echo "failed registering $template" 
    ALL_API_CALL_SUCCESS=-1
  fi
done

#Delete DeIdentification templates
while IFS= read -r line
do
  if [[ ! -z "$line" ]]; then
    API_KEY=`gcloud auth print-access-token`
    TEMPLATE_API="${API_ROOT_URL}/v2/projects/${PROJECT_ID}/deidentifyTemplates/$line"
    curl -X DELETE -H "Authorization: Bearer ${API_KEY}" "${TEMPLATE_API}" 
  fi
done < "/workspace/DLPTemplates/deIdentify_templates_to_delete.txt"

exit $ALL_API_CALL_SUCCESS