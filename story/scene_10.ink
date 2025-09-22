=== lair_horde_battle ===
You must fight your way through the horde to reach the Alpha's platform. The smaller creatures are a chaotic mess, but one larger, more heavily scarred Skulker stands between you and the final confrontation. It snarls, ready to defend its master's nest.
-> setup_skulker_guard_battle

= setup_skulker_guard_battle
    // Set up stats for the Skulker Guard mini-boss
    ~ current_enemy_name = "Skulker Guard"
    ~ current_enemy_hp = 40
    ~ current_enemy_atk = 9
    ~ current_enemy_def = 3
    // Reset battle state flags
    ~ used_skill_in_battle = false
    ~ rival_will_miss_next_turn = false
    ~ enemy_is_poisoned = false
    ~ poison_turns_remaining = 0
    ~ is_overcharging = false
    ~ is_countering = false
    -> battle_loop

=== setup_alpha_skulker_battle ===
You, your Rival, Jed, and two other skilled-looking contestants are the first to reach the platform. The Alpha Skulker Matriarch emerges from the derelict train car. It is immense, covered in glowing green scars, and it lets out a shriek that shakes the very foundations of the cavern. The final battle begins.
~ alpha_skulker_max_hp = 150
~ alpha_skulker_hp = 150
~ alpha_skulker_atk = 10
~ alpha_skulker_def = 5
~ alpha_is_berserk = false
// Reset contribution scores
~ player_contribution = 0
~ rival_contribution = 0
~ jed_contribution = 0
~ ally_3_contribution = 0
~ ally_4_contribution = 0
-> alpha_skulker_battle_loop

=== setup_two_skulker_battle ===
    // Setup for Skulker 1
    ~ current_enemy_name = "Skulker Packmate"
    ~ current_enemy_hp = 20
    ~ current_enemy_atk = 6
    ~ current_enemy_def = 3
    // Setup for Skulker 2
    ~ enemy2_name = "Skulker Packmate"
    ~ enemy2_hp = 20
    ~ enemy2_atk = 6
    ~ enemy2_def = 3
    // Setup for Jed
    ~ jed_hp = jed_max_hp
    -> two_v_two_battle_loop

=== alpha_skulker_battle_loop ===
    // --- BERSERK CHECK ---
    { alpha_skulker_hp <= alpha_skulker_max_hp / 10 and not alpha_is_berserk:
        ~ alpha_is_berserk = true
        ~ alpha_skulker_atk = 15 // High damage
        ~ alpha_skulker_def = 2  // Low defense
        The Matriarch shrieks in agony and rage, its glowing scars flaring violently. It's gone berserk!
    }
    
    The Alpha Skulker is at {alpha_skulker_hp}/{alpha_skulker_max_hp} HP. You are at {hp}/{max_hp} HP.
    
    // --- RIVAL EVENT CHECK ---
    { rival_is_in_danger:
        -> rival_in_danger_event
    }

    * [Attack]
        ~ temp damage = atk - alpha_skulker_def
        { damage < 1: 
            ~ damage = 1
        }
        ~ alpha_skulker_hp -= damage
        ~ player_contribution += damage
        You strike the Matriarch for {damage} damage!
        -> allies_turn
    * [Use Skill]
        // Simplified skill use for this fight
        You use your skills to find an opening, dealing extra damage!
        ~ temp damage2 = atk + 5 - alpha_skulker_def
        { damage2 < 1: 
            ~ damage2 = 1
        }
        ~ alpha_skulker_hp -= damage2
        ~ player_contribution += damage2
        -> allies_turn
        
= allies_turn
    // Jed's Turn
    { jed_status == "HOSTILE":
        Jed hangs back, taking pot-shots and contributing little.
        ~ jed_contribution += 2
        ~ alpha_skulker_hp -= 2
    - else:
        Jed fights beside you, a seasoned veteran. He lands a solid blow.
        ~ jed_contribution += 5
        ~ alpha_skulker_hp -= 5
    }
    // Rival's Turn
    Your Rival fights with brutal efficiency, scoring a deep hit.
    ~ temp rival_damage = RANDOM(6, 10)
    ~ rival_contribution += rival_damage
    ~ alpha_skulker_hp -= rival_damage
    // Other Allies' Turns
    The other two contestants land their own attacks.
    ~ ally_3_contribution += 4
    ~ ally_4_contribution += 4
    ~ alpha_skulker_hp -= 8
    
    { alpha_skulker_hp <= 0:
        -> alpha_skulker_defeated
    - else:
        -> alpha_skulker_turn
    }

= alpha_skulker_turn
    The Matriarch screeches and attacks!
    ~ temp target_roll = RANDOM(1, 10)
    { target_roll <= 2:
        // AOE Attack
        It unleashes a deafening sonic screech that hits everyone on the platform!
        ~ hp -= 5
        You take 5 damage from the sonic blast!
    - else:
        // Single Target Attack
        It lunges at you, claws flashing!
        ~ temp damage3 = alpha_skulker_atk - def
        { damage3 < 1: 
            ~ damage3 = 1
        }
        ~ hp -= damage3
        You take {damage3} damage!
    }
    
    // Check for player death
    { hp <= 0:
        -> game_over_death
    }
    
    // Random chance for the rival event to trigger
    ~ temp event_roll = RANDOM(1, 4)
    { event_roll == 1 and not rival_is_in_danger:
        ~ rival_is_in_danger = true
    }
    
    -> alpha_skulker_battle_loop

= rival_in_danger_event
    The Matriarch turns its attention, pinning your Rival against the derelict train car. They're trapped and vulnerable! This is your chance.
    * [Support your Rival]
        You fire a shot or create a diversion, drawing the Matriarch's attention away from them. Your Rival gives you a surprised, grudging look of acknowledgement.
        ~ rival_is_in_danger = false
        -> alpha_skulker_turn
    * [Sabotage your Rival]
        You "accidentally" kick a piece of debris in their way, causing them to stumble. The Matriarch's claws rake across their side, wounding them badly. They glare at you with pure hatred.
        ~ rival_contribution -= 10 // Penalty to their score
        ~ rival_is_in_danger = false
        -> alpha_skulker_turn
    * [Do nothing]
        You watch, impassive, as your Rival barely manages to fend off the attack on their own. They are wounded and exhausted from the effort.
        ~ rival_is_in_danger = false
        -> alpha_skulker_turn

= alpha_skulker_defeated
With a final, agonized shriek, the Alpha Skulker Matriarch collapses. The cavern falls silent.
<i>PROCTOR: "Apex Predator neutralized. Calculating contributions."</i>
<i>PROCTOR: "The following subjects have earned the final Data Fragment: Subject {character_name}, Subject {rival_name}, Subject Jedediah..."</i>

You have succeeded.
-> END