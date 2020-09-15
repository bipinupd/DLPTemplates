from pytest import mark
import google.cloud.dlp

@mark.smoke
class GenericDeIdentifyDLPTest:
    
    @classmethod 
    def setup_class(self):
        self.template_id = "generic_deidentify_template"

    def test_deIdentification_Email(self, project):
        data = {
            "header":[
                "Email"
            ],
            "rows":[
                [
                    "test@test.com"
                ]
            ]
        }
        response = self.deindentify(data, project, self.template_id)
        assert response.item.table.rows[0].values[0].string_value != "test@test.com"

    def test_deIdentification_UserName(self, project):
        data = {
            "header":[
                "UserName"
            ],
            "rows":[
                [
                    "test_user"
                ]
            ]
        }
        response = self.deindentify(data, project, self.template_id)
        assert response.item.table.rows[0].values[0].string_value != "test_user"
        
    def deindentify(self, data, project_id, template_id):
        headers = [{"name": val} for val in data["header"]]
        rows = []
        for row in data["rows"]:
            rows.append( {"values": [{"string_value": cell_val} for cell_val in row]} )
        table = {}
        table["headers"] = headers
        table["rows"] = rows
        item = {"table": table}
        dlp = google.cloud.dlp_v2.DlpServiceClient()
        parent = dlp.project_path(project_id)
        deidentify_template=f"projects/{project_id}/deidentifyTemplates/{template_id}"
        response = dlp.deidentify_content(parent, deidentify_template_name=deidentify_template,item=item)
        return response    