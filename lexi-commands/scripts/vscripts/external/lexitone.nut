function main() {
    if (IsLobby()){
        return
    }
    AddCallback_PlayerOrNPCKilled(OnPlayerOrNPCKilled)
}

function OnPlayerOrNPCKilled( victim, attacker, damageInfo ) {
    if ((!victim.IsPlayer() && !attacker.IsPlayer() && !attacker.GetBossPlayer() && !victim.GetBossPlayer())  || GetGameState() != eGameState.Playing  ) {
        return
    }
    local values = {}
    values["game_mode"] <- GameRules.GetGameMode()
    values["map"] <- GetMapName()
    values["game_time"] <- Time()
    local attackerPos = attacker.GetOrigin()
    local victimPos = victim.GetOrigin()

    if (attacker.IsPlayer()) {
        values["attacker_name"] <- attacker.GetPlayerName()
        values["attacker_id"] <- attacker.GetUID()
        values["attacker_entid"] <- attacker.GetEntIndex()
        values["attacker_titan"] <- GetTitan(attacker)
    }
    else if (attacker.GetBossPlayer()) {
        local boss = attacker.GetBossPlayer()
        values["attacker_name"] <- boss.GetPlayerName()
        values["attacker_id"] <- boss.GetUID()
        values["attacker_entid"] <- attacker.GetEntIndex()
        values["attacker_titan"] <- GetTitan(attacker)
    }
    if (victim.IsPlayer()) {
        values["victim_name"] <- victim.GetPlayerName()
        values["victim_id"] <- victim.GetUID()
        values["victim_entid"] <- victim.GetEntIndex()
        values["victim_titan"] <- GetTitan(victim)
    }
    else if( victim.GetBossPlayer()) {
        local boss = victim.GetBossPlayer()
        values["victim_name"] <- boss.GetPlayerName()
        values["victim_id"] <- boss.GetUID()
        values["victim_entid"] <- victim.GetEntIndex()
        values["victim_titan"] <- GetTitan(victim)
    }
     if (attacker.IsPlayer() || attacker.IsNPC()) {
        local attackerWeapons = attacker.GetMainWeapons()
        local attackerOffhandWeapons = attacker.GetOffhandWeapons()

        foreach( i,weapon in attackerWeapons ) {
            if (weapon != null) {
                values["attacker_weapon_" + i] <- weapon.GetClassname()
            }
        }
        foreach( i,weapon in attackerOffhandWeapons ) {
            if (weapon != null) {
                values["attacker_offhand_weapon_" + i] <- weapon.GetClassname()
            }
        }
        if (attacker.GetActiveWeapon()) {
        values["attacker_current_weapon"] <- attacker.GetActiveWeapon().GetClassname()}
     }

    if (victim.IsPlayer() || victim.IsNPC()) {
        local victimWeapons = victim.GetMainWeapons()
        local victimOffhandWeapons = victim.GetOffhandWeapons()

        foreach( i,weapon in victimWeapons ) {
            if (weapon != null) {
                values["victim_weapon_" + i] <- weapon.GetClassname()
            }
        }
        foreach( i,weapon in victimOffhandWeapons ) {
            if (weapon != null) {
                values["victim_offhand_weapon_" + i] <- weapon.GetClassname()
            }
        }

        if (victim.GetActiveWeapon()) {
        values["victim_current_weapon"] <- victim.GetActiveWeapon().GetClassname()}
    }

    values["victim_x"] <- victimPos.x
    values["victim_y"] <- victimPos.y
    values["victim_z"] <- victimPos.z

    values["attacker_x"] <- attackerPos.x
    values["attacker_y"] <- attackerPos.y
    values["attacker_z"] <- attackerPos.z
    values["timeofkill"] <- GetUnixTimestamp()
    values["match_id"] <- Lgetmatchid()
    values["victim_type"] <- victim.GetClassname()
    values["attacker_type"] <-attacker.GetClassname()

    local damageId = 
    values["cause_of_death"] <- GetNameFromDamageSourceID(damageInfo.GetDamageSourceIdentifier())
    local mods = GetWeaponModsFromDamageInfo(damageInfo)
    if (mods.len() > 0){
        
    values["modsused"] <- mods
    }
    local distance = Distance(attacker.GetOrigin(), victim.GetOrigin())
    values["distance"] <- distance
    // PrintTable(values)
    Laddusedcommandtotablev2(values,"killstat")
} 

function GetTitan(player) {
    if(!player.IsPlayer()) 
        return "null"
    if(player.GetPetTitan() != null) {
        local titan = player.GetPetTitan()
        if(!IsValid(titan)) {
            return "null"
        }
        if(titan.GetTitanSoul() == null) {
            return "null"
        }
        return GetSoulTitanType(titan.GetTitanSoul())
    }
    else if (player.IsTitan()) {
        if(player.GetTitanSoul() == null) {
            return "null"
        }
        return GetSoulTitanType(player.GetTitanSoul())
    }
    return "null"
}
