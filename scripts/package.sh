#!/bin/bash
mkdir -p /workspace/package/DLPTemplates/{deIdentify_templates,inspect_templates}
mkdir -p /workspace/package/DLPTemplates/tests/{utils,ittest}
cd /workspace/DLPTemplates/
cp -R scripts/ /workspace/package/DLPTemplates/scripts/
cp tests/*.* /workspace/package/DLPTemplates/tests/
touch /workspace/package/DLPTemplates/deIdentify_templates_to_delete.txt
touch /workspace/package/DLPTemplates/inspect_templates_to_delete.txt
input="/workspace/dlp-diff.txt"
cd /workspace/DLPTemplates
while IFS= read -r line
do
  subfolder=$(echo "$line" | cut -d '/' -f 1)
  if [[ "$subfolder" == "deIdentify_templates" ]]; then
    if [[ -f "$line" ]]; then
      cp "$line" "/workspace/package/DLPTemplates/deIdentify_templates/"
      template_file=`echo "${line}" | awk -F/ '{print $NF}'`
      it_test_file="${template_file%.*}"_test.py
      cp "tests/ittest/$it_test_file" "/workspace/package/DLPTemplates/tests/ittest/"
    else
      echo "$line" | cut -d '/' -f 2 | sed -e 's/.json//g' >> "/workspace/package/DLPTemplates/deIdentify_templates_to_delete.txt"
    fi
  fi
  if [[ "$subfolder" == "inspect_templates" ]]; then
    if [[ -f "$line" ]]; then
      cp "$line" "/workspace/package/DLPTemplates/inspect_templates/"
      template_file=`echo "${line}" | awk -F/ '{print $NF}'`
      it_test_file="${template_file%.*}"_test.py
      cp "tests/ittest/$it_test_file" "/workspace/package/DLPTemplates/tests/ittest/"
    else
      echo "$line" | cut -d '/' -f 2 | sed -e 's/.json//g' >> "/workspace/package/DLPTemplates/inspect_templates_to_delete.txt"
    fi
  fi
done < "$input"
cd /workspace/package/
zip -r DLPTemplates.zip DLPTemplates/
