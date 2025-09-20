// === DYNAMIC STAT CALCULATION ===
=== function update_combat_stats() ===
    // 1. Calculate BASE stats from attributes
    { character_name == "Kaelen":
        // The Soldier: Strength is key for attack and health.
        ~ max_hp = 15 + (strength * 2)
        ~ atk = 2 + strength
        ~ def = agility
    }
    { character_name == "Aris":
        // The Bio-Hacker: Intelligence drives his attack power.
        ~ max_hp = 12 + strength
        ~ atk = 1 + intelligence
        ~ def = agility + 1
    }
    { character_name == "Lena":
        // The Infiltrator: Agility makes her a fast hitter.
        ~ max_hp = 14 + strength
        ~ atk = 2 + agility
        ~ def = INT(perception / 2)
    }

    // 2. Apply BONUSES from equipped items
    { emitter_equipped:
        { studied_emitter:
            { character_name == "Aris":
                ~ atk += 4 // Aris gets the biggest bonus
            - else:
                ~ atk += 3 // Other characters get a good bonus
            }
        - else:
            ~ atk += 2 // Standard bonus if not studied
        }
    }
    { club_equipped:
        ~ atk += 2
    }
    { bow_equipped:
        ~ atk += 2 // A base bonus for now, can be changed later
    }
    // (Future equipment bonuses would go here)
    
    ~ return true

// === ITEM FUNCTIONS ===
=== function use_emitter_charge() ===
    { has_kinetic_emitter and emitter_charges > 0:
        ~ emitter_charges -= 1
        The Kinetic Field Emitter discharges with a powerful hum.
        { emitter_charges == 0:
            A final surge of power leaves the device inert, its internal mechanisms fused.
            It's broken for good.
        }
        ~ return true
    - else:
        ~ return false
    }
    
=== function display_status() ===
    -- Character Status --
    Name: {character_name}
    HP: {hp} / {max_hp}
    Attack: {atk}
    Defense: {def}
    
    -- Attributes --
    Strength: {strength}
    Intelligence: {intelligence}
    Agility: {agility}
    Perception: {perception}
    Resolve: {resolve}

    -- Condition --
    { is_injured:
        - INJURED
    }
    { is_fatigued:
        - FATIGUED
    }
    { not is_injured and not is_fatigued:
        - HEALTHY
    }
    
    -- Inventory --
    { power_cell_stack == 0 and glimmer_moss_stack == 0 and not has_kinetic_emitter and neuro_stim_state != "AVAILABLE" and not has_reinforced_club and not has_recurve_bow and not has_emp_grenade:
        - Your pockets are empty.
    }
    { power_cell_stack > 0: - Degraded Power Cell (x{power_cell_stack }) }
    { glimmer_moss_stack > 0: - Glimmer Moss Sample (x{glimmer_moss_stack}) }
    { has_kinetic_emitter: - Kinetic Field Emitter ({emitter_charges} charges) }
    { neuro_stim_state == "AVAILABLE": - Neuro-Stim - Single Use }
    { has_reinforced_club: - Reinforced Club }
    { has_recurve_bow: - Recurve Bow }
    { has_emp_grenade: - EMP Grenade (Single Use) }
    { has_metal_pipe: - Sturdy Metal Pipe }
    { has_thick_wiring: - Thick Wiring }
    { has_flexible_polymer: - Flexible Polymer }
    { has_tensile_cable: - High-Tensile Cable }
    { has_copper_wiring: - Copper Wiring }
    { has_skulker_venom_gland: - Skulker Venom Gland }
    { has_moss_poison_vial > 0:
        - Moss Poison Vial (x{has_moss_poison_vial})
    }
    { has_poison_bomb:
        - Poison Gas Bomb (Single Use)
    }
    { has_magnetic_coil: - Magnetic Coil }
    
    -- Logs & Intel --
    { not found_first_log:
        No intel recovered.
    }
    { found_first_log and not know_skulker_weakness:
        Archivist Log \#77-B (Encrypted)
    }
    { know_skulker_weakness:
        Intel: Skulkers are vulnerable to high-frequency sonics.
    }
    
=== check_status(-> return_to) ===
    ~ display_status()
    + [Return.]
        -> return_to

=== battle_loop ===
    // Display current status
    You have {hp} HP. The {current_enemy_name} has {current_enemy_hp} HP.
    
    + { emitter_equipped and emitter_charges > 0 } [Use Kinetic Emitter ({emitter_charges} left)]
        -> player_use_emitter
    + [Attack]
        -> player_attack
    + { not used_skill_in_battle } [Use Skill]
        -> battle_use_skill
    + { character_name == "Aris" and has_moss_poison_vial > 0 } [Use Moss Poison ({has_moss_poison_vial} left)]
        -> player_use_moss_poison
    + { character_name == "Aris" and has_poison_bomb } [Use Poison Bomb]
        -> player_use_poison_bomb
    + [Defend]
        ~ is_defending = true
        You brace for an attack, increasing your defense for this turn.
        -> enemy_turn
    * [Run Away]
        -> battle_fled

= player_use_moss_poison
    ~ has_moss_poison_vial -= 1
    You coat your weapon with the sticky, paralytic poison. The {current_enemy_name} is now poisoned!
    ~ enemy_is_poisoned = true
    ~ poison_turns_remaining = 3 // Poison lasts for 3 turns
    -> enemy_turn

= player_use_poison_bomb
    ~ has_poison_bomb = false
    You hurl the makeshift bomb. It shatters at the {current_enemy_name}'s feet, releasing a cloud of aerosolized neurotoxin. The creature shrieks, convulses, and then collapses, neutralized instantly.
    ~ current_enemy_hp = 0
    -> battle_won

=== battle_fled ===
You take a chance and disengage, turning to flee. The {current_enemy_name} lets out a cry of frustration but doesn't pursue.
~ resolve -= 5 // A small penalty for retreating

// Check which enemy you fled from to continue the story
{
    - current_enemy_name == "Slick-Skinned Skulker":
        You've escaped, but you've lost your chance to achieve your objective here.
        <i>AI: "Subject has disengaged. Data Fragment unretrievable."</i>
        -> scene_8_the_tower // Changed to point to the new Scene 8
    - current_enemy_name == "The Brute" or current_enemy_name == "The Tinkerer" or current_enemy_name == "The Veteran":
        You're forced back down the stairs, floor by floor, until you're back at the base of the communications spire. The contestant you fled from now holds the high ground, and there's no way back up. You've failed this test.
        -> scene_9_the_bargain // You are forced to find the next fragment elsewhere
    - else:
        // A default flee case for any other enemies
        You escape, but the opportunity is lost.
        -> scene_9_the_bargain
}

=== battle_use_skill ===
    ~ used_skill_in_battle = true
    { player_skills ? Survivalist: // Kaelen's Skill
        You roar, focusing your rage into a single, powerful strike. Your Attack is temporarily increased!
        ~ atk += 2
        -> player_attack // Go straight to the attack
    }
    { player_skills ? BioScan: // Aris's Skill
        You activate your bio-scanner, identifying a weak point in the creature's hide. Its Defense is lowered.
        ~ current_enemy_def -= 2
        { current_enemy_def < 0:
            ~ current_enemy_def = 0
        }
        -> enemy_turn // The skill use takes your turn
    }
    { player_skills ? DiscerningEye: // Lena's Skill
        You watch the creature's feral movements, predicting its lunge. You'll be able to easily dodge its next attack.
        ~ rival_will_miss_next_turn = true
        -> enemy_turn // The skill use takes your turn
    }

=== player_use_emitter ===
    { use_emitter_charge():
        // The function returned true, so the usage was successful.
        You unleash a wave of pure force from the emitter. It slams into the {current_enemy_name}, sending it reeling.
        ~ temp emitter_damage = 10 // Emitter deals a flat 10 damage
        ~ current_enemy_hp -= emitter_damage
    }
    
    { current_enemy_hp <= 0:
        -> battle_won
    - else:
        -> enemy_turn
    }

=== player_attack ===
    ~ temp player_damage = atk - current_enemy_def
    { player_damage < 1: 
        ~ player_damage = 1 
    }
    ~ current_enemy_hp -= player_damage
    
    You strike the {current_enemy_name} for {player_damage} damage.
    
    { current_enemy_hp <= 0:
        -> battle_won
    }
    
    -> enemy_turn

=== enemy_turn ===
    { rival_will_miss_next_turn:
        ~ rival_will_miss_next_turn = false
        You anticipate the enemy's clumsy attack and easily step aside. It misses completely.
        -> battle_loop
    - else:
    ~ temp current_def = def
    { is_defending:
         ~ current_def = def + 3
    }
    
    ~ temp enemy_damage = current_enemy_atk - current_def
    { enemy_damage < 1: 
        ~ enemy_damage = 1
    }
    ~ hp -= enemy_damage
    
    The {current_enemy_name} attacks you for {enemy_damage} damage.
    
    // Reset defending state for the next turn
    ~ is_defending = false
    
    { hp <= 0:
        -> battle_lost
    - else:
        -> battle_loop
    }
    }

=== battle_won ===
The {current_enemy_name} collapses. You are victorious.
// Check if Aris can loot the creature
{ character_name == "Aris" and current_enemy_name == "Slick-Skinned Skulker":
    -> loot_skulker
}

// Check which enemy was defeated to continue the correct story path
{ 
- current_enemy_name == "Slick-Skinned Skulker":
    -> skulker_win
- current_enemy_name == "The Brute":
        You step over the unconscious form of the Brute and head for the stairs.
        -> tower_floor_3
    - current_enemy_name == "The Tinkerer":
        The Tinkerer's device sputters and dies, and they surrender immediately. You move to the next floor.
        -> tower_floor_5
    - current_enemy_name == "The Veteran":
        The Veteran gives a single, respectful nod as they fall back, defeated. The path to the top is clear.
        -> tower_top
- else:
    // A default win case, in case you add other battles
    -> END
}

=== skulker_defeated_hub ===
// This is the new central hub for when the Skulker is defeated.
// First, check if Aris can loot the creature.
{ character_name == "Aris":
    -> loot_skulker
}
// If not Aris, or after looting, proceed to the standard win scene.
-> skulker_win

=== loot_skulker ===
    As the Skulker lies defeated, your bio-scanner detects a potent neurotoxin still active in its venom glands.
    * [Harvest the Venom Gland]
        You carefully extract the gland, a pulsating sac of green fluid. This could be a powerful ingredient.
        ~ has_skulker_venom_gland = true
    * [Leave it.]
        // Do nothing
- The path to the terminal is clear.
-> skulker_win

=== battle_lost ===
// Check which enemy defeated you
{ 
- current_enemy_name == "Slick-Skinned Skulker":
Your vision fades to black as the creature's final blow lands.
    -> scene_6c_skulker_lair
- current_enemy_name == "The Brute" or current_enemy_name == "The Tinkerer" or current_enemy_name == "The Veteran":
Your vision fades to black as the opponent's final blow lands.
        -> game_over_death
- else:
    // A default lose case
    -> END
}

=== skulker_win ===
    You download the **first Data Fragment**.
    ~ data_fragments += 1
    -> scene_7_the_fragment

=== skulker_lose ===
    You have been defeated by the Skulker.
    -> END

// === GAME OVER SCENES ===
=== game_over_death ===
Your vision fades to black as the final blow lands. The last thing you hear is the AI's detached voice in your mind.
<i>AI: "Subject's vital signs have ceased. Test failed."</i>
-> END
