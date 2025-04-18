
## Get ROSA HCP AWS managed polices in json format
./export-rosa-managed-policies.sh

## Create ROSA HCP user managed polices from the AWS managed policy json files.
./create-policies-from-dir.sh
