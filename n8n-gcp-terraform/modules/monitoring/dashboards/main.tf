resource "google_monitoring_dashboard" "n8n_dashboard" {
  dashboard_json = jsonencode({
    displayName = "n8n Monitoring Dashboard"
    widgets = [
      {
        title = "n8n Instance CPU Utilization"
        xyChart = {
          dataSets = [
            {
              timeSeriesQuery = {
                timeSeriesFilter = {
                  filter = "metric.type=\"compute.googleapis.com/instance/disk/write_bytes_count\" AND resource.type=\"gce_instance\""
                  aggregations = [
                    {
                      alignmentPeriod = "60s"
                      perSeriesAligner = "ALIGN_RATE"
                    }
                  ]
                }
              }
            }
          ]
          xAxis = {
            label = "Time"
          }
          yAxis = {
            label = "CPU Utilization"
          }
        }
      },
      {
        title = "n8n Instance Memory Utilization"
        xyChart = {
          dataSets = [
            {
              timeSeriesQuery = {
                timeSeriesFilter = {
                  filter = "metric.type=\"compute.googleapis.com/instance/memory/usage\" AND resource.type=\"gce_instance\""
                  aggregations = [
                    {
                      alignmentPeriod = "60s"
                      perSeriesAligner = "ALIGN_RATE"
                    }
                  ]
                }
              }
            }
          ]
          xAxis = {
            label = "Time"
          }
          yAxis = {
            label = "Memory Utilization"
          }
        }
      }
    ]
  })
}