from utils import common
from pytest import mark

@mark.smoke
class GenericInspectTest:
    
    @classmethod 
    def setup_class(self):
        self.template_id = "generic_inspect_template"

    def test_inspect_age(self, project):
        item = {'value': 'I am 25 years old'}
        response = common.inspectdata(item, project,self.template_id)
        assert response.result.findings[0].info_type.name == "AGE"

    def test_inspect_gender(self, project):
        item = {'value': 'The victim was male'}
        response = common.inspectdata(item, project,self.template_id)
        assert response.result.findings[0].info_type.name == "GENDER"

    def test_inspect_email(self, project):
        item = {'value': 'My email is test@example.com'}
        response = common.inspectdata(item, project,self.template_id)
        assert response.result.findings[0].info_type.name == "EMAIL_ADDRESS"