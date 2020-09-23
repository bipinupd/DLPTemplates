import google.cloud.dlp
from pytest import mark

@mark.smoke
class GenericInspectTest:
    
    @classmethod 
    def setup_class(self):
        self.template_id = "generic_inspect_template"

    def test_inspect_age(self, project):
        item = {'value': 'I am 25 years old'}
        response = self.inspectdata(item, project,self.template_id)
        assert response.result.findings[0].info_type.name == "AGE"

    def test_inspect_gender(self, project):
        item = {'value': 'The victim was male'}
        response = self.inspectdata(item, project,self.template_id)
        assert response.result.findings[0].info_type.name == "GENDER"

    def test_inspect_email(self, project):
        item = {'value': 'My email is test@example.com'}
        response = self.inspectdata(item, project,self.template_id)
        assert response.result.findings[0].info_type.name == "EMAIL_ADDRESS"
    

    def inspectdata(self, data, project_id, template_id):
        dlp = google.cloud.dlp_v2.DlpServiceClient()
        parent = dlp.project_path(project_id)
        inspect_template=f"projects/{project_id}/inspectTemplates/{template_id}"
        response = dlp.inspect_content(parent, inspect_template_name=inspect_template,item=data)
        return response