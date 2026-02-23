# oci_example_postgres

## PostgreSQL DB system Stack 
This respositry is to help  deploy  Oracle Postgres SQL services on Oracle cloud Infrastructre (OCI) .

This stack would deploy  PotgreSQL DB system with  following components :
   1. Oracle  Virtual Cloud Network  (VCN) wth a Private Subnet [ optional :  can use existing network resources VCN/subnet]
   2. OCI PostgreSQL  using the  Private subnet 
   3. OCI KMS Vault,Key,Secret ( for psql admin password ) or Plain Text password without Vault 

 - You can control the  creation of VCN/Subnets and pass a existing private subnet ID as well.
  
 - You can control the  creation of Vaults and use existing Vault for OCI KMS Secrets to store the psql admin password (use_vault = true and/or create_vault = true ) or totally use Plain Text mode without Vaults . (use_vault = false)
  
 - Postgres SQL instance gets created with replicas only if the Node Count  > 1 .

 - Use of Flex or Fixed shapes AMD ( E5 ) / Intel (Standardv3 ) & Flex Shapes AMD ( E5, E6) / Intel (Standardv3)


## Deploy to Oracle Cloud : 

Click [![Deploy to Oracle Cloud](https://oci-resourcemanager-plugin.plugins.oci.oraclecloud.com/latest/deploy-to-oracle-cloud.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?region=home&zipUrl=https://github.com/Umashankar-S/oci_example_postgres/archive/refs/heads/main.zip)


If you aren't already signed in, when prompted, enter the tenancy and user credentials.

## Known Issues: 

    1. The OCI KMS Vault/Key creation can fail  with below error :

  Error: Post "https://xyzxyzxzyxy-management.kms.us-ashburn-1.oraclecloud.com/20180608/keys": dial tcp: lookup xyzxyzxzyxy-management.kms.us-ashburn-1.oraclecloud.com on 169.254.169.254:53: no such host

  Workaround  :   Upon retry couple of times , the operation succeeds .
