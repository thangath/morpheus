provider "vsphere" {
  user                 = "terraform@hpe.vsp"
  password             = "Password!234"
  vsphere_server       = "172.16.10.10"
  allow_unverified_ssl  = true
  api_timeout          = 10
}

data "vsphere_datacenter" "datacenter" {
  name = "Primary-DC"
}

data "vsphere_datastore" "datastore" {
  name          = "HPEP-Mgt-3DS01"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = "HPE-PM-Cls01"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_network" "network" {
  name          = "v2201"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_virtual_machine" "template" {
  name          = "RHEL9.5-Morpheus-VMWare-Img"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}
resource "vsphere_virtual_machine" "vm" {
  name             = "test002"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  num_cpus         = 2
  memory           = 4096
  guest_id         = data.vsphere_virtual_machine.template.guest_id
  scsi_type        = data.vsphere_virtual_machine.template.scsi_type
  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }
clone {
    template_uuid = data.vsphere_virtual_machine.template.id
      }
  }
}
  disk {
    label = "disk0"
    size  = 50
  }
}
