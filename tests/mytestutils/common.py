import google.cloud.dlp

def deindentify(data, project_id, template_id):
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

def inspectdata(data, project_id, template_id):
    dlp = google.cloud.dlp_v2.DlpServiceClient()
    parent = dlp.project_path(project_id)
    inspect_template=f"projects/{project_id}/inspectTemplates/{template_id}"
    response = dlp.inspect_content(parent, inspect_template_name=inspect_template,item=data)
    return response
