echo "Grabbing ldap accessors ..."
UM_ACCESS=$(vault auth list -format=json | jq -r '.["ldap-um/"].accessor')
MO_ACCESS=$(vault auth list -format=json | jq -r '.["ldap-mo/"].accessor')

echo "Done \n"
echo "Creating kv-user-template..."
cat > ../policy/kv-user-template-policy.hcl << EOF
# Allow full access to the current version of the kv-blog
path "kv-blog/data/{{identity.entity.aliases.${UM_ACCESS}.name}}/*"
{
  capabilities = ["create", "read", "update", "delete", "list"]
}
path "kv-blog/data/{{identity.entity.aliases.${UM_ACCESS}.name}}"
{
  capabilities = ["create", "read", "update", "delete", "list"]
}
# Allow deletion of any kv-blog version
path "kv-blog/delete/{{identity.entity.aliases.${UM_ACCESS}.name}}/*"
{
  capabilities = ["update"]
}
path "kv-blog/delete/{{identity.entity.aliases.${UM_ACCESS}.name}}"
{
  capabilities = ["update"]
}
# Allow un-deletion of any kv-blog version
path "kv-blog/undelete/{{identity.entity.aliases.${UM_ACCESS}.name}}/*"
{
  capabilities = ["update"]
}
path "kv-blog/undelete/{{identity.entity.aliases.${UM_ACCESS}.name}}"
{
  capabilities = ["update"]
}
# Allow destroy of any kv-blog version
path "kv-blog/destroy/{{identity.entity.aliases.${UM_ACCESS}.name}}/*"
{
  capabilities = ["update"]
}
path "kv-blog/destroy/{{identity.entity.aliases.${UM_ACCESS}.name}}"
{
  capabilities = ["update"]
}
# Allow list and view of metadata and to delete all versions and metadata for a key
path "kv-blog/metadata/{{identity.entity.aliases.${UM_ACCESS}.name}}/*"
{
  capabilities = ["list", "read", "delete"]
}
path "kv-blog/metadata/{{identity.entity.aliases.${UM_ACCESS}.name}}"
{
  capabilities = ["list", "read", "delete"]
}
# Allow full access to the current version of the kv-blog
path "kv-blog/data/{{identity.entity.aliases.${MO_ACCESS}.name}}/*"
{
  capabilities = ["create", "read", "update", "delete", "list"]
}
path "kv-blog/data/{{identity.entity.aliases.${MO_ACCESS}.name}}"
{
  capabilities = ["create", "read", "update", "delete", "list"]
}
# Allow deletion of any kv-blog version
path "kv-blog/delete/{{identity.entity.aliases.${MO_ACCESS}.name}}/*"
{
  capabilities = ["update"]
}
path "kv-blog/delete/{{identity.entity.aliases.${MO_ACCESS}.name}}"
{
  capabilities = ["update"]
}
# Allow un-deletion of any kv-blog version
path "kv-blog/undelete/{{identity.entity.aliases.${MO_ACCESS}.name}}/*"
{
  capabilities = ["update"]
}
path "kv-blog/undelete/{{identity.entity.aliases.${MO_ACCESS}.name}}"
{
  capabilities = ["update"]
}
# Allow destroy of any kv-blog version
path "kv-blog/destroy/{{identity.entity.aliases.${MO_ACCESS}.name}}/*"
{
  capabilities = ["update"]
}
path "kv-blog/destroy/{{identity.entity.aliases.${MO_ACCESS}.name}}"
{
  capabilities = ["update"]
}
# Allow list and view of metadata and to delete all versions and metadata for a key
path "kv-blog/metadata/{{identity.entity.aliases.${MO_ACCESS}.name}}/*"
{
  capabilities = ["list", "read", "delete"]
}
path "kv-blog/metadata/{{identity.entity.aliases.${MO_ACCESS}.name}}"
{
  capabilities = ["list", "read", "delete"]
}
EOF
echo "Done \n"