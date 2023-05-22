provider "vault" {
  address = var.vault_url
  auth_login_jwt {
    role      = var.vault_role
    namespace = var.vault_ns
    jwt       = var.auth_jwt
  }
}

resource "vault_policy" "policies" {

  for_each = { for v in jsondecode(file("conf/policies.json")).policies : v.name => v }
  name     = each.value.name
  policy   = each.value.policy

}

resource "vault_identity_group" "internal" {
  for_each = { for v in jsondecode(file("conf/groups.json")).group : v.name => v }
  name     = each.value.name
  type     = each.value.type
  policies = [each.value.policy]

  depends_on = [
    vault_policy.policies
  ]
}

resource "vault_identity_group_member_entity_ids" "test" {

  for_each          = { for v in jsondecode(file("conf/members.json")).members : v.member_entity_ids => v }
  member_entity_ids = [each.value.member_entity_ids]
  group_id          = vault_identity_group.internal[tostring(each.value.group_name)].id

  depends_on = [
    vault_identity_group.internal
  ]
}

resource "vault_mount" "kv_vaults" {
  for_each = { for v in jsondecode(file("conf/kv.json")).kv_vaults : v.name => v }

  path = each.value.name
  type = each.value.type

  depends_on = [
    vault_identity_group_member_entity_ids.test
  ]
}
#
