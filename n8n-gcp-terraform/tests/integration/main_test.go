package integration

import (
	"testing"

	"github.com/hashicorp/terraform-plugin-sdk/v2/helper/resource"
	"github.com/hashicorp/terraform-plugin-sdk/v2/terraform"
)

func TestAccN8nDeployment(t *testing.T) {
	resourceName := "module.n8n-deployment"

	resource.Test(t, resource.TestCase{
		PreCheck:  func() { /* Add any pre-checks here */ },
		Steps: []resource.TestStep{
			{
				Config: testAccN8nConfig(),
				Check: resource.ComposeAggregateTestCheckFunc(
					resource.TestCheckResourceAttr(resourceName, "status", "RUNNING"),
					resource.TestCheckResourceAttr(resourceName, "url", "https://your-n8n-instance-url"),
				),
			},
			{
				ResourceName: resourceName,
				ImportState:  true,
				ImportStateId: "your-n8n-instance-id",
				ImportStateCheck: resource.ImportStateCheck{
					Attributes: map[string]string{
						"status": "RUNNING",
					},
				},
			},
		},
	})
}

func testAccN8nConfig() string {
	return `
module "n8n-deployment" {
  source = "../modules/compute/cloud-run"
  # Add necessary variables here
}
`
}