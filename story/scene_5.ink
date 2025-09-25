// === SCENE 5A: THE CACHE (Rival Battle) ===
=== scene_5a_the_cache ===
You sprint towards the center of the plaza. A large, metallic crate is half-buried in a smoking crater. Standing over it is your rival. They turn as you approach, a hostile glint in their eyes. There's no talking your way out of this.
-> setup_rival_battle

= setup_rival_battle
    // Set up rival stats based on who they are
    { character_name == "Kaelen": // Rival is Xander
        ~ rival_max_hp = 22
        ~ rival_atk = 8
        ~ rival_def = 3
    }
    { character_name == "Aris": // Rival is Jinx
        ~ rival_max_hp = 18
        ~ rival_atk = 6
        ~ rival_def = 2
    }
    { character_name == "Lena": // Rival is Isha
        ~ rival_max_hp = 20
        ~ rival_atk = 7
        ~ rival_def = 4
    }
    ~ rival_hp = rival_max_hp
    ~ used_skill_in_battle = false
    ~ rival_will_miss_next_turn = false
    ~ rival_is_defending = false
    ~ enemy_is_poisoned = false
    ~ poison_turns_remaining = 0
    ~ is_overcharging = false
    ~ is_countering = false
    -> rival_battle_loop

= rival_battle_loop
    You have {hp}/{max_hp} HP. Your rival has {rival_hp}/{rival_max_hp} HP.
    + [Attack!]
        -> rival_player_attack
    + { character_name == "Aris" and has_moss_poison_vial > 0 } [Use Moss Poison ({has_moss_poison_vial} left)]
        -> rival_use_moss_poison
    + { character_name == "Aris" and poison_bomb_stack > 0 } [Use Poison Bomb]
        -> rival_use_poison_bomb
    * [Defend]
        ~ is_defending = true
        You anticipate your rival's next move and prepare to block.
        -> rival_enemy_turn
    + { not used_skill_in_battle } [Use Skill]
        -> rival_use_skill
    * [Give Up]
        -> rival_battle_give_up

= rival_use_moss_poison
    ~ has_moss_poison_vial -= 1
    You discreetly coat a small dart with the paralytic poison and fling it at your rival. It finds its mark. Your rival is now poisoned!
    ~ enemy_is_poisoned = true
    ~ poison_turns_remaining = 3
    -> rival_enemy_turn
    
= rival_use_poison_bomb
    ~ poison_bomb_stack -= 1
    You hurl the bomb at your rival's feet. It shatters, releasing a cloud of thick, green gas. Your rival coughs and staggers back, weakened and disoriented by the neurotoxin. They're in no condition to continue the fight.
    ~ rival_hp = 1 // Leave them with 1 HP to trigger the win condition
    -> rival_battle_win

= rival_use_skill
    ~ used_skill_in_battle = true
    { player_skills ? Survivalist: // Kaelen's Skill
        You kick a cloud of dust and rubble into your rival's face, momentarily blinding them and giving you an opening. You feel a surge of adrenaline. Your Attack increases for this battle!
        ~ atk += 2
        -> rival_enemy_turn
    }
    { player_skills ? BioScan: // Aris's Skill
        You activate your bio-scanner, analyzing your rival's physiology in real-time. You spot a minor strain in their shoulder... a weak point. Their Defense is permanently lowered!
        ~ rival_def -= 2
        { rival_def < 0:
            ~ rival_def = 0
        }
        -> rival_enemy_turn
    }
    { player_skills ? DiscerningEye: // Lena's Skill
        Ignoring the direct threat, you watch your rival's footwork. You spot a subtle tell, a shift in weight just before they strike. You know exactly how to evade their next move. Your rival will miss their next attack.
        ~ rival_will_miss_next_turn = true
        -> rival_enemy_turn
    }

= rival_player_attack
    // --- Player's Turn ---
    // Calculate rival's current defense
    ~ temp current_rival_def = rival_def
    { rival_is_defending:
        ~ current_rival_def = rival_def + 3
    }
    
    ~ temp p_multiplier = RANDOM(8, 12) / 10.0
    ~ temp p_base_dmg = atk - current_rival_def
    { p_base_dmg < 1: 
        ~ p_base_dmg = 1
    }
    ~ temp p_final_dmg = INT(p_base_dmg * p_multiplier)
    ~ rival_hp -= p_final_dmg
    
    // Reset rival's defense state after the attack
    ~ rival_is_defending = false
    
    You attack your rival, dealing {p_final_dmg} damage!
    
    { rival_hp <= rival_max_hp / 2:
        -> rival_battle_win
    - else:
        -> rival_enemy_turn
    }

= rival_enemy_turn
    { rival_will_miss_next_turn:
        ~ rival_will_miss_next_turn = false
        Using the opening you spotted, you easily sidestep your rival's clumsy attack. It misses completely.
        -> rival_battle_loop
    - else:
        // --- Rival's Turn Decision ---
        ~ temp rival_action_roll = RANDOM(1, 4)
        {
            - rival_action_roll <= 3:
                // Rival Attacks (75% chance)
                ~ temp r_multiplier = RANDOM(8, 12) / 10.0
                ~ temp r_base_dmg = rival_atk - def
                { r_base_dmg < 1: 
                    ~ r_base_dmg = 1
                }
                ~ temp r_final_dmg = INT(r_base_dmg * r_multiplier)
                ~ hp -= r_final_dmg
                Your rival counters, hitting you for {r_final_dmg} damage!
            - else:
                // Rival Defends (25% chance)
                ~ rival_is_defending = true
                Your rival anticipates your next move and takes a defensive stance.
        }

        // --- Poison Damage ---
        { enemy_is_poisoned:
            ~ poison_turns_remaining -= 1
            Your rival winces as the poison takes effect, dealing 4 damage.
            ~ rival_hp -= 4
            { poison_turns_remaining <= 0:
                ~ enemy_is_poisoned = false
                The poison wears off.
            }
        }
        
        // --- Check Win/Loss/Continue ---
        { rival_hp <= rival_max_hp / 2:
            -> rival_battle_win
        - else: hp <= max_hp / 2:
            -> rival_battle_lose_choice
        - else:
            -> rival_battle_loop
        }
    }

= rival_battle_give_up
    "Enough!" you pant, lowering your arms. "It's yours. I yield."
    
    { character_name == "Kaelen": // Rival is Xander
        Xander stops, an eyebrow raised in amusement. He saunters over to the cache and pulls out the Emitter. "Wise choice, Rook. I was getting bored anyway." He looks at you, a calculating glint in his eye. "For being so... cooperative, I'll remember this. Consider it a favour." His tone makes it sound more like a threat.
    }
    { character_name == "Aris": // Rival is Jinx
        Jinx freezes mid-lunge, her manic grin faltering into a pout. "Awww, you're giving up? But the sparks were just getting pretty!" She bounces over and grabs the Emitter. "Fine, be a party pooper. But hey!" She points a greasy finger at you. "Since you didn't break all the way, I owe you one! It'll be something... flashy!"
    }
    { character_name == "Lena": // Rival is Isha
        Isha lowers her weapon instantly, her predatory focus softening into a neutral calm. She retrieves the Emitter from the cache. "A tactical retreat. There is no dishonor in it," she says, her voice even. "You knew you were outmatched. For this, I owe you a debt. I will repay it." She gives a respectful nod before disappearing.
    }
    
    ~ rival_owes_favour = true
    ~ has_kinetic_emitter = false
    ~ rival_has_emitter = true
    ~ resolve -= 5 // Smaller resolve hit than a full defeat
     ~ rival_relationship += 15 // Giving up improves the relationship
    -> post_rival_encounter

= rival_battle_lose_choice
The blow sends you staggering back. You're injured and losing the fight, but there might be a way out of this.
* { analyzed_power_cell } [Use the Degraded Power Cell!]
    You pull out the unstable power cell. It's a desperate gambit. You hurl it at the supply cache. The resulting explosion is deafening, frying the crate's contents and forcing your rival to dive for cover. The prize is gone, but you've denied them the victory.
    ~ power_cell_stack -= 1
    ~ has_kinetic_emitter = false
    ~ rival_has_emitter = false
    ~ rival_relationship -= 15 // Destroying the prize makes them more hostile
    ~ resolve -= 5
    -> post_rival_encounter
* [You're beaten. Surrender the drop.]
    // --- CHARACTER-SPECIFIC LOSS OUTCOMES ---
    { character_name == "Kaelen":
        You collapse to one knee, unable to continue the fight. Xander looms over you, snatching the Emitter from the cache. "Just as I thought," he sneers, his voice dripping with contempt. "All that talk of honor, and you're just another piece of meat for the grinder. Stay down." He kicks dust in your face before turning his back and walking away.
    }
    { character_name == "Aris":
        You stumble, your calculations failing you in the heat of the moment. Jinx zips past you and pulls the Emitter from the crate, holding it up like a new toy. "Awww, is the little experiment over already?" she pouts, her manic grin never faltering. "Don't worry, I'll find a much... *louder* use for this than you ever would! Toodles!" With a chaotic laugh, she's gone.
    }
    { character_name == "Lena":
        You misjudge her speed, and her counter-attack leaves you breathless and exposed. Isha calmly walks to the cache and retrieves the Emitter. She gives it a cursory glance, then looks back at you with the patient eyes of a hunter. "You rely too much on the shadows," she says, her voice devoid of malice. "They can't save you when you're caught in the open. You were good prey, but the hunt is over." She nods once, then vanishes.
    }
    
    ~ has_kinetic_emitter = false
    ~ rival_has_emitter = true
    ~ resolve -= 10
    ~ rival_relationship -= 5 // Losing a fight slightly lowers the relationship
    -> scene_6_first_test

= rival_battle_win
Your final blow connects, and your rival stumbles back, winded and defeated. The fight is over. You've won. You claim the **Kinetic Field Emitter** from the supply cache.
~ has_kinetic_emitter = true
~ rival_has_emitter = false
~ emitter_charges = 3 // Emitter starts with 3 charges
~ used_skill_in_battle = false
-> post_rival_encounter



// === NEW SCENE: AFTERMATH ===
=== post_rival_encounter ===
The adrenaline fades, leaving you panting in the quiet plaza.
// Check HP to determine condition after the fight
{
    - hp <= max_hp / 4: // If HP is at 25% or less
        ~ is_injured = true
        ~ is_fatigued = false
        You're badly wounded, and every movement is a struggle.
    - hp <= max_hp / 2: // If HP is at 50% or less
        ~ is_injured = false
        ~ is_fatigued = true
        You're bruised and exhausted from the fight.
    - else:
        ~ is_injured = false
        ~ is_fatigued = false
}
You take a moment to catch your breath before moving on.
* { is_fatigued } [Rest for a moment.]
    -> rest_a_moment
* { is_injured and glimmer_moss_stack == 0 } [Look for something to treat your wounds.]
    -> look_for_moss
* { glimmer_moss_stack > 0 and is_injured } [Use the Glimmer Moss to tend to your wounds.]
    -> use_glimmer_moss_tunnel (false)
* { has_kinetic_emitter and not studied_emitter } [Study the Kinetic Field Emitter.]
    -> study_emitter
* { has_kinetic_emitter and not emitter_equipped } [Equip the Kinetic Field Emitter.]
    -> equip_emitter
* [Continue on.]
    -> scene_6_first_test
+ [Check Status.]
    -> check_status(-> post_rival_encounter)

= rest_a_moment
You find a relatively dry piece of rubble to sit on, closing your eyes for a moment to let the exhaustion wash over you. After a few minutes, you feel a bit more clear-headed. The fatigue subsides.
~ is_fatigued = false
-> post_rival_encounter

= look_for_moss
You scan the damp, shadowy corners of the plaza, looking for any signs of the glowing fungus you saw in the maintenance bay.
{ perception >= 6:
    // Success
    Your sharp eyes spot a small patch clinging to the underside of a collapsed archway. You carefully scrape a sample into a pouch.
    ~ glimmer_moss_stack += 1
- else:
    // Failure
    The plaza is picked clean. There's nothing here that can help you. You'll have to push on despite your injuries.
}
-> post_rival_encounter

= equip_emitter
~ emitter_equipped = true
You strap the Kinetic Field Emitter to your forearm. It feels heavy, but hums with a responsive energy. You feel more dangerous.

// Recalculate all stats to apply the new equipment bonus
~ update_combat_stats()

<i>AI: "Emitter equipped. Unit has {emitter_charges} charges remaining. Attack is now {atk}."</i>
-> post_rival_encounter
    
= study_emitter
~ studied_emitter = true
You take a closer look at the device you won from your rival. It's a heavy, metallic object that hums with a low, contained energy.
{ character_name == "Aris":
    // Aris is a tech expert
    You carefully pry open a maintenance hatch, your multi-tool tracing the alien circuitry. The design is elegant, almost organic. Understanding a fraction of its power source feels like unlocking a new law of physics. Your mind expands with the possibilities.
    ~ intelligence += 1
    ~ update_combat_stats() // Recalculate stats
    <i>AI: "Intelligence increased to {intelligence}."</i>
}
{ character_name == "Lena":
    // Lena is a practical operative
    You handle the Emitter like a new weapon, testing its weight and grip. You spot a subtle calibration dial near the power conduit. A few careful adjustments, and the hum changes pitch, sounding more stable and efficient. You've learned to read its subtle cues.
    ~ perception += 1
    ~ update_combat_stats() // Recalculate stats
    <i>AI: "Perception increased to {perception}."</i>
}
{ character_name == "Kaelen":
    // Kaelen understands tools of war
    This thing is beyond you, but you understand tools of war. You run it through a series of power-on and power-off tests, getting a feel for its activation time and recoil. It's not a gun, but it is a weapon. Knowing you can master it settles your nerves.
    ~ resolve += 5
    <i>AI: "Resolve has stabilized."</i>
}
-> post_rival_encounter
