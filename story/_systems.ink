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
        { club_is_upgraded:
            ~ atk += 1 // The upgrade adds an extra +1 attack
        }
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
    
    -- Skills --
    { player_skills:
        {player_skills}
    - else:
        No skills learned.
    }
    
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
    { has_reinforced_club:
        - Reinforced Club {club_is_upgraded:(Upgraded)}
    }
    { has_recurve_bow: - Recurve Bow }
    { has_emp_grenade: - EMP Grenade (Single Use) }
    { has_metal_pipe: - Sturdy Metal Pipe }
    { has_thick_wiring: - Thick Wiring }
    { has_flexible_polymer: - Flexible Polymer }
    { has_tensile_cable: - High-Tensile Cable }
    { has_copper_wiring: - Copper Wiring }
    { skulker_venom_gland_stack > 0: - Skulker Venom Gland (x{skulker_venom_gland_stack}) }
    { has_moss_poison_vial > 0:
        - Moss Poison Vial (x{has_moss_poison_vial})
    }
    { has_poison_bomb:
        - Poison Gas Bomb (Single Use)
    }
    { has_club_upgrade_kit: - Club Upgrade Kit }
    { knows_calming_poultice_recipe: - Recipe: Calming Poultice }
    { silent_arrow_count > 0: - Silent Arrows (x{silent_arrow_count}) }
    { scrap_arrow_count > 0: - Scrap Arrows (x{scrap_arrow_count}) }
    { shock_arrow_count > 0: - Shock Arrows (x{shock_arrow_count}) }
    { has_titan_beetle_carapace: - Titan-Beetle Carapace }
    { has_adrenaline_shot: - Adrenaline Shot (Single Use) }
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

// === BATTLE MECHANIC (UNIFIED) ===
=== battle_loop ===
    // --- STATUS DISPLAY ---
    You have {hp}/{max_hp} HP.
    { jed_status == "HELPED" and jed_hp > 0:
        Jed has {jed_hp}/{jed_max_hp} HP.
    }
    The {current_enemy_name} has {current_enemy_hp} HP.
    { enemy2_hp > 0:
        The {enemy2_name} has {enemy2_hp} HP.
    }
    
    // --- PLAYER'S TURN ---
    + { current_enemy_hp > 0 and enemy2_hp > 0 } [Attack the first {current_enemy_name}]
        -> player_attack(-> jed_turn, false)
    + { current_enemy_hp > 0 and enemy2_hp > 0 } [Attack the second {enemy2_name}]
        -> player_attack(-> jed_turn, true)
    + { current_enemy_hp > 0 and enemy2_hp <= 0 } [Attack the {current_enemy_name}]
        -> player_attack(-> jed_turn, false)
        
    + [Defend]
        ~ is_defending = true
        You brace for an attack, increasing your defense for this turn.
        -> jed_turn

    + { emitter_equipped and emitter_charges > 0 } [Use Kinetic Emitter ({emitter_charges} left)]
        -> player_use_emitter
    + { not used_skill_in_battle } [Use Skill]
        -> battle_use_skill
    + { character_name == "Aris" and has_moss_poison_vial > 0 } [Use Moss Poison ({has_moss_poison_vial} left)]
        -> player_use_moss_poison
    + { character_name == "Aris" and has_poison_bomb } [Use Poison Bomb]
        -> player_use_poison_bomb
    + { character_name == "Aris" and has_emp_grenade } [Use EMP Grenade]
        -> player_use_emp_grenade
    + { character_name == "Lena" and scrap_arrow_count > 0 } [Fire a Scrap Arrow ({scrap_arrow_count} left)]
        -> player_fire_scrap_arrow
    + { character_name == "Lena" and silent_arrow_count > 0 } [Fire a Silent Arrow ({silent_arrow_count} left)]
        -> player_fire_silent_arrow
    + { character_name == "Lena" and shock_arrow_count > 0 } [Fire a Shock Arrow ({shock_arrow_count} left)]
        -> player_fire_shock_arrow
        
    + [Run Away]
        -> battle_fled

=== player_attack(-> return_point, is_second_enemy) ===
    // This stitch now handles targeting for both 1v1 and 2v2
    ~ temp target_hp = 0
    ~ temp target_def = 0
    ~ temp target_name = ""
    { is_second_enemy:
        ~ target_hp = enemy2_hp
        ~ target_def = enemy2_def
        ~ target_name = enemy2_name
    - else:
        ~ target_hp = current_enemy_hp
        ~ target_def = current_enemy_def
        ~ target_name = current_enemy_name
    }
    
    ~ temp damage = atk - target_def
    { damage < 1: 
    ~ damage = 1 
    }
    ~ target_hp -= damage
    
    { is_second_enemy:
        ~ enemy2_hp = target_hp
    - else:
        ~ current_enemy_hp = target_hp
    }
    You attack the {target_name} for {damage} damage!
    -> return_point


== player_fire_shock_arrow
    ~ shock_arrow_count -= 1
    The arrow crackles with stored energy as you loose it. It hits the {current_enemy_name} with a shower of sparks, delivering a powerful electric shock.
    ~ temp arrow_damage = 12 // High damage
    ~ current_enemy_hp -= arrow_damage
    { current_enemy_hp <= 0:
        -> battle_won
    - else:
        -> enemy_turn
    }

== player_fire_scrap_arrow
    ~ scrap_arrow_count -= 1
    You loose a crudely made arrow. It flies true, striking the {current_enemy_name} for moderate damage.
    ~ temp arrow_damage = 5
    ~ current_enemy_hp -= arrow_damage
    { current_enemy_hp <= 0:
        -> battle_won
    - else:
        -> enemy_turn
    }

== player_fire_silent_arrow
    ~ silent_arrow_count -= 1
    The silent arrow whispers through the air, finding a weak point in the {current_enemy_name}'s defense. A critical hit!
    ~ temp arrow_damage = 9
    ~ current_enemy_hp -= arrow_damage
    { current_enemy_hp <= 0:
        -> battle_won
    - else:
        -> enemy_turn
    }

== player_use_moss_poison
    ~ has_moss_poison_vial -= 1
    You coat your weapon with the sticky, paralytic poison. The {current_enemy_name} is now poisoned!
    ~ enemy_is_poisoned = true
    ~ poison_turns_remaining = 3 // Poison lasts for 3 turns
    -> enemy_turn

== player_use_poison_bomb
    ~ has_poison_bomb = false
    The bomb shatters, releasing a cloud of aerosolized neurotoxin that engulfs all enemies!
    ~ temp bomb_damage = atk * 3
    
    The {current_enemy_name} takes {bomb_damage} initial damage!
    ~ current_enemy_hp -= bomb_damage
    { enemy2_hp > 0:
        The {enemy2_name} also takes {bomb_damage} initial damage!
        ~ enemy2_hp -= bomb_damage
    }
    
    // Apply poison to all enemies
    ~ enemy_is_poisoned = true
    ~ poison_turns_remaining = 5
    
    { current_enemy_hp <= 0 and enemy2_hp <= 0:
        -> battle_won
    - else:
        -> jed_turn
    }

== player_use_emp_grenade
    ~ has_emp_grenade = false
    You hurl the jury-rigged power cell. It detonates with a sharp crackle and a flash of blue light, releasing a powerful electromagnetic pulse. The {current_enemy_name} seizes up, disoriented by the assault on its nervous system. It will be stunned for its next turn.
    ~ rival_will_miss_next_turn = true
    { enemy2_hp > 0:
        ~ enemy2_will_miss_next_turn = true
    }
    -> enemy_turn

=== battle_fled ===
~ used_skill_in_battle = false
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
        -> player_attack(-> jed_turn, false)
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
    // --- NEWLY LEARNED SKILLS ---
    * { player_skills ? HeavyHitter } [Use Heavy Hitter]
        You channel all your strength into a single, devastating blow. It's slow, but powerful.
        ~ temp heavy_damage = INT(atk * 1.5)
        ~ current_enemy_hp -= heavy_damage
        You slam the {current_enemy_name} for {heavy_damage} damage!
        { current_enemy_hp <= 0:
            -> battle_won
        - else:
            -> enemy_turn
        }

    * { player_skills ? Overcharge } [Use Overcharge]
        You reroute power through the Kinetic Emitter, preparing to unleash an overloaded blast. Your next Emitter use will be massively amplified.
        ~ is_overcharging = true
        -> enemy_turn

    * { player_skills ? CounterAttack } [Prepare to Counter Attack]
        You take a defensive stance, watching your enemy's every move, ready to strike the moment they commit to an attack.
        ~ is_countering = true
        -> enemy_turn

=== player_use_emitter ===
    { use_emitter_charge():
        // The function returned true, so the usage was successful.
        You unleash a wave of pure force from the emitter. It slams into the {current_enemy_name}, sending it reeling.
        ~ temp emitter_damage = 15 // Emitter deals a flat 10 damage
        { is_overcharging:
            ~ emitter_damage = 30 // Overcharge boosts damage to 25
            ~ is_overcharging = false
            The Emitter shrieks as it discharges the excess energy.
        }
        ~ current_enemy_hp -= emitter_damage
    }
    
    { current_enemy_hp <= 0:
        -> battle_won
    - else:
        -> enemy_turn
    }

== enemy_turn
    { rival_will_miss_next_turn:
        ~ rival_will_miss_next_turn = false
        You anticipate the enemy's clumsy attack and easily step aside. It misses completely.
        -> battle_loop
    - else:
        // --- Calculate player's current defense for this turn ---
        ~ temp current_player_def = def
        { is_defending:
            ~ current_player_def = def + 3 // Apply defense bonus
        }
    
        // --- Enemy 1's Turn ---
        { current_enemy_hp > 0:
            The first {current_enemy_name} attacks!
            // If Jed is an ally, the enemy might target him
            { jed_status == "HELPED" and jed_hp > 0:
                ~ temp target_roll = RANDOM(1, 2)
                {
                    - target_roll == 1:
                        // Target Player
                        ~ temp damage = current_enemy_atk - current_player_def
                        { damage < 1: 
                            ~ damage = 1 
                        }
                        ~ hp -= damage
                        It hits you for {damage} damage!
                    - else:
                        // Target Jed
                        ~ temp damage3 = current_enemy_atk - jed_def
                        { damage3 < 1: 
                            ~ damage3 = 1 
                        }
                        ~ jed_hp -= damage3
                        It hits Jed for {damage3} damage!
                }
            - else:
                // If Jed is not an ally, always target player
                ~ temp damage4 = current_enemy_atk - current_player_def
                { damage4 < 1: 
                    ~ damage4 = 1 
                }
                ~ hp -= damage4
                It hits you for {damage4} damage!
            }
        }
    
        // --- Enemy 2's Turn ---
        { enemy2_hp > 0:
            The second {enemy2_name} attacks!
            // Same targeting logic as Enemy 1
            { jed_status == "HELPED" and jed_hp > 0:
                ~ temp target_roll2 = RANDOM(1, 2)
                {
                    - target_roll2 == 1:
                        // Target Player
                        ~ temp damage5 = enemy2_atk - current_player_def
                        { damage5 < 1: 
                            ~ damage5 = 1 
                        }
                        ~ hp -= damage5
                        It hits you for {damage5} damage!
                    - else:
                        // Target Jed
                        ~ temp damage2 = enemy2_atk - jed_def
                        { damage2 < 1: 
                            ~ damage2 = 1 
                        }
                        ~ jed_hp -= damage2
                        It hits Jed for {damage2} damage!
                }
            - else:
                // If Jed is not an ally, always target player
                ~ temp damage6 = enemy2_atk - current_player_def
                { damage6 < 1: 
                    ~ damage6 = 1 
                }
                ~ hp -= damage6
                It hits you for {damage6} damage!
            }
        }
        
        // --- Counter Attack Logic ---
        { is_countering:
            ~ is_countering = false
            As the enemy strikes, you pivot and deliver a vicious counter blow!
            ~ temp counter_damage = INT(atk * 0.75)
            You counter for {counter_damage} damage!
            // Target the healthier enemy
            { current_enemy_hp > enemy2_hp:
                ~ current_enemy_hp -= counter_damage
            - else:
                ~ enemy2_hp -= counter_damage
            }
            { current_enemy_hp <= 0 and (enemy2_hp <= 0 or enemy2_name == ""):
                -> battle_won
            }
        }
    
        // --- Post-Turn Cleanup and Checks ---
        ~ is_defending = false // Reset defense state for the next turn
    
        // Check for defeat states
        { hp <= 0: 
            -> game_over_death 
        }
        { jed_hp <= 0 and jed_status != "DEAD":
            The creature lands a fatal blow on Jed. He collapses to the ground, his weapon clattering on the metal floor. He's gone.
            ~ jed_status = "DEAD" 
        }
        
        // Check for victory
        { current_enemy_hp <= 0 and (enemy2_hp <= 0 or enemy2_name == ""):
            -> battle_won
        - else:
            -> battle_loop
        }
    }

=== battle_won ===
~ used_skill_in_battle = false

// Check HP to determine condition after the fight
{
    - hp <= max_hp / 4: // If HP is at 25% or less
        ~ is_injured = true
        ~ is_fatigued = false
        You are badly wounded from the fight.
    - hp <= max_hp / 2: // If HP is at 50% or less
        ~ is_injured = false
        ~ is_fatigued = true
        The fight has left you bruised and exhausted.
    - else:
        ~ is_injured = false
        ~ is_fatigued = false
}

The {current_enemy_name} collapses. You are victorious.

// --- LEARN NEW SKILL ---
// Check for specific character vs. enemy matchups to learn a new skill.
{
    - character_name == "Kaelen" and current_enemy_name == "The Brute" and not (player_skills ? HeavyHitter):
        ~ player_skills += HeavyHitter
        Watching the Brute fight, you learned something about raw, unrestrained power. You've learned the **Heavy Hitter** skill!
        <i>AI: "Subject Kaelen has adapted to superior physical force by mimicking it. A predictable, yet effective, development."</i>
        
    - character_name == "Aris" and current_enemy_name == "The Tinkerer" and not (player_skills ? Overcharge):
        ~ player_skills += Overcharge
        By observing the Tinkerer's unstable technology, you've figured out how to apply their reckless principles to your own gear. You've learned the **Overcharge** skill!
        <i>AI: "Subject Aris has reverse-engineered a crude but effective energy modulation technique. Logical progression."</i>
        
    - character_name == "Lena" and current_enemy_name == "The Veteran" and not (player_skills ? CounterAttack):
        ~ player_skills += CounterAttack
        The Veteran's calm, precise fighting style was a lesson in efficiency. You've adapted their technique into a new skill: **Counter Attack**.
        <i>AI: "Subject Lena has assimilated a more efficient combat doctrine based on observation. Optimal."</i>
    - current_enemy_name == "Skulker Guard":
            You defeat the guard, and the rest of the horde scatters, but you see two larger Skulkers coordinating their attacks, blocking the path forward.
    { jed_status == "HELPED":
        Jed stands back-to-back with you. "You take the one on the left?" he asks, readying his own weapon.
    }
        This is your first major obstacle.
        -> setup_two_skulker_battle
}

// Check if Aris can loot the creature
{ character_name == "Aris" and current_enemy_name == "Slick-Skinned Skulker":
    -> loot_skulker
}

// Check which enemy was defeated to continue the correct story path
{ 
- current_enemy_name == "Slick-Skinned Skulker":
    -> skulker_win
- current_enemy_name == "Ambush Skulker":
            { character_name == "Aris":
                -> loot_ambush_skulker
            - else:
                You dispatch the creature and catch your breath. The hab-unit is now clear.
                -> final_scavenge
            }
- current_enemy_name == "Skulker Guard":
            { character_name == "Aris":
                -> loot_skulker_guard
            - else:
                You defeat the guard, and the rest of the horde scatters, clearing the path to the main platform.
                -> setup_alpha_skulker_battle
            }
- current_enemy_name == "The Brute":
        You step over the unconscious form of the Brute and head for the stairs.
        -> tower_buffer_room(-> tower_floor_3)
    - current_enemy_name == "The Tinkerer":
        The Tinkerer's device sputters and dies, and they surrender immediately. You move to the next floor.
        -> tower_buffer_room(-> tower_floor_5)
    - current_enemy_name == "The Veteran":
        The Veteran gives a single, respectful nod as they fall back, defeated. The path to the top is clear.
        -> tower_top
- else:
    // A default win case, in case you add other battles
    -> END
}

= loot_ambush_skulker
    As the Skulker lies defeated, your bio-scanner detects a potent neurotoxin still active in its venom glands.
    * [Harvest the Venom Gland]
        ~ temp roll = RANDOM(1, 3)
        { roll == 1:
            // Success (33% chance)
            You carefully extract the gland, a pulsating sac of green fluid. This could be a powerful ingredient.
            ~ skulker_venom_gland_stack += 1
        - else:
            // Failure
            You try to extract the gland, but your hands are unsteady from the fight. You accidentally puncture the sac, and the venom spills uselessly onto the floor, dissolving into a foul-smelling vapor. The opportunity is lost.
        }
    * [Leave it.]
        // Do nothing
- The hab-unit is now clear.
-> final_scavenge

= loot_skulker_guard
    As the Skulker Guard lies defeated, your bio-scanner detects a potent neurotoxin still active in its venom glands.
    * [Harvest the Venom Gland]
        ~ temp roll = RANDOM(1, 3)
        { roll == 1 or roll == 2:
            // Success (66% chance)
            You carefully extract the gland from the larger creature. This is a prime sample.
            ~ skulker_venom_gland_stack += 2
        - else:
            // Failure
            You try to extract the gland, but the creature's thick hide makes it difficult. You accidentally puncture the sac, and the venom spills uselessly onto the floor.
        }
    * [Leave it.]
        // Do nothing
- You defeat the guard, and the rest of the horde scatters, clearing the path to the main platform.
-> setup_alpha_skulker_battle

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
        ~ temp roll = RANDOM(1, 3)
        { roll == 1:
            // Success (33% chance)
            You carefully extract the gland, a pulsating sac of green fluid. This could be a powerful ingredient.
            ~ skulker_venom_gland_stack += 1
        - else:
            // Failure
            You try to extract the gland, but your hands are unsteady from the fight. You accidentally puncture the sac, and the venom spills uselessly onto the floor, dissolving into a foul-smelling vapor. The opportunity is lost.
        }
    * [Leave it.]
        // Do nothing
- The path to the terminal is clear..
-> skulker_win

=== battle_lost ===
~ used_skill_in_battle = false
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

=== crafting_options(-> return_point) ===
    You lay out your scavenged materials.
    
    // Kaelen's Crafting Option
    + { character_name == "Kaelen" and not has_reinforced_club and has_metal_pipe and has_thick_wiring } [Fashion a Reinforced Club.]
        You take the sturdy metal pipe and thick wiring you found. Using your strength, you wrap the wiring tightly around one end, creating a weighted, brutal-looking club. It feels solid in your hands.
        ~ has_reinforced_club = true
        ~ atk += 2
        -> crafting_options(return_point)

    // Aris's Crafting Option
    + { character_name == "Aris" and power_cell_stack > 0 and not has_emp_grenade } [Assemble an EMP Grenade.]
        You carefully pry open the casing of the Degraded Power Cell. Bypassing the safety regulators, you rig it to overload on impact. It's a volatile, single-use weapon, perfect for disabling electronics... or stunning biological targets.
        ~ has_emp_grenade = true
        ~ power_cell_stack -= 1 // The cell is consumed
        -> crafting_options(return_point)
    + { character_name == "Aris" and glimmer_moss_stack > 0 } [Refine Glimmer Moss into Poison.]
        You crush the Glimmer Moss, carefully isolating the coagulant you discovered earlier. By mixing it with a mild solvent from your kit, you refine it into a sticky, paralytic poison. You place it in an empty vial, ready for use.
        ~ has_moss_poison_vial += 1
        ~ glimmer_moss_stack -= 1
        -> crafting_options(return_point)
    + { character_name == "Aris" and skulker_venom_gland_stack > 0 and power_cell_stack > 0 and not has_poison_bomb } [Create a Poison Gas Bomb.]
        This is a dangerous idea... but a brilliant one. You carefully puncture the Skulker's venom gland, siphoning the potent neurotoxin into the casing of the Degraded Power Cell. You rig the cell to overload, not with an EMP, but with a thermal charge that will aerosolize the venom on impact. A devastating biological weapon.
        ~ has_poison_bomb = true
        ~ skulker_venom_gland_stack -= 1
        ~ power_cell_stack -= 1
        -> crafting_options(return_point)

    // Lena's Crafting Option
    * { character_name == "Lena" and not has_recurve_bow and has_flexible_polymer and has_tensile_cable } [Construct a Recurve Bow.]
        You take the length of flexible polymer and the high-tensile cable. With your deft hands, you shape the polymer and string the cable, creating a makeshift but deadly silent bow. You'll need to find arrows, but the frame is perfect.
        ~ has_recurve_bow = true
        ->crafting_options(return_point)
    + { character_name == "Lena" and has_recurve_bow } [Fletch Scrap Arrows.]
        You find a few thin pieces of rebar for shafts and some sharpened scrap metal for heads. With some tattered fabric for fletching, you can assemble a small quiver's worth of arrows.
        ~ temp arrows_crafted = RANDOM(2, 4)
        ~ scrap_arrow_count += arrows_crafted
        You craft {arrows_crafted} scrap arrows.
        -> crafting_options(return_point)
    + { character_name == "Lena" and has_recurve_bow and scrap_arrow_count > 0 and power_cell_stack > 0 } [Craft Shock Arrows.]
        You carefully attach the live wire from a Degraded Power Cell to the head of a scrap arrow. It's a crude but effective way to deliver a powerful electrical jolt on impact. You manage to create a small bundle of them before the power cell is drained.
        ~ temp arrows_crafted2 = RANDOM(1, 3)
        ~ shock_arrow_count += arrows_crafted2
        ~ scrap_arrow_count -= arrows_crafted2
        ~ power_cell_stack -= 1
        You craft {arrows_crafted} shock arrows.
        -> crafting_options(return_point)
    
    // Equip Options
    * { has_reinforced_club and not club_equipped } [Equip the Reinforced Club.]
        ~ club_equipped = true
        You grip the club tightly. It's a crude but effective weapon. Your Attack has increased.
        ~ update_combat_stats()
        -> crafting_options(return_point)
    * { has_recurve_bow and not bow_equipped } [Equip the Recurve Bow.]
        ~ bow_equipped = true
        You sling the bow over your shoulder. You'll be able to strike from the shadows. Your Attack has increased.
        ~ update_combat_stats()
        -> crafting_options(return_point)

    * [That's all for now.]
        -> return_point
        
== jed_turn
    { jed_status == "HELPED" and jed_hp > 0:
        Jed fights alongside you. He takes a shot at an enemy.
        ~ temp target_roll = RANDOM(1, 2)
        {
            - target_roll == 1 and current_enemy_hp > 0:
                ~ current_enemy_hp -= jed_atk
                Jed hits the first {current_enemy_name} for {jed_atk} damage!
            - enemy2_hp > 0:
                ~ enemy2_hp -= jed_atk
                Jed hits the second {enemy2_name} for {jed_atk} damage!
            - else:
                ~ current_enemy_hp -= jed_atk
                Jed hits the first {current_enemy_name} for {jed_atk} damage!
        }
    }
    -> enemy_turn

=== use_glimmer_moss_tunnel(is_safe) ===
    ~ glimmer_moss_stack -= 1
    ~ temp heal_amount = 0
    You pull out the pouch of glowing moss.
    { character_name == "Aris":
        // Aris is an expert
        Knowing its properties, you create a crude but effective poultice. The mild coagulant works quickly, and you feel a surge of vitality as the bioluminescent enzymes knit your tissues back together. You recover a significant amount of health.
        ~ heal_amount = INT(max_hp * 0.5) // Heals for 50% of max HP
    - else:
        // Kaelen and Lena are just guessing
        You crush the moss and apply it to your wounds, hoping for the best. It feels cool and soothing, and you notice your bruises fading slightly. It's not a miracle cure, but it helps. You recover a small amount of health.
        ~ heal_amount = INT(max_hp * 0.2) // Heals for 20% of max HP
    }
    ~ hp += heal_amount
    { hp > max_hp:
        ~ hp = max_hp // Don't overheal
    }
    The moss dissolves into a faint, glowing dust, its regenerative properties spent.
    ~ is_injured = false

    // --- RANDOM ATTACK CHECK ---
    { not is_safe:
        ~ temp attack_chance = RANDOM(1, 4)
        { attack_chance == 1:
            As the glow fades, you hear a frantic chittering sound. A small, rat-like creature with pale skin darts out from a crack in the wall, attracted by the moss's sweet scent. It nips at your boot before you can react, then vanishes back into the darkness. It didn't hurt, but the startling encounter has left you on edge.
            ~ resolve -= 3
        }
    }
    ->->