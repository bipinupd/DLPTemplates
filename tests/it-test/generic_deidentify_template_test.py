from pytest import mark
from utils import common

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
        response = common.deindentify(data, project, self.template_id)
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
        response = common.deindentify(data, project, self.template_id)
        assert response.item.table.rows[0].values[0].string_value != "test_user"
        
        