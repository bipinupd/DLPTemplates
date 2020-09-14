#!/bin/bash
PROJECT_ID=$1
API_ROOT_URL="https://dlp.googleapis.com"
ALL_API_CALL_SUCCESS=0

for template in `find /workspace/dlp/inspect-templates -name *.json`; do
    API_KEY=`gcloud auth print-access-token`
    TEMPLATE_API="${API_ROOT_URL}/v2/projects/${PROJECT_ID}/inspectTemplates"
    templateId=$(cat "$template" | jq '.templateId' | sed 's/"//g')
    template_exists=$(curl -H "Content-Type: application/json" -H "Authorization: Bearer ${API_KEY}"  "${TEMPLATE_API}/$templateId" --write-out '%{http_code}' --silent --output /dev/null)
    method="POST"

    if [[ $template_exists == "200" ]]; then
        method="PATCH"
        TEMPLATE_API="${API_ROOT_URL}/v2/projects/${PROJECT_ID}/inspectTemplates/$templateId"
        jq 'del(.templateId)' "$template" > "$template".tmp && mv "$template".tmp "$template"
    fi

    DEID_INSPECT_CONFIG="@${template}"

    api_status=$(curl -X $method -H "Content-Type: application/json" \
    -H "Authorization: Bearer ${API_KEY}"  "${TEMPLATE_API}" \
    -d "${DEID_INSPECT_CONFIG}" --write-out '%{http_code}' --silent --output /dev/null)

    if [[ ${api_status} -gt 299 ]]; then
        echo "failed registering $template" 
        ALL_API_CALL_SUCCESS=-1
    fi
 done

exit $ALL_API_CALL_SUCCESS