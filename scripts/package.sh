#!/bin/bash
mkdir -p /workspace/package/DLPTemplates/{deIdentify_templates,inspect_templates,scripts}
mkdir -p /workspace/package/DLPTemplates/tests/utils
mkdir -p /workspace/package/DLPTemplates/tests/it-test
cd /workspace/DLPTemplates/
cp -R scripts/ /workspace/package/DLPTemplates/scripts/
cp -R tests/ /workspace/package/DLPTemplates/tests/
cp -R cloudbuild* /workspace/package/DLPTemplates/dlp/
input="/workspace/dlp-diff.txt"
while IFS= read -r line
do
  subfolder=$(echo "$line" | cut -d '/' -f 2)
  if [[ "$subfolder" == "deIdentify_templates" ]]; then
    cp "$line" "/workspace/package/DLPTemplates/deIdentify_templates/"
    template_file=`echo "${line}" | awk -F/ '{print $NF}'`
    it_test_file="${template_file%.*}"_test.py
    cp "tests/it-test/$it_test_file" "/workspace/package/DLPTemplates/tests/it-test/"
  fi
  if [[ "$subfolder" == "inspect_templates" ]]; then
    cp "$line" "/workspace/package/DLPTemplates/inspect_templates/"
    template_file=`echo "${line}" | awk -F/ '{print $NF}'`
    it_test_file="${template_file%.*}"_test.py
    cp "tests/it-test/$it_test_file" "/workspace/package/DLPTemplates/tests/it-test/"
  fi
done < "$input"
cd /workspace/package
zip -r DLPTemplates.zip DLPTemplates/
