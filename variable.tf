variable "ecs_cluster" {
  description = "ECS cluster name"
  default     = "ecs_cluster"
}

variable "service_name" {
  description = "ECS App Service Name"
  default     = "appecsservice"
}

variable "task_family" {
  description = "ECS Task Family"
  default     = "app"
}

variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "availability_zone" {
  description = "availability zones"
  default     = ["us-east-1a", "us-east-1b"]
}

variable "app_vpc" {
  description = "VPC Name"
  default     = "app_vpc"
}

variable "app_vpc_network_cidr" {
  description = "IP addressing for Test Network"
  default     = "10.0.0.0/16"
}

variable "aws_pub_subnet_1_cidr" {
  description = "Public 0.0 CIDR for externally accessible subnet"
  default     = "10.0.1.0/24"
}

variable "aws_pub_subnet_2_cidr" {
  description = "Public 0.0 CIDR for externally accessible subnet"
  default     = "10.0.2.0/24"
}


variable "aws_app_subnet_1_cidr" {
  description = "Private APP CIDR"
  default     = "10.0.3.0/24"
}

variable "aws_app_subnet_2_cidr" {
  description = "PrivateAPP  CIDR"
  default     = "10.0.4.0/24"
}


variable "ami_id" {
  description = "AMI ID"
  default     = "ami-fad25980" // for us-east-1
  //default     = "ami-dbfee1bf" // for eu-west-2
  //default = "ami-4cbe0935" // for eu-west-1
}

variable "max_instance_size" {
  description = "Maximum number of instances in the cluster"
  default     = "4"
}

variable "min_instance_size" {
  description = "Minimum number of instances in the cluster"
  default     = "2"
}

variable "desired_capacity" {
  description = "Desired number of instances in the cluster"
  default     = "2"
}

variable "asg_name" {
  description = "Autoscaling Group Name"
  default     = "ecs-autoscaling-group"
}
variable "evaluation_periods" {
  description = "Autoscaling evaluation period"
  default     = "4"
}

variable "period_down" {
  description = "Evaluation period for scaling down"
  default     = "120"
}

variable "period_up" {
  description = "Evaluation period for scaling down"
  default     = "60"
}

variable "threshold_up" {
  description = "Threshold value for scaling up"
  default     = "75"
}

variable "threshold_down" {
  description = "Threshold value for scaling down"
  default     = "60"
}

variable "statistic" {
  description = "Statisctics"
  default     = "Average"
}

variable "min_capacity" {
  description = "Instance Min Capacity"
  default     = "1"
}

variable "max_capacity" {
  description = "Instance Max Capacity"
  default     = "4"
}

variable "lowerbound" {
  description = "Metrics Lower interval"
  default     = "0"
}

variable "upperbound" {
  description = "Metrics Upper interval"
  default     = "0"
}

variable "scale_up_adjustment" {
  description = "Scaling up count for instance, container"
  default     = "1"
}

variable "scale_down_adjustment" {
  description = "Scaling down count for instance, container"
  default     = "-1"
}

variable "datapoints_to_alarm_up" {
  description = "Datapoint to monitor to trigger alarm up"
  default     = "4"
}

variable "datapoints_to_alarm_down" {
  description = "Datapoint to monitor to trigger alarm down"
  default     = "4"
}

variable "aws_db_subnet_1_cidr" {
  default = "10.0.5.0/24"
}

variable "aws_db_subnet_2_cidr" {
  default = "10.0.6.0/24"
}

variable "db_user" {
  description = "Database user"
  default     = "app"
}

variable "db_name" {
  description = "Database name"
  default     = "app"
}

variable "db_engine" {
  description = "Database engine type"
  default     = "postgres"
}

variable "db_engine_version" {
  description = "Database engine version"
  default     = "10.7"
}

variable "db_identifier" {
  description = "Database Identifier"
  default     = "app-db"
}

variable "storage_encrypted" {
  description = "DB storage encryption"
  default     = "false"
}

variable "maintenance_window" {
  description = "Maintance Window"
  default     = "Sun:00:00-Sun:03:00"
}

variable "backup_window" {
  description = "Backup Window"
  default     = "03:00-06:00"

}
variable "enabled_cloudwatch_logs_exports" {
  description = "DB Cloudwatch logging"
  default     = ["postgresql", "upgrade"]

}
variable "backup_retention_period" {
  description = "DB backup retention"
  default     = 1

}

variable "skip_final_snapshot" {
  description = "DB snapshot"
  default     = "true"

}
variable "deletion_protection" {
  description = "DB deletion protection"
  default     = "false"

}
variable "multi_az" {
  description = "DB high availability"
  default     = "true"
}

variable "db_class" {
  description = "Instance Type"
  default     = "db.t2.micro"
}
