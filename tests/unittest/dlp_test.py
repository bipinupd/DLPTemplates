import json
import os
import glob
import pytest

@pytest.mark.build
class BuildTest:
    def test_all_json_is_valid_for_deidentify_templates(self):
        self.check_json_structure("../deIdentify-templates/")

    def test_all_json_is_valid_for_inspect_templates(self):
        self.check_json_structure("../inspect-templates/")

    def test_deidentify_templates_have_unique_name(self):
        self.check_json_structure("../deIdentify-templates/")

    def test_inspect_templates_have_unique_name(self):
        self.check_json_structure("../inspect-templates/")

    def check_json_structure(self,directory):
        json_pattern = os.path.join(directory, '*.json')
        file_list = glob.glob(json_pattern)
        for file in file_list:
            print(file)
            with open(file) as file_loaded:
                try:
                    print(file_loaded)
                    json.load(file_loaded)
                except:
                    pytest.fail("Invalid JSON for " + file)

    def check_template_name(self, directory):
        json_pattern = os.path.join(directory, '*.json')
        file_list = glob.glob(json_pattern)
        template_name=[]
        for file in file_list:
            print(file)
            with open(file) as file_loaded:
                try:
                    print(file_loaded)
                    data = json.load(file_loaded)
                    if data["templateId"] in template_name:
                        pytest.fail("Duplicate template_Id for " + file)
                    template_name.append(data["templateId"])
                except:
                    pytest.fail("Invalid JSON for " + file) 
