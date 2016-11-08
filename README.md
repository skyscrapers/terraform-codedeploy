# terraform-codedeploy
Terraform modules that are related to codedeploy


## app
Create a codedeploy app

### Available variables
 * [`name`]: String(required): Name of your codedeploy application
 * [`project`]: String(required): The current project

### Output
* [`app_name`]: Sreing: Name of the codedeploy app

### Example
```
  module "codedeploy" {
    source  = "github.com/skyscrapers/terraform-codedeploy//app"
    name    = "application"
    project = "example"
  }
```

## deployment_group
Create an deployment group for a codedeploy app

### Available variables
 * [`environment`]: String(required): Environment where your codedeploy deployment group is used for
 * [`app_name`]: String(required): Name of the coddeploy app
 * [`service_role_arn`]: String(required): IAM role that is used by the deployment group
 * [`autoscaling_groups`]: List(required): Autoscaling groups you want to attach to the deployment group


### Output
/

### Example
```
  module "deployment_group" {
    source             = "github.com/skyscrapers/terraform-codedeploy//deployment-group"
    environment        = "production"
    app_name           = "test-app"
    service_role_arn   = "${module.iam.arn_role}"
    autoscaling_groups = ["autoscaling1", "autoscaling2"]
  }
```
