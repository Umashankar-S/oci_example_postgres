# oci_example_postgres
This respositry is  to help  deploy  Oracle Postgres SQL services on Oracle cloud Infrastructre (OCI) .

This code would deploy  following components :
   1. Oracle  Virtual Cloud Network  (VCN) wth a Private Subnet 
   2. OCI Postgres SQL service using the Private subnet
   3. OCI  KMS Vault,Key,Secret ( for psql admin password )

  You can control the  creation of VCN/Subnets and pass a existing private subnet ID as well.
  As of now the Code creates OCI KMS Secrets to store the psql admin password and it can be retrived from secret post creation .
  Postgres SQL instance gets created with replicas if the inst-count  > 1 .
  Currently the Instance shapes are limited to AMD  with OCPUs 2,4,8,16,32,64 and Memory = > #OCPU  * 16
