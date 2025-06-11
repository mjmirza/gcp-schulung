variable "dashboard_name" {
  description = "The name of the monitoring dashboard."
  type        = string
}

variable "project_id" {
  description = "The ID of the Google Cloud project."
  type        = string
}

variable "location" {
  description = "The location for the monitoring dashboard."
  type        = string
  default     = "global"
}

variable "dashboard_display_name" {
  description = "The display name for the monitoring dashboard."
  type        = string
}

variable "widgets" {
  description = "A list of widgets to be included in the dashboard."
  type        = list(object({
    title       = string
    xy_position = object({
      x = number
      y = number
    })
    widget_type = string
    data_source = string
  }))
}