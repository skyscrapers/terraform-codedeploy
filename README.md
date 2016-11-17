# terraform-codedeploy
Terraform modules that are related to codedeploy


## app
Create a codedeploy app

### Available variables
 * [`name`]: String(required): Name of your codedeploy application
 * [`project`]: String(required): The current project

### Output
* [`app_name`]: String: Name of the codedeploy app

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
 * [`service_role_arn`]: String(required): IAM role that is used by the deployment group. You can use the [terraform-iam](https://github.com/skyscrapers/terraform-iam/blob/master/README.md#codedeploy_role) module for this.
 * [`autoscaling_groups`]: List(required): Autoscaling groups you want to attach to the deployment group


### Output
/

### Example
```
  module "deployment_group" {
    source             = "github.com/skyscrapers/terraform-codedeploy//deployment-group"
    environment        = "production"
    app_name           = "${module.codedeploy.app_name}"
    service_role_arn   = "${module.iam.arn_role}"
    autoscaling_groups = ["autoscaling1", "autoscaling2"]
  }
```

## deployment-group-ec2tag
Create an deployment group for a codedeploy app

### Available variables
 * [`environment`]: String(required): Environment where your codedeploy deployment group is used for
 * [`app_name`]: String(required): Name of the coddeploy app
 * [`service_role_arn`]: String(required): IAM role that is used by the deployment group. You can use the [terraform-iam](https://github.com/skyscrapers/terraform-iam/blob/master/README.md#codedeploy_role) module for this.
 * [`filterkey`]: String(required):  The key of the tag you assigned to the instances belonging to this deployment group
 * [`filtervalue`]: String(required): The value of the tag you assigned to the instances belonging to this deployment group


### Output
/

### Example
```
  module "deployment_group-ec2tag" {
    source             = "github.com/skyscrapers/terraform-codedeploy//deployment-group"
    environment        = "production"
    app_name           = "${module.codedeploy.app_name}"
    service_role_arn   = "${module.iam.arn_role}"
    filterkey          = "app"
    filtervalue        = "web"
  }
```
