const fs = require('fs')
const path = require('path');
const yargs = require("yargs");
const JsonTemplate = require('stjs')

const options = yargs
 .usage("Usage: -p project")
 .option("p", { alias: "project", describe: "Project-Id", type: "string", demandOption: true })
 .option("d", { alias: "deidentify_templates_dir", describe: "DeIdentify Templates", type: "string", demandOption: true })
 .argv;

const projectId = options.project;
const deidentifyTemplateDir = options.deidentify_templates_dir;
const {SecretManagerServiceClient} = require('@google-cloud/secret-manager');
const client = new SecretManagerServiceClient();
var data={};

// Reads the secret and update the data
async function accessSecretVersion(secretName, data) {
  console.log(secretName)
  const [version] = await client.accessSecretVersion({
    name: 'projects/' + projectId + '/secrets/' + secretName + '/versions/latest',
  });
  data[secretName] = JSON.parse(version.payload.data.toString());
}

//Collect all KMS wrapperd keys from Secret manage required to register template
const getValuesFromSecretManager = async (secretNames) => {
    for (secretName of secretNames) { 
      await accessSecretVersion(secretName, data);
    }
}
const getAllKeys = async (data) => {
    var keys=[];
    var elements = JsonTemplate.select(data, function(key, val) {
      return /^{{.*}}$/.test(val);
    })
    elements.values().forEach((element) => { keys.push(element.replace("{{","").replace("}}","").split(".")[0]);})
    await getValuesFromSecretManager(keys);
}

//Repalce the value of KMS wrapped key and crypto key name in DLP templates 
const generateDLPTemplates = async () => {
    const outputDeidentifyDir = deidentifyTemplateDir + "_output";
    let filenames = fs.readdirSync(deidentifyTemplateDir);
    const ST = require('selecttransform').SelectTransform;
    const st = new ST();
    filenames.forEach(async(file) => {        
        const template=fs.readFileSync(deidentifyTemplateDir + path.sep + file,"utf-8")
        await getAllKeys(JSON.parse(template));
        const dlpTemplate = st.transformSync(template, data)
        fs.writeFile(outputDeidentifyDir + path.sep + file, dlpTemplate, function (err) {
        if (err) throw err;
        });
    });
}
generateDLPTemplates()