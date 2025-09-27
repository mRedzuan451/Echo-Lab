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
    + { character_name == "Aris" and poison_bomb_stack > 0 } [Use Poison Bomb]
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
    // --- Enemy Dodge Check ---
    ~ temp enemy_dodge_roll = RANDOM(1, 100)
    { enemy_dodge_roll <= 15: // Enemies have a base 15% chance to dodge
        You lunge, but the {target_name} is surprisingly quick, sidestepping your attack. It misses!
        -> return_point
    }
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
    
    ~ temp p_multiplier = RANDOM(8, 12) / 10.0
    ~ temp damage = atk - target_def
    { damage < 1: 
        ~ damage = 1 
    }
    ~ temp final_dmg = INT(damage * p_multiplier)
    ~ target_hp -= final_dmg
    
    { is_second_enemy:
        ~ enemy2_hp = target_hp
    - else:
        ~ current_enemy_hp = target_hp
    }
    You attack the {target_name} for {final_dmg} damage!
    -> return_point


== player_fire_shock_arrow
    ~ shock_arrow_count -= 1
    The arrow crackles with stored energy as you loose it. It hits the {current_enemy_name} with a shower of sparks, delivering a powerful electric shock.
    ~ temp arrow_damage = 12 // High damage
    ~ current_enemy_hp -= arrow_damage
    { current_enemy_hp <= 0:
        -> battle_won
    - else:
        -> jed_turn
    }

== player_fire_scrap_arrow
    ~ scrap_arrow_count -= 1
    You loose a crudely made arrow. It flies true, striking the {current_enemy_name} for moderate damage.
    ~ temp arrow_damage = 5
    ~ current_enemy_hp -= arrow_damage
    { current_enemy_hp <= 0:
        -> battle_won
    - else:
        -> jed_turn
    }

== player_fire_silent_arrow
    ~ silent_arrow_count -= 1
    The silent arrow whispers through the air, finding a weak point in the {current_enemy_name}'s defense. A critical hit!
    ~ temp arrow_damage = 9
    ~ current_enemy_hp -= arrow_damage
    { current_enemy_hp <= 0:
        -> battle_won
    - else:
        -> jed_turn
    }

== player_use_moss_poison
    ~ has_moss_poison_vial -= 1
    You coat a small dart with the paralytic poison.
    { enemy2_hp > 0:
        // If there are two enemies, you must choose a target
        * [Target the first {current_enemy_name}.]
            ~ enemy_is_poisoned = true
            ~ poison_turns_remaining = 3
            The dart finds its mark. The first {current_enemy_name} is now poisoned!
            -> jed_turn
        * [Target the second {enemy2_name}.]
            ~ enemy2_is_poisoned = true
            ~ poison2_turns_remaining = 3
            The dart finds its mark. The second {enemy2_name} is now poisoned!
            -> jed_turn
    - else:
        // If there is only one enemy
        The {current_enemy_name} is now poisoned!
        ~ enemy_is_poisoned = true
        ~ poison_turns_remaining = 3
        -> jed_turn
    }

== player_use_poison_bomb
    ~ poison_bomb_stack -= 1
    The bomb shatters, releasing a cloud of aerosolized neurotoxin that engulfs all enemies!
    ~ temp bomb_damage = atk * 3
    
    // Damage and poison the first enemy
    The {current_enemy_name} takes {bomb_damage} initial damage!
    ~ current_enemy_hp -= bomb_damage
    ~ enemy_is_poisoned = true
    ~ poison_turns_remaining = 5
    
    // Damage and poison the second enemy if it exists
    { enemy2_hp > 0:
        The {enemy2_name} also takes {bomb_damage} initial damage!
        ~ enemy2_hp -= bomb_damage
        ~ enemy2_is_poisoned = true
        ~ poison2_turns_remaining = 5
    }
    
    { current_enemy_hp <= 0 and (enemy2_hp <= 0 or enemy2_name == ""):
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
    -> jed_turn

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
        -> jed_turn // The skill use takes your turn
    }
    { player_skills ? DiscerningEye: // Lena's Skill
        You watch the creature's feral movements, predicting its lunge. You'll be able to easily dodge its next attac.
        ~ rival_will_miss_next_turn = true
        -> jed_turn // The skill use takes your turn
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
            -> jed_turn
        }

    * { player_skills ? Overcharge } [Use Overcharge]
        You reroute power through the Kinetic Emitter, preparing to unleash an overloaded blast. Your next Emitter use will be massively amplified.
        ~ is_overcharging = true
        -> jed_turn

    * { player_skills ? CounterAttack } [Prepare to Counter Attack]
        You take a defensive stance, watching your enemy's every move, ready to strike the moment they commit to an attack.
        ~ is_countering = true
        -> jed_turn
    
    * { player_skills ? TargetedAnalysis and jed_status == "HELPED" and jed_hp > 0 and not jed_is_buffed } [Use Targeted Analysis on Jed]
        You analyze the enemy's movements and call out a weak point to Jed. "Jed, the left side! Now!"
        ~ jed_is_buffed = true
        -> jed_turn // This skill use takes your turn

=== player_use_emitter ===
    { use_emitter_charge():
        // The function returned true, so the usage was successful.
        You unleash a wave of pure force from the emitter. It slams into the {current_enemy_name}, sending it reeling.
        ~ temp emitter_damage = 15 // Emitter deals a flat 15 damage
        { is_overcharging:
            ~ emitter_damage = 30 // Overcharge boosts damage to 30
            ~ is_overcharging = false
            The Emitter shrieks as it discharges the excess energy.
        }
        ~ current_enemy_hp -= emitter_damage
    }
    
    { current_enemy_hp <= 0:
        -> battle_won
    - else:
        -> jed_turn
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
             // --- Player Dodge Check ---
            ~ temp player_dodge_roll = RANDOM(1, 100)
            { player_dodge_roll <= dodge_chance:
                You anticipate the attack and deftly move aside. It misses!
            - else:
                // If Jed is an ally, the enemy might target him
                { jed_status == "HELPED" and jed_hp > 0:
                    ~ temp target_roll = RANDOM(1, 2)
                    {
                        - target_roll == 1:
                            // Target Player
                            ~ temp p_multiplier = RANDOM(8, 12) / 10.0
                            ~ temp damage = current_enemy_atk - current_player_def
                            { damage < 1: 
                                ~ damage = 1 
                            }
                            ~ temp final_dmg = INT(damage * p_multiplier)
                            ~ hp -= final_dmg
                            It hits you for {final_dmg} damage!
                        - else:
                            // Target Jed
                            ~ temp p_multiplier2 = RANDOM(8, 12) / 10.0
                            ~ temp damage3 = current_enemy_atk - jed_def
                            { damage3 < 1: 
                                ~ damage3 = 1 
                            }
                            ~ temp final_dmg2 = INT(damage * p_multiplier2)
                            ~ jed_hp -= final_dmg2
                            It hits Jed for {final_dmg2} damage!
                    }
                - else:
                    // If Jed is not an ally, always target player
                    ~ temp p_multiplier3 = RANDOM(8, 12) / 10.0
                    ~ temp damage4 = current_enemy_atk - current_player_def
                    { damage4 < 1: 
                        ~ damage4 = 1 
                    }
                    ~ temp final_dmg3 = INT(damage * p_multiplier3)
                    ~ hp -= final_dmg3
                    It hits you for {final_dmg3} damage!
                }
            }
        }
    
        // --- Enemy 2's Turn ---
        { enemy2_hp > 0:
            The second {enemy2_name} attacks!
             // --- Player Dodge Check ---
            ~ temp player_dodge_roll2 = RANDOM(1, 100)
            { player_dodge_roll2 <= dodge_chance:
                You anticipate the attack and deftly move aside. It misses!
                - else:
                // Same targeting logic as Enemy 1
                { jed_status == "HELPED" and jed_hp > 0:
                    ~ temp target_roll2 = RANDOM(1, 2)
                    {
                        - target_roll2 == 1:
                            // Target Player
                            ~ temp p_multiplier4 = RANDOM(8, 12) / 10.0
                            ~ temp damage5 = enemy2_atk - current_player_def
                            { damage5 < 1: 
                                ~ damage5 = 1 
                            }
                            ~ hp -= damage5
                            ~ temp final_dmg4 = INT(damage * p_multiplier4)
                            It hits you for {final_dmg4} damage!
                        - else:
                            // Target Jed
                            ~ temp p_multiplier5 = RANDOM(8, 12) / 10.0
                            ~ temp damage2 = enemy2_atk - jed_def
                            { damage2 < 1: 
                                ~ damage2 = 1 
                            }
                            ~ jed_hp -= damage2
                            ~ temp final_dmg5 = INT(damage * p_multiplier5)
                            It hits Jed for {final_dmg5} damage!
                    }
                - else:
                    // If Jed is not an ally, always target player
                    ~ temp p_multiplier6 = RANDOM(8, 12) / 10.0
                    ~ temp damage6 = enemy2_atk - current_player_def
                    { damage6 < 1: 
                        ~ damage6 = 1 
                    }
                    ~ temp final_dmg6 = INT(damage * p_multiplier6)
                    ~ hp -= final_dmg6
                    It hits you for {final_dmg6} damage!
                }
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
        { jed_hp <= 0 and jed_status != "DEAD" and current_enemy_name == "Skulker Guard":
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
            The guard collapses, and you spot a small, sealed vial attached to its makeshift belt. It's a Regen Serum.
            ~ has_regen_serum = true
            * [Use the Regen-Serum]
                -> use_regen_serum
            * [Do not use the Regen-Serum]
                { character_name == "Aris":
                    -> loot_skulker_guard
                - else:
                    You defeat the guard, and the rest of the horde scatters, clearing the path to the main platform.
                    -> setup_alpha_skulker_battle
                }
            
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

= use_regen_serum
    You inject the serum. A wave of warmth spreads through your body, knitting tissues back together and washing away all fatigue and pain. You feel completely restored.
        ~ hp = max_hp
        ~ is_injured = false
        ~ is_fatigued = false
        ~ has_regen_serum = false
        { character_name == "Aris":
            -> loot_skulker_guard
        - else:
            You defeat the guard, and the rest of the horde scatters, clearing the path to the main platform.
            -> setup_alpha_skulker_battle
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

== jed_turn
    { jed_status == "HELPED" and jed_hp > 0:
        ~ temp current_jed_atk = jed_atk
        { jed_is_buffed:
            ~ current_jed_atk = jed_atk + 4 // Boost Jed's attack for this turn
            ~ jed_is_buffed = false // Buff wears off
            Jed follows your instructions perfectly, striking the weak point you identified!
        - else:
            Jed fights alongside you. He attacks an enemy!
        }
        ~ temp target_roll = RANDOM(1, 2)
        {
            - target_roll == 1 and current_enemy_hp > 0:
                ~ current_enemy_hp -= current_jed_atk
                Jed hits the first {current_enemy_name} for {current_jed_atk} damage!
            - enemy2_hp > 0:
                ~ enemy2_hp -= current_jed_atk
                Jed hits the second {enemy2_name} for {current_jed_atk} damage!
            - else:
                ~ current_enemy_hp -= current_jed_atk
                Jed hits the first {current_enemy_name} for {current_jed_atk} damage!
        }
    }
    -> enemy_turn

// === GAME OVER SCENES ===
=== game_over_death ===
Your vision fades to black as the final blow lands. The last thing you hear is the AI's detached voice in your mind.
<i>AI: "Subject's vital signs have ceased. Test failed."</i>
-> END