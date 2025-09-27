== lair_horde_battle
    The smaller creatures are a chaotic mess, but you see two larger Skulkers coordinating their attacks, blocking the path forward.
    { jed_status == "HELPED":
        Jed stands back-to-back with you. "Looks like we've got trouble," he says, his voice steady. "I can give you some covering fire to soften them up, or I can give you this. Your call, but make it quick." He holds out a scavenged piece of armor plating.
        -> jed_support_choice
    - else:
        This is your first major obstacle.
        -> setup_two_skulker_battle(false)
    }
    
= jed_support_choice
    * [Give me covering fire.]
        "Right," Jed nods. "Stay low." He raises his weapon and lays down a burst of suppressing fire, forcing one of the Skulkers to duck behind cover. It will be easier to hit.
        // The first enemy will have lowered defense for this fight.
        -> setup_two_skulker_battle(true)
    * [I'll take the armor.]
        "Good choice," Jed says, handing you the heavy plating. "It's not pretty, but it'll stop a claw or two." You quickly strap it on. Your Defense has been temporarily boosted.
        ~ def += 2
        -> setup_two_skulker_battle(false)

== setup_skulker_guard_battle
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
You, {rival_name}, Jed, and two other skilled-looking contestants are the first to reach the platform. The Alpha Skulker Matriarch emerges from the derelict train car. It is immense, covered in glowing green scars, and it lets out a shriek that shakes the very foundations of the cavern. The final battle begins.
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
~ ally_3_is_down = false
~ ally_4_is_down = false
-> alpha_skulker_battle_loop

== setup_two_skulker_battle(jed_is_providing_cover)
    // Setup for Skulker 1
    ~ current_enemy_name = "Skulker Packmate Beta"
    ~ current_enemy_hp = 20
    ~ current_enemy_atk = 6
    ~ current_enemy_def = 3
    { jed_is_providing_cover:
        // Apply Jed's debuff if he provided covering fire
        ~ current_enemy_def = 1
    }
    // Setup for Skulker 2
    ~ enemy2_name = "Skulker Packmate Gama"
    ~ enemy2_hp = 20
    ~ enemy2_atk = 6
    ~ enemy2_def = 3
    // Setup for Jed
    ~ jed_hp = jed_max_hp
    -> battle_loop

=== alpha_skulker_battle_loop ===
    // --- BERSERK CHECK ---
    { alpha_skulker_hp <= alpha_skulker_max_hp / 10 and not alpha_is_berserk:
        ~ alpha_is_berserk = true
        ~ alpha_skulker_atk = 15 // High damage
        ~ alpha_skulker_def = 2  // Low defense
        The Matriarch shrieks in agony and rage, its glowing scars flaring violently. It's gone berserk!
        
        // --- Rival's Grudge Behavior ---
        { rival_relationship <= GRUDGE:
            ~ rival_is_waiting_for_opening = true
            Seeing the boss falter, your Rival stops fighting. A cruel, opportunistic glint appears in their eyes. They back away from the fight, content to watch you and the creature tear each other apart.
            { jed_status == "HOSTILE":
                Jed joins them, a grim look on his face. "Sorry, kid. It's just business."
            }
        }
    }
    
    The Alpha Skulker is at {alpha_skulker_hp}/{alpha_skulker_max_hp} HP. You are at {hp}/{max_hp} HP.
    
    // --- RIVAL EVENT CHECK ---
    { rival_is_in_danger:
        -> rival_in_danger_event
    }

    + [Attack]
        ~ temp damage = atk - alpha_skulker_def
        { damage < 1: 
            ~ damage = 1
        }
        ~ alpha_skulker_hp -= damage
        ~ player_contribution += damage
        You strike the Matriarch for {damage} damage!
        -> allies_turn
    + { not used_skill_in_battle } [Use Skill]
        -> alpha_use_skill
        
    + { character_name == "Aris" and has_moss_poison_vial > 0 } [Use Moss Poison ({has_moss_poison_vial} left)]
        -> alpha_use_moss_poison
        
    + { character_name == "Aris" and poison_bomb_stack > 0 } [Use Poison Bomb]
        -> alpha_use_poison_bomb
        
    + { character_name == "Aris" and has_emp_grenade } [Use EMP Grenade]
        -> alpha_use_emp_grenade
        
    + { character_name == "Lena" and scrap_arrow_count > 0 } [Fire a Scrap Arrow ({scrap_arrow_count} left)]
        -> alpha_fire_scrap_arrow
        
    + { character_name == "Lena" and silent_arrow_count > 0 } [Fire a Silent Arrow ({silent_arrow_count} left)]
        -> alpha_fire_silent_arrow
        
    + { character_name == "Lena" and shock_arrow_count > 0 } [Fire a Shock Arrow ({shock_arrow_count} left)]
        -> alpha_fire_shock_arrow
    * { emitter_equipped and emitter_charges > 0 } [Use Kinetic Emitter ({emitter_charges} left)]
    -> player_use_emitter_on_alpha
    + [Defend]
        ~ is_defending = true
        You brace yourself for the Matriarch's onslaught.
        -> allies_turn
    * { hp <= max_hp / 4 and not alpha_is_berserk } [This is too much. Flee the battle.]
        -> alpha_battle_flee

= alpha_battle_flee
    The pain and the terror are too much. You turn your back on your allies and run, scrambling out of the cavern. Your Rival sees your cowardice, their face a mask of pure disgust. "Coward!" they scream after you.
    
    You've abandoned the fight and sealed your fate in this zone. Your rival will never forget this betrayal.
    ~ rival_relationship = 0 // Instant GRUDGE
    -> chapter_1_failure_ending
    
// === CHAPTER 1 FAILURE SCENE ===
== chapter_1_failure_ending
You are left alone in the silent, cavernous lair. The Archive Gate closes, its energy fading into darkness. The Proctor's voice echoes one last time, not with triumph, but with cold, dismissive finality.

<i>PROCTOR: "Subject has failed to meet the primary objective parameters. Insufficient data acquired. Specimen is deemed substandard."</i>

<i>PROCTOR: "Initiating sanitation protocol."</i>

A low hum fills the air as hidden turrets descend from the ceiling, their targeting lasers painting your chest red. There is no escape. The Arena has found you wanting.

-> END
        
// === New stitch for the Rival's final attack ===
== rival_final_blow
    With the battle reaching its desperate climax, your Rival sees their chance.
    { hp <= 10:
        // Rival attacks the player
        As the Matriarch prepares to attack you, your Rival strikes you from behind. "Nothing personal," they whisper. The blow is fatal.
        -> game_over_death
    - else:
        // Rival attacks the boss
        As you prepare to land the final blow, your Rival darts past you, landing a cheap, opportunistic strike that fells the weakened Matriarch. They've stolen your kill and your glory.
        ~ rival_contribution += 20 // They get a huge contribution bonus
        -> alpha_skulker_defeated
    }

// === ALPHA BATTLE - PLAYER ACTIONS ===
== alpha_use_skill
    ~ used_skill_in_battle = true
    + { player_skills ? Survivalist} [Survivalist] // Kaelen's Skill
        You roar, focusing your rage into a single, powerful strike. Your Attack is temporarily increased!
        ~ atk += 2
        -> allies_turn
    + { player_skills ? BioScan} [Bio can] // Aris's Skill
        You activate your bio-scanner, identifying a weak point in the creature's hide. Its Defense is lowered.
        ~ alpha_skulker_hp -= 2
        { alpha_skulker_hp < 0:
            ~ alpha_skulker_hp = 0
        }
        -> allies_turn
    + { player_skills ? DiscerningEye} [Discerning Eye] // Lena's Skill
        You watch the creature's feral movements, predicting its lunge. You'll be able to easily dodge its next attack.
        ~ rival_will_miss_next_turn = true
        -> allies_turn
    + { player_skills ? HeavyHitter } [Use Heavy Hitter]
        You channel all your strength into a single, devastating blow. It's slow, but powerful.
        ~ temp heavy_damage = INT(atk * 1.5)
        ~ alpha_skulker_hp -= heavy_damage
        You slam the Alpha Skulker for {heavy_damage} damage!
        { current_enemy_hp <= 0:
            -> battle_won
        - else:
            -> allies_turn
        }

    + { player_skills ? Overcharge } [Use Overcharge]
        You reroute power through the Kinetic Emitter, preparing to unleash an overloaded blast. Your next Emitter use will be massively amplified.
        ~ is_overcharging = true
        -> allies_turn

    + { player_skills ? CounterAttack } [Prepare to Counter Attack]
        You take a defensive stance, watching your enemy's every move, ready to strike the moment they commit to an attack.
        ~ is_countering = true
        -> allies_turn

== alpha_use_emitter
    { use_emitter_charge():
        ~ temp damage = 10
        { is_overcharging:
            ~ damage = 30
            ~ is_overcharging = false
        }
        The emitter blast slams into the Matriarch!
        ~ alpha_skulker_hp -= damage
        ~ player_contribution += damage
    }
    -> allies_turn

== alpha_use_moss_poison
    ~ has_moss_poison_vial -= 1
    You apply the poison to your weapon. The Matriarch is now poisoned!
    ~ enemy_is_poisoned = true
    ~ poison_turns_remaining = 3
    -> allies_turn

== alpha_use_poison_bomb
    ~ poison_bomb_stack -= 1
    The poison bomb explodes at the Matriarch's feet, dealing massive initial damage and applying a potent toxin.
    ~ temp damage = atk * 3
    ~ alpha_skulker_hp -= damage
    ~ player_contribution += damage
    ~ enemy_is_poisoned = true
    ~ poison_turns_remaining = 5
    -> allies_turn

== alpha_use_emp_grenade
    ~ has_emp_grenade = false
    The EMP grenade detonates, causing the Matriarch to stagger and shriek in confusion. It will miss its next attack.
    ~ rival_will_miss_next_turn = true // Re-using this flag for the boss
    -> allies_turn

== alpha_fire_scrap_arrow
    ~ scrap_arrow_count -= 1
    Your arrow finds a seam in the Matriarch's tough hide.
    ~ temp damage = 5
    ~ alpha_skulker_hp -= damage
    ~ player_contribution += damage
    -> allies_turn

== alpha_fire_silent_arrow
    ~ silent_arrow_count -= 1
    Your silent arrow strikes a vulnerable, glowing scar. A critical hit!
    ~ temp damage = 9
    ~ alpha_skulker_hp -= damage
    ~ player_contribution += damage
    -> allies_turn

== alpha_fire_shock_arrow
    ~ shock_arrow_count -= 1
    The shock arrow delivers a powerful jolt, causing the massive creature to seize up for a moment.
    ~ temp damage = 12
    ~ alpha_skulker_hp -= damage
    ~ player_contribution += damage
    -> allies_turn

== player_use_emitter_on_alpha
    { use_emitter_charge():
        // The function returned true, so the usage was successful.
        You unleash a wave of pure force from the emitter. It slams into the {current_enemy_name}, sending it reeling.
        ~ temp emitter_damage = 15 // Emitter deals a flat 10 damage
        { is_overcharging:
            ~ emitter_damage = 30 // Overcharge boosts damage to 25
            ~ is_overcharging = false
            The Emitter shrieks as it discharges the excess energy.
        }
        ~ alpha_skulker_hp -= emitter_damage
        ~ player_contribution += emitter_damage
    }
    
    { alpha_skulker_hp <= 0:
        -> alpha_skulker_defeated
    - else:
        -> alpha_skulker_turn
    }
        
== allies_turn
    // --- Check if the rival is waiting for an opening ---
    { rival_is_waiting_for_opening:
        -> alpha_skulker_turn // If so, they do nothing and it's the boss's turn
    }
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
    // --- Rival's Turn ---
    ~ temp rival_action_chance = RANDOM(1, 4)
    {
        - rival_action_chance == 1 and rival_has_emitter and rival_emitter_charges > 0:
            // Rival uses the Emitter (25% chance if available)
            ~ rival_emitter_charges -= 1
            Your Rival unleashes a blast from their Kinetic Field Emitter! The raw force tears a huge chunk of armor from the Matriarch.
            ~ temp emitter_damage = 20
            ~ rival_contribution += emitter_damage
            ~ alpha_skulker_hp -= emitter_damage

        - rival_action_chance <= 2 and not rival_used_combat_skill:
            // Rival uses their combat skill (one time use, 25% chance)
            ~ rival_used_combat_skill = true
            {
                - rival_name == "Xander":
                    // Xander's Skill: Finishing Blow
                    Seeing the Matriarch wounded, Xander roars and leaps, bringing his weapon down in a devastating overhead strike.
                    ~ temp skill_damage = 15
                    ~ rival_contribution += skill_damage
                    ~ alpha_skulker_hp -= skill_damage
                - rival_name == "Jinx":
                    // Jinx's Skill: Overload Cascade
                    "Time for the light show!" Jinx yells, throwing an overloaded power cell into a puddle at the Matriarch's feet. An arc of electricity chains between the creature and a nearby ally!
                    ~ temp skill_damage2 = 12
                    ~ rival_contribution += skill_damage2
                    ~ alpha_skulker_hp -= skill_damage2
                    ~ hp -= 4 // Player takes some splash damage
                - rival_name == "Isha":
                    // Isha's Skill: Vitals Shot
                    Isha nocks a special arrow and waits for the perfect moment. She looses it, striking a vulnerable, glowing scar on the Matriarch's side. The creature shrieks as green energy bleeds from the wound.
                    ~ temp skill_damage3 = 8
                    ~ rival_contribution += skill_damage3
                    ~ alpha_skulker_hp -= skill_damage3
                    // TODO: Add a "bleed" status effect
            }
        - else:
            // Rival's regular attack (50% chance)
            Your Rival fights with brutal efficiency, scoring a deep hit.
            ~ temp rival_damage = RANDOM(6, 10)
            ~ rival_contribution += rival_damage
            ~ alpha_skulker_hp -= rival_damage
    }

    // Other Allies' Turns
    { not ally_3_is_down:
        The third contestant lands their attack.
        ~ ally_3_contribution += 4
        ~ alpha_skulker_hp -= 4
    }
    { not ally_4_is_down:
        The fourth contestant lands their attack.
        ~ ally_4_contribution += 4
        ~ alpha_skulker_hp -= 4
    }
    
    { alpha_skulker_hp <= 0:
        -> alpha_skulker_defeated
    - else:
        -> alpha_skulker_turn
    }

== alpha_skulker_turn
    { enemy_is_poisoned:
        ~ poison_turns_remaining -= 1
        ~ temp poison_damage = 1 + INT(intelligence / 2) // Damage scales with Intelligence
        The Matriach winces as the poison takes effect, dealing {poison_damage} damage.
        ~ alpha_skulker_hp -= poison_damage
        { poison_turns_remaining <= 0:
            ~ enemy_is_poisoned = false
            The poison wears off.
        }
    }
    // --- Calculate player's current defense for this turn ---
    ~ temp current_player_def = def
    { is_defending:
        ~ current_player_def = def + 3 // Apply defense bonus
    }
    // --- Check for the Rival's final move ---
    { rival_is_waiting_for_opening and (hp <= 10 or alpha_skulker_hp <= 15):
        -> rival_final_blow
    }
    The Matriarch shrieks and attacks!
    ~ temp aoe_roll = RANDOM(1, 10)
    { aoe_roll <= 2:
        // AOE Attack
        It unleashes a deafening sonic screech that hits everyone on the platform!
        ~ hp -= 5
        You take 5 damage from the sonic blast!
    - else:
        // Single Target Attack
        It lunges, claws flashing!
        ~ temp target_roll = RANDOM(1, 5)
        ~ temp damage = alpha_skulker_atk - def
        { damage < 1: 
            ~ damage = 1 
        }
        {
            - target_roll == 1: // Target: Player
             // --- Player Dodge Check ---
            ~ temp player_dodge_roll = RANDOM(1, 100)
            { player_dodge_roll <= dodge_chance:
                You anticipate the attack and deftly move aside. It misses!
            - else:
                { rival_will_miss_next_turn:
                    ~ rival_will_miss_next_turn = false
                    You anticipate the Alpha Skulker clumsy attack and easily step aside. It misses completely.
                    -> allies_turn
                - else:
                    ~ hp -= damage
                    It attacks you for {damage} damage!
                }
            }
            - target_roll == 2: // Target: Rival
                // The rival can be defeated but not killed.
                The Matriarch slams into {rival_name}, sending them flying. They're down, but not out of the fight.
            - target_roll == 3: // Target: Jed
                { not (jed_status == "DEAD"):
                    ~ jed_hp -= damage
                    It attacks Jed for {damage} damage!
                }
            - target_roll == 4: // Target: Ally 3
                { not ally_3_is_down:
                    ~ ally_3_hp -= damage
                    It attacks the third contestant for {damage} damage!
                }
            - else: // Target: Ally 5
                { not ally_4_is_down:
                    ~ ally_4_hp -= damage
                    It attacks the fourth contestant for {damage} damage!
                }
        }
    }
    
    // --- Check for Defeat States ---
    { hp <= 0:
        -> game_over_death
    }
    { jed_hp <= 0 and jed_status != "DEAD":
        Jed is struck down by the Matriarch's attack and doesn't get back up.
        ~ jed_status = "DEAD"
    }
    { ally_3_hp <= 0 and not ally_3_is_down:
        The third contestant is overwhelmed and falls, unconscious.
        ~ ally_3_is_down = true
    }
    { ally_4_hp <= 0 and not ally_4_is_down:
        The fourth contestant is thrown from the platform by a vicious blow.
        ~ ally_4_is_down = true
    }
    
    // Random chance for the rival event to trigger
    ~ temp event_roll = RANDOM(1, 4)
    { event_roll == 1 and not rival_is_in_danger:
        ~ rival_is_in_danger = true
    }
    
    -> alpha_skulker_battle_loop

== rival_in_danger_event
    The Matriarch turns its attention, pinning your Rival against the derelict train car. They're trapped and vulnerable! This is your chance.
    + [Support your Rival]
        You fire a shot or create a diversion, drawing the Matriarch's attention away from them. Your Rival gives you a surprised, grudging look of acknowledgement.
        ~ rival_is_in_danger = false
        ~ rival_relationship += 10
        -> alpha_skulker_turn
    + [Sabotage your Rival]
        You "accidentally" kick a piece of debris in their way, causing them to stumble. The Matriarch's claws rake across their side, wounding them badly. They glare at you with pure hatred.
        ~ rival_contribution -= 10 // Penalty to their score
        ~ rival_relationship -= 15 // Sabotage instantly creates a GRUDGE
        ~ rival_is_in_danger = false
        -> alpha_skulker_turn
    + [Do nothing]
        You watch, impassive, as your Rival barely manages to fend off the attack on their own. They are wounded and exhausted from the effort.
        ~ rival_is_in_danger = false
        ~ rival_relationship -= 5
        -> alpha_skulker_turn

== alpha_skulker_defeated
With a final, agonized shriek, the Alpha Skulker Matriarch collapses. The cavern falls silent, the only sound your own ragged breathing and the thumping of your heart.
<i>PROCTOR: "Apex Predator neutralized. Calculating combat contributions... Calculation complete."</i>

The Proctor's voice fills the cavern, as cold and vast as the space between worlds.
<i>PROCTOR: "Of the ten subjects who began this trial, five have demonstrated sufficient capability to proceed. The remainder have been culled or have proven substandard. An acceptable attrition rate."</i>

<i>PROCTOR: "Strength is not merely the ability to destroy. It is the ability to adapt, to overcome, and to endure in the face of overwhelming odds. You have demonstrated these qualities to a satisfactory degree."</i>

<i>PROCTOR: "The following subjects have earned the final Data Fragment and the right to ascend: Subject {character_name}, Subject {rival_name}, Subject Jedediah, Subject Jors and Subject Soff"</i>
~ data_fragments += 1

<i>PROCTOR: "As a reward for your exceptional performance, your biological and cybernetic parameters will now be optimized. Acknowledging... primary combat adaptation."</i>

{ character_name == "Kaelen":
    You feel a surge of raw power course through your limbs, a deep, primal strength settling into your very bones.
    ~ strength += 1
    <i>AI: "Primary attribute Strength has been enhanced."</i>
}
{ character_name == "Aris":
    A wave of pure data washes through your mind, connections and calculations flowing faster than ever before. Your thoughts feel sharper, clearer.
    ~ intelligence += 1
    <i>AI: "Primary attribute Intelligence has been enhanced."</i>
}
{ character_name == "Lena":
    Your senses heighten, the dripping of water in the far corners of the cavern and the subtle scent of ozone becoming crystal clear. You feel more aware, more connected to your surroundings.
    ~ perception += 1
    <i>AI: "Primary attribute Perception has been enhanced."</i>
}
~ update_combat_stats()

<i>PROCTOR: "The Archive Gate is now active. Proceed to the next phase of the experiment. The true test has just begun."</i>

// --- FINAL CHECK ---
{ data_fragments >= 3:
    // SUCCESS PATH
    The massive gate on the platform hums to life, a swirling vortex of green energy. Your Rival gives you a final, unreadable look before stepping through. Jed, if he is still with you, gives a weary nod and follows.
    * [Step through the Archive Gate and leave this place behind.]
        You take a deep breath and step into the unknown, ready for whatever comes next.
        -> END
- else:
    // FAILURE PATH
    The massive gate on the platform hums to life, but a red barrier shimmers in front of you, blocking your path. The other successful contestants step through, leaving you behind.
    -> chapter_1_failure_ending
}