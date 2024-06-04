env                             = "dev"
location                        = "West Europe"
resource_grp_name               = "reservico-rg-001"
tags                            = { Environment = "Development" }

storage_account_name            = "resstgacc"
blob_storage_name               = "reservico-blob-storage"
vnet_name                       = "reservico-vnet"
vnet_subnet_name                = "reservico-subnet"
vnet_address_space              = ["10.224.0.0/12"]
vnet_address_prefixes           = ["10.224.0.0/16"]
kv_name                         = "reservico-kv"
public_ip_name                  = "reservico-public-ip"
nic_name                        = "reservico-nic"
nic_ip_config_name              = "reservico-nic-ip-config"
nsg_name                        = "reservico-nsg"
nsg_whitelisted_ip_addresses    = ["77.85.152.226"]
sql_server_name                 = "reservico"
sql_database_name               = "reservico"
sp_name                         = "reservico-sp"
uai_name                        = "reservico-uai"
wdnwa_name                      = "reservico-api"
wnjwa_bo_name                   = "reservico-backoffice"
wnjwa_front_name                = "reservico-frontoffice"
wnjwa_public_name               = "reservico-public"