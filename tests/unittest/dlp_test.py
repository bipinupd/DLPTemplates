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
            with open(file) as file_loaded:
                try:
                    json.load(file_loaded)
                except:
                    pytest.fail("Invalid JSON for " + file)

    def check_template_name(self, directory):
        json_pattern = os.path.join(directory, '*.json')
        file_list = glob.glob(json_pattern)
        for file in file_list:
            with open(file) as file_loaded:
                try:
                    data = json.load(file_loaded)
                    if (os.path.splitext(file)[0] != data["templateId"]):
                        pytest.fail("File Name and template_Id does not match " + file)
                except:
                    pytest.fail("Invalid JSON for " + file) 
