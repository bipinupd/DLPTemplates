#!/bin/bash
mkdir -p /workspace/package/DLPTemplates/{deIdentify_templates,inspect_templates}
mkdir -p /workspace/package/DLPTemplates/tests/{utils,it-test}
cd /workspace/DLPTemplates/
cp -R scripts/ /workspace/package/DLPTemplates/scripts/
cp tests/*.* /workspace/package/DLPTemplates/tests/
touch /workspace/package/DLPTemplates/deIdentify_templates_to_delete
touch /workspace/package/DLPTemplates/inspect_templates_to_delete
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
      cp "tests/it-test/$it_test_file" "/workspace/package/DLPTemplates/tests/it-test/"
    else
      echo "$line" | cut -d '/' -f 2 | sed -e 's/.json//g' >> "/workspace/package/DLPTemplates/deIdentify_templates_to_delete"
    fi
  fi
  if [[ "$subfolder" == "inspect_templates" ]]; then
    if [[ -f "$line" ]]; then
      cp "$line" "/workspace/package/DLPTemplates/inspect_templates/"
      template_file=`echo "${line}" | awk -F/ '{print $NF}'`
      it_test_file="${template_file%.*}"_test.py
      cp "tests/it-test/$it_test_file" "/workspace/package/DLPTemplates/tests/it-test/"
    else
      echo "$line" | cut -d '/' -f 2 | sed -e 's/.json//g' >> "/workspace/package/DLPTemplates/inspect_templates_to_delete"
    fi
  fi
done < "$input"
cd /workspace/package/
zip -r DLPTemplates.zip DLPTemplates/
