// === ECHO LAB: CHAPTER 1 - THE DROP ===
INCLUDE _variables.ink
INCLUDE _systems.ink
INCLUDE _detailChoice.ink
// This is the playable script for the first chapter of the game.

// === GAME_START ===
-> scene_1_impact


// === SCENE 1: IMPACT ===
=== scene_1_impact ===
Darkness.
Cold metal against your cheek. The low, thrumming hum of a machine you don't recognize.

A sudden, violent lurch throws you against your restraints. A single red light flashes in the cramped space, illuminating a small, grimy viewport.
Through it, you see a sight that makes your blood run cold: a shattered planet, pieces of its continents hanging silently in the black void of space, wreathed in a sickly green energy.

An alarm blares. The hum becomes a roar. The tiny pod you're in shudders as it hits the upper atmosphere, the viewport glowing white-hot.
This isn't a rescue. It's a re-entry.

The impact is absolute. Metal screams, your vision whites out, and then... nothing.
Silence.

-> scene_1a_half_awake

// === SCENE 1A: HALF-AWAKE ===
=== scene_1a_half_awake ===
Pain. A brief window of searing clarity in a sea of darkness. You're slumped forward in the wreckage of the drop pod, the emergency lights flickering erratically. An automated medical panel is open, its contents scattered. You see a blinking auto-injector with a green vial. A Neuro-Stim. Your vision is already starting to swim. You have just enough strength for one action.
* [Grab the Neuro-Stim.]
    Your fingers close around the cold metal of the injector just as you lose consciousness again. You managed to hold on to it.
    ~ neuro_stim_state = "AVAILABLE"
    -> scene_2_awakening
* [Try to brace yourself.]
    You instinctively try to curl into a defensive position, but the effort is too much. The darkness claims you completely.
    -> scene_2_awakening

// === SCENE 2: AWAKENING ===
=== scene_2_awakening ===
Your head throbs.
The AI implant in your brain comes online with a soft chime, its voice a calm whisper against the panic in your mind.
<i>"Implant activated. Vital signs are... suboptimal, but stable. Welcome to the Arena. You have been assigned to Test Site Echo-7."</i>

You try to remember who you are.
The name comes first, then the skills.
* [I am Kaelen "Rook" Vance, the Soldier.]
    ~ character_name = "Kaelen"
    ~ strength = 7
    ~ intelligence = 3
    ~ agility = 4
    ~ perception = 5
    // Combat Stats
    ~ max_hp = 25
    ~ hp = 25
    ~ atk = 6
    ~ def = 3
    ~ player_skills = (Survivalist)
    ~ update_combat_stats()
    ~ hp = max_hp           // Set current HP to full for the start of the game
    -> scene_3_the_first_room
* [I am Dr. Aris Thorne, the Bio-Hacker.]
    ~ character_name = "Aris"
    ~ strength = 3
    ~ intelligence = 8
    ~ agility = 4
    ~ perception = 6
    // Combat Stats
    ~ max_hp = 18
    ~ hp = 18
    ~ atk = 3
    ~ def = 5
    ~ player_skills = (BioScan)
    ~ update_combat_stats()
    ~ hp = max_hp           // Set current HP to full for the start of the game
    -> scene_3_the_first_room
* [I am Lena "Ghost" Petrova, the Infiltrator.]
    ~ character_name = "Lena"
    ~ strength = 4
    ~ intelligence = 5
    ~ agility = 7
    ~ perception = 8
    // Combat Stats
    ~ max_hp = 20
    ~ hp = 20
    ~ atk = 5
    ~ def = 2
    ~ player_skills = (DiscerningEye)
    ~ update_combat_stats()
    ~ hp = max_hp           // Set current HP to full for the start of the game
    -> scene_3_the_first_room

// === SCENE 3: THE FIRST ROOM ===
=== scene_3_the_first_room ===
The door of your drop pod hisses open, dumping you onto a floor of cracked concrete slick with rainwater and alien moss.
<i>AI: "Location confirmed. Maintenance Bay. Zone designation: Ruined City-Isle."</i>

You're in a cavernous, ruined maintenance bay. The air is thick with the smell of ozone and decay. A single emergency light casts long, dancing shadows across shattered computer terminals and the skeletal remains of what might have been a maintenance worker.
Across the room, you see a patch of faintly glowing moss clinging to a damp wall. Next to it is a heavy, rusted metal locker. The only way out is a collapsed doorway to the north, choked with rubble but passable.
-> scene_3_choices

=== scene_3_choices ===
* [Investigate the rusted locker.]
    -> locker_encounter 
* [Investigate the glowing moss.]
    -> moss_encounter     
* [Query the AI.]
    -> scene_3_ai_query
* [Use Skill]
        -> use_skill
+ [Check Status.]
    -> check_status(-> scene_3_choices)
+ {has_degraded_power_cell || glimmer_moss_stack > 0 || found_first_log} [Analyze Items.]
    -> analyze_items
* [Leave through the collapsed doorway.]
    -> scene_4_the_first_obstacle

// === SCENE 4: THE FIRST OBSTACLE ===
=== scene_4_the_first_obstacle ===
To reach the plaza, you must navigate a short but unstable transit tunnel. The floor is a mess of twisted metal and rubble, and the ceiling groans under the strain.
* [BRUTE FORCE: Shove a large piece of debris to create a stable, direct path.]
    { character_name == "Kaelen":
        // Success
        You use your natural talents to pass through the tunnel unharmed.
    - else:
        // Failure
        Your attempt is clumsy. A piece of rubble gives way, and the strain affects your core skills.
        { character_name == "Aris":
            You receive a -1 debuff to Intelligence.
            ~ intelligence -= 1
            ~ scene_4_debuff_stat = "Intelligence"
            ~ update_combat_stats() // Recalculate stats
        - else: // Lena
            You receive a -1 debuff to Agility.
            ~ agility -= 1
            ~ scene_4_debuff_stat = "Agility"
            ~ update_combat_stats() // Recalculate stats
        }
    }
    -> scene_5_crossroads
* [ANALYZE: Scan the structure for the most stable route.]
    { character_name == "Aris":
        // Success
        You use your natural talents to pass through the tunnel unharmed.
    - else:
        // Failure
        Your attempt is ill-suited to your skills, and the mental effort affects your core abilities.
        { character_name == "Kaelen":
            You receive a -1 debuff to Strength.
            ~ strength -= 1
            ~ scene_4_debuff_stat = "Strength"
            ~ update_combat_stats() // Recalculate stats
        - else: // Lena
            You receive a -1 debuff to Agility.
            ~ agility -= 1
            ~ scene_4_debuff_stat = "Agility"
            ~ update_combat_stats() // Recalculate stats
        }
    }
    -> scene_5_crossroads
* [NAVIGATE: Nimbly climb through the quickest, most dangerous path.]
    { character_name == "Lena":
        // Success
        You use your natural talents to pass through the tunnel unharmed.
    - else:
        // Failure
        Your attempt is clumsy, and the physical toll weakens your primary strengths.
        { character_name == "Kaelen":
            You receive a -1 debuff to Strength.
            ~ strength -= 1
            ~ scene_4_debuff_stat = "Strength"
            ~ update_combat_stats() // Recalculate stats
        - else: // Aris
            You receive a -1 debuff to Intelligence.
            ~ intelligence -= 1
            ~ scene_4_debuff_stat = "Intelligence"
            ~ update_combat_stats() // Recalculate stats
        }
    }
    -> scene_5_crossroads

// === SCENE 5: THE CROSSROADS & THE ANNOUNCEMENT ===
=== scene_5_crossroads ===
You emerge into a larger area with two clear paths: one leading up towards the rooftops, the other down into a subway entrance.
Suddenly, a booming, disembodied voice echoes through the plaza.
<br><br>
<i>PROCTOR: "Major Event initiated: The Drop. A high-tier supply cache will arrive at the central plaza in 90 seconds. Competition is encouraged."</i>
<br><br>
* [Go for the Supply Drop.] -> scene_5a_the_cache
* [Ignore the Drop and find a safer path.] -> scene_6_first_test
+ [Check Status.]
    -> check_status(-> scene_5_crossroads)
* [Query the AI.]
    -> scene_5_ai_query

= scene_5_ai_query
The AI is silent for a moment before responding.
* (ask_proctor) [Ask: "Who was that?"]
    <i>AI: "That was the Proctor. It administrates the trials."</i>
    -> scene_5_ai_query
* (ask_drop) [Ask: "What is this 'Supply Drop'?"]
    <i>AI: "A resource distribution event. It is designed to test subjects' risk-assessment and acquisition capabilities under pressure."</i>
    -> scene_5_ai_query
* [That's all I need.]
    -> scene_5_crossroads

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
    ~ enemy_is_poisoned = false
    ~ poison_turns_remaining = 0
    -> rival_battle_loop

= rival_battle_loop
    You have {hp}/{max_hp} HP. Your rival has {rival_hp}/{rival_max_hp} HP.
    + [Attack!]
        -> rival_player_attack
    + { character_name == "Aris" and has_moss_poison_vial > 0 } [Use Moss Poison ({has_moss_poison_vial} left)]
        -> rival_use_moss_poison
    + { character_name == "Aris" and has_poison_bomb } [Use Poison Bomb]
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
    ~ has_poison_bomb = false
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
    ~ temp p_multiplier = RANDOM(8, 12) / 10.0
    ~ temp p_base_dmg = atk - rival_def
    { p_base_dmg < 1: 
        ~ p_base_dmg = 1
    }
    ~ temp p_final_dmg = INT(p_base_dmg * p_multiplier)
    ~ rival_hp -= p_final_dmg
    You attack your rival, dealing {p_final_dmg} damage!
    
    { rival_hp <= rival_max_hp / 2:
        -> rival_battle_win
    - else:
        -> rival_enemy_turn
    }

= rival_enemy_turn
    { 
    - rival_will_miss_next_turn:
        ~ rival_will_miss_next_turn = false
        Using the opening you spotted, you easily sidestep your rival's clumsy attack. It misses completely.
        -> rival_battle_loop
    - else:
        // --- Rival's Turn ---
        enemy_is_poisoned:
        ~ poison_turns_remaining -= 1
        Your rival winces as the poison takes effect, dealing 4 damage.
        ~ rival_hp -= 4
        { poison_turns_remaining <= 0:
            ~ enemy_is_poisoned = false
            The poison wears off.
        }
        ~ temp current_def = def
        { is_defending:
            ~ current_def = def + 3 // Temporarily boost defense
        }
        
        ~ temp r_multiplier = RANDOM(8, 12) / 10.0
        ~ temp r_base_dmg = rival_atk - current_def
        { r_base_dmg < 1: 
            ~ r_base_dmg = 1
        }
        ~ temp r_final_dmg = INT(r_base_dmg * r_multiplier)
        ~ hp -= r_final_dmg
        Your rival counters, hitting you for {r_final_dmg} damage!
        
        ~ is_defending = false // Reset defense state for the next turn
        
        { hp <= max_hp / 2:
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
    -> post_rival_encounter

= rival_battle_lose_choice
The blow sends you staggering back. You're injured and losing the fight, but there might be a way out of this.
* { analyzed_power_cell } [Use the Degraded Power Cell!]
    You pull out the unstable power cell. It's a desperate gambit. You hurl it at the supply cache. The resulting explosion is deafening, frying the crate's contents and forcing your rival to dive for cover. The prize is gone, but you've denied them the victory.
    ~ has_degraded_power_cell = false
    ~ has_kinetic_emitter = false
    ~ rival_has_emitter = false
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
    -> scene_6_first_test

= rival_battle_win
Your final blow connects, and your rival stumbles back, winded and defeated. The fight is over. You've won. You claim the **Kinetic Field Emitter** from the supply cache.
~ has_kinetic_emitter = true
~ rival_has_emitter = false
~ emitter_charges = 3 // Emitter starts with 3 charges
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
    -> use_glimmer_moss
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

= use_glimmer_moss
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
    ~ glimmer_moss_stack -= 1
    ~ is_injured = false

    // --- RANDOM ATTACK CHECK ---
    ~ temp attack_chance = RANDOM(1, 4)
    { attack_chance == 1:
        As the glow fades, you hear a frantic chittering sound. A small, rat-like creature with pale skin darts out from a crack in the wall, attracted by the moss's sweet scent. It nips at your boot before you can react, then vanishes back into the darkness. It didn't hurt, but the startling encounter has left you on edge.
        ~ resolve -= 3
    }
    
    -> post_rival_encounter


// === SCENE 6: THE FIRST TEST ===
=== scene_6_first_test ===
{ scene_5a_the_cache > 0:
    You move on from the plaza, the encounter with your rival leaving a sour taste in your mouth.
- else:
    You decide to avoid the confrontation at the plaza, heading for a less obvious route.
}
You have a choice of paths ahead, one leading up, the other down.
* [Take the high ground. Head for the rooftops.]
    -> scene_6a_rooftops
* [Descend into the darkness. Take the subway.]
    -> scene_6b_subway

// --- PATH A: THE ROOFTOPS TEST ---
=== scene_6a_rooftops ===
You follow a treacherous path across rusted gantries to the base of a massive, dilapidated communications tower clinging to the side of a skyscraper. The AI's voice chimes in.
<i>AI: "Archivist Test Chamber detected. Objective: Retrieve Data Fragment from the tower's broadcast antenna. Warning: Structural integrity is compromised."</i>
The wind howls around you. It's a long, dangerous climb.
* [Begin the Climb - Agility Check]
    ~ temp roll = RANDOM(1, 6)
    ~ temp total_skill = agility + roll
    { total_skill >= 10:
        // SUCCESS
        You move with grace and speed, the dizzying height feeling like home. You easily navigate the broken ladders and exposed rebar, retrieving the **first Data Fragment** from the antenna array at the top.
        ~ data_fragments += 1
        -> scene_7_the_fragment
    - else:
        // FAILURE
        A handhold crumbles under your grip, and a gust of wind throws you off balance. You fall a short distance, slamming into a lower platform. Wounded and aching, you realize you can't reach the top from here.
        <i>AI: "Subject has failed the test. Data Fragment unretrievable."</i>
        ~ resolve -= 10
        ~ is_injured = true
        -> scene_8_the_tower
    }

// --- PATH B: THE SUBWAY TEST ---
=== scene_6b_subway ===
    You descend into a flooded subway station, lit by the eerie green glow of moss. In the center of the platform is a functioning Archivist terminal, humming with power.
    <i>AI: "Archivist Test Chamber detected. Objective: Access the terminal to download one Data Fragment."</i>
    A single, powerful Slick-skinned Skulker guards the terminal, its eyeless head twitching at every sound.
    
    * { know_skulker_weakness } [Use your knowledge of its weakness.]
        -> exploit_skulker_weakness
        
    * { has_kinetic_emitter and emitter_charges > 0 and emitter_equipped} [Use the Emitter's concussive blast ({emitter_charges} left).]
        -> use_emitter_on_skulker
        
    * { has_kinetic_emitter and emitter_charges <= 0 } [Attempt to use the broken Emitter.]
        You raise the Emitter and try to activate it, but it remains silent and cold. The power is completely spent. It's useless.
        -> scene_6b_subway
        
    * [Engage the Skulker]
        -> engage_skulker_setup

    * [Sneak to the Terminal]
        -> sneak_past_skulker
        
    * [Analyze the Environment]
        -> analyze_skulker_env
        
= exploit_skulker_weakness
    Remembering the Archivist Log, you tell your implant to emit a high-frequency sonic pulse. The AI complies. A piercing, silent-to-you shriek fills the subway. The Skulker instantly recoils, thrashing in agony as its sensitive auditory organs overload. It collapses, twitching, completely incapacitated.
    The path to the terminal is clear. Your intel paid off.
    -> skulker_defeated_hub
        
= use_emitter_on_skulker
    { use_emitter_charge():
        // The function returned true, so the usage was successful.
        The blast hits the Skulker, sending it flying backwards into the tunnel wall with a wet smack. It's stunned and incapacitated. The path to the terminal is clear, and you easily download the **first Data Fragment**.
        -> skulker_defeated_hub
    }

= engage_skulker_setup
    // Set the global variables for this specific enemy
    ~ current_enemy_name = "Slick-Skinned Skulker"
    ~ current_enemy_hp = 15
    ~ current_enemy_atk = 8
    ~ current_enemy_def = 2
    ~ used_skill_in_battle = false
    ~ rival_will_miss_next_turn = false // Re-using this for any enemy
    ~ enemy_is_poisoned = false
    ~ poison_turns_remaining = 0
    The Skulker lets out a piercing shriek and lunges!
    -> skulker_battle_loop

= skulker_battle_loop
    You have {hp}/{max_hp} HP. The {current_enemy_name} has {current_enemy_hp} HP.
    + [Attack!]
        -> skulker_player_attack
    * [Defend]
        ~ is_defending = true
        You brace for the Skulker's attack, readying your defenses.
        -> skulker_enemy_turn

= skulker_player_attack
    // --- Player's Turn ---
    ~ temp p_multiplier = RANDOM(8, 12) / 10.0
    ~ temp p_base_dmg = atk - current_enemy_def
    { p_base_dmg < 1: 
        ~ p_base_dmg = 1
    }
    ~ temp p_final_dmg = INT(p_base_dmg * p_multiplier)
    ~ current_enemy_hp -= p_final_dmg
    You attack the Skulker, dealing {p_final_dmg} damage!
    
    { current_enemy_hp <= 0:
        -> skulker_win
    - else:
        -> skulker_enemy_turn
    }

= skulker_enemy_turn
    // --- Skulker's Turn ---
    ~ temp current_def = def
    { is_defending:
        ~ current_def = def + 3 // Temporarily boost defense
    }
    
    ~ temp r_multiplier = RANDOM(8, 12) / 10.0
    ~ temp r_base_dmg = current_enemy_atk - current_def
    { r_base_dmg < 1: 
        ~ r_base_dmg = 1
    }
    ~ temp r_final_dmg = INT(r_base_dmg * r_multiplier)
    ~ hp -= r_final_dmg
    The Skulker counters, hitting you for {r_final_dmg} damage!
    
    ~ is_defending = false // Reset defense state for the next turn
    
    {
        - hp <= 0:
            -> battle_lost
        - hp <= max_hp / 2:
            -> skulker_battle_run_or_fight
        - else:
            -> skulker_battle_loop
    }

= skulker_battle_run_or_fight
    The creature's blow wounds you badly. You're hurt, but you see a chance to disengage and escape.
    * [Continue Fighting]
        You grit your teeth and press the attack, ignoring the pain.
        -> skulker_battle_loop
    * [Run Away]
        You take the opening and scramble back into the flooded tunnels. The Skulker shrieks in frustration but doesn't follow. You've escaped, but failed the test.
        <i>AI: "Subject has failed the test. Data Fragment unretrievable."</i>
        ~ resolve -= 10
        ~ is_injured = true
        -> scene_8_the_tower

= sneak_past_skulker
    // Agility Check
    ~ temp roll = RANDOM(1, 6)
    ~ temp total_skill = agility + roll
    { total_skill >= 10:
        // Success
        You slip through the shadows, your footsteps silent in the shallow water. The creature never senses you as you reach the terminal, download the **first Data Fragment**, and slip away.
        ~ data_fragments += 1
        -> scene_7_the_fragment
    - else:
        // Failure
        A loose piece of debris clatters under your foot. The Skulker shrieks and lunges. You barely manage to escape its claws, retreating with your heart pounding in your chest.
        <i>AI: "Subject has failed the test. Data Fragment unretrievable."</i>
        ~ resolve -= 10
        ~ hp -= 5
        ~ is_injured = true
        -> scene_8_the_tower
    }
    
= analyze_skulker_env
    // Intelligence Check
    ~ temp roll = RANDOM(1, 6)
    ~ temp total_skill = intelligence + roll
    { total_skill >= 11:
        // Success
        You notice a leaking water pipe on the ceiling directly above a sparking, exposed power conduit near the creature. You throw a piece of rubble, shattering the pipe. Water gushes onto the conduit, creating a massive electrical surge that incapacitates the Skulker. You download the **first Data Fragment**.
        ~ data_fragments += 1
        -> scene_7_the_fragment
    - else:
        // Failure
        You see a potential environmental advantage but miscalculate. Your attempt to create a distraction only succeeds in making a loud noise, drawing the Skulker's immediate, aggressive attention. You are forced to flee.
        <i>AI: "Subject has failed the test. Data Fragment unretrievable."</i>
        ~ resolve -= 10
        -> scene_8_the_tower
    }

= setup_skulker_battle
    // Set the global variables for this specific enemy
    ~ current_enemy_name = "Slick-Skinned Skulker"
    ~ current_enemy_hp = 15
    ~ current_enemy_atk = 5
    ~ current_enemy_def = 2
    -> battle_loop // Now, start the battle loop


    
// === SPECIAL DEFEAT SCENE ===
=== scene_6c_skulker_lair ===
Darkness... and the stench of decay and damp earth. You wake with a gasp, every muscle screaming in protest. Your head throbs where the Skulker struck you.

You're in a narrow cavern, barely lit by patches of glowing moss. It seems to be the creature's nest, built from scavenged metal and a strange, hardened resin. The Skulker that defeated you is here, its pale back to you, noisily chewing on some unidentifiable piece of carrion. You are weak, and your gear is scattered just out of reach.

You see one clear exit, a narrow tunnel leading back up into the subway system. This is your only chance.

* [Try to sneak past it - Agility Check]
    -> escape_lair_sneak

* [Create a diversion - Intelligence Check]
    -> escape_lair_diversion

= escape_lair_sneak
    ~ temp roll = RANDOM(1, 6)
    ~ temp total_skill = agility + roll
    { total_skill >= 12:
        // Success
        You move with absolute silence, your body hugging the shadows. The creature is too engrossed in its meal to notice as you slip past and into the tunnel, escaping back into the subway proper. You've survived, but you failed to get the Data Fragment.
        -> scene_8_the_tower
    - else:
        // Failure
        A loose rock shifts under your foot. The Skulker's head whips around, its eyeless face emitting a piercing shriek. It lunges. This time, there is no escape.
        -> game_over_death
    }

= escape_lair_diversion
    ~ temp roll = RANDOM(1, 6)
    ~ temp total_skill = intelligence + roll
    { total_skill >= 11:
        // Success
        You spot a loose chunk of metal propped precariously above a far corner of the nest. You grab a small stone and toss it with perfect aim. The metal sheet clatters to the ground, and the Skulker screeches, darting towards the sound. The distraction gives you the precious seconds you need to scramble into the exit tunnel.
        -> scene_8_the_tower
    - else:
        // Failure
        Your throw is off. The stone clinks uselessly against the wall, only serving to draw the creature's immediate attention directly to you. It shrieks and attacks.
        -> game_over_death
    }
    
// === SCENE 7: THE FRAGMENT ===
=== scene_7_the_fragment ===
You now possess your first Data Fragment. It's a small, crystalline object that hums with a faint energy and feels strangely warm to the touch. As you inspect it, the AI's voice chimes in your head.
-> fragment_dialogue

= fragment_dialogue
    // --- Kaelen's Dialogue ---
    { character_name == "Kaelen":
        <i>AI: "First Data Fragment acquired. Two remaining."</i>
        * (ask_next) ["Cut the chatter. Where's the next one?"]
            <i>AI: "Triangulating... Energy signatures are inconsistent. Further data is required to pinpoint the next fragment's exact location."</i>
            -> fragment_dialogue
        * (ask_what) ["What is this thing, really?"]
            <i>AI: "A data key. It contains positioning algorithms. Useless individually, but invaluable when combined."</i>
            -> fragment_dialogue
    }
    
    // --- Aris's Dialogue ---
    { character_name == "Aris":
        <i>AI: "First Data Fragment acquired. Analysis suggests it is a complex bio-organic data storage medium."</i>
        * (ask_structure) ["Fascinating. Is the crystalline structure naturally occurring?"]
            <i>AI: "Negative. It is a manufactured lattice, grown around a quantum processing core. The technology is far beyond your civilization's understanding."</i>
            -> fragment_dialogue
        * (ask_keys) ["So these 'fragments' are the keys to progression?"]
            <i>AI: "A logical deduction. Mastery of the environment is the metric for success. Acquiring all fragments is the primary indicator of mastery for this phase."</i>
            -> fragment_dialogue
    }

    // --- Lena's Dialogue ---
    { character_name == "Lena":
        <i>AI: "First Data Fragment acquired. Be advised, its energy signature may be detectable by other subjects."</i>
        * (ask_mask) ["Can I mask the signature?"]
            <i>AI: "Possible, with the correct dampening materials. However, such materials are not currently in your possession."</i>
            -> fragment_dialogue
        * (ask_secrets) ["What aren't you telling me about these things?"]
            <i>AI: "My function is to provide necessary data for the experiment. The purpose of the experiment itself is data available only to the Proctor."</i>
            -> fragment_dialogue
    }
    
    // --- Continue option for all characters ---
    * [Got it. Let's move.]
        The AI gives you a general direction for the next fragment's energy signature. It's time to move on.
        -> scene_7_scavenge

// === SCENE 7: SCAVENGING ===
=== scene_7_scavenge ===
Knowing you'll need more than just wits to survive, you decide to scavenge the immediate area before moving on.
{ scene_6a_rooftops > 0: // Rooftops context
    The wreckage of the comms tower is a tangled mess of metal supports and snapped cables.
}
{ scene_6b_subway > 0: // Subway context
    The derelict subway cars and dark maintenance tunnels are full of old, decaying equipment.
}

* [Search for useful components.]
    -> scavenge_action
* [Ignore scavenging and move on to crafting.]
    -> scene_7a_gearing_up

= scavenge_action
    You spend some time carefully picking through the debris.
    { character_name == "Kaelen":
        Your strength allows you to pry open a sealed maintenance hatch that others couldn't budge. Inside, you find a sturdy metal pipe and a spool of thick wiring, perfect for a weapon.
        ~ has_metal_pipe = true
        ~ has_thick_wiring = true
    }
    { character_name == "Lena":
        Your sharp eyes spot a high-tensile cable still intact amidst the chaos, and you deftly cut it free. Nearby, a shattered wall panel contains a sheet of flexible polymer, exactly what you need for a bow limb.
        ~ has_flexible_polymer = true
        ~ has_tensile_cable = true
    }
    { character_name == "Aris":
        Your trained eyes spot useful components that others would dismiss as junk. You salvage some intact copper wires and a magnetic coil from a ruined transformer.
        ~ has_copper_wiring = true
        ~ has_magnetic_coil = true
        { not has_degraded_power_cell:
             // If Aris used the first one, he can find another
             Tucked away inside the transformer's casing is another Degraded Power Cell, apparently undamaged by the overload. A lucky find.
             ~ has_degraded_power_cell = true
        }
    }
    You've gathered what you can.
    -> scene_7a_gearing_up

// === SCENE 7A: GEARING UP ===
=== scene_7a_gearing_up ===
Before you proceed, you find a relatively sheltered alcove in the ruins to catch your breath and take stock of what you have. This is a good opportunity to prepare for what's ahead.
* [Use your resources to craft something useful.]
    -> crafting_options
* { not has_reinforced_club and not has_recurve_bow and not has_emp_grenade } [Save your resources and move on.]
    -> scene_8_the_tower
* { has_reinforced_club or has_recurve_bow or has_emp_grenade } [You are prepared. Move on.]
    -> scene_8_the_tower
+ [Check Status]
    -> check_status( -> scene_7a_gearing_up)

= crafting_options
    You lay out your scavenged materials.
    
    // Kaelen's Crafting Option
    * { character_name == "Kaelen" and not has_reinforced_club and has_metal_pipe and has_thick_wiring } [Fashion a Reinforced Club.]
        You take the sturdy metal pipe and thick wiring you found. Using your strength, you wrap the wiring tightly around one end, creating a weighted, brutal-looking club. It feels solid in your hands.
        ~ has_reinforced_club = true
        ~ atk += 2
        -> crafting_options

    // Aris's Crafting Option
    * { character_name == "Aris" and has_degraded_power_cell and not has_emp_grenade } [Assemble an EMP Grenade.]
        You carefully pry open the casing of the Degraded Power Cell. Bypassing the safety regulators, you rig it to overload on impact. It's a volatile, single-use weapon, perfect for disabling electronics... or stunning biological targets.
        ~ has_emp_grenade = true
        ~ has_degraded_power_cell = false // The cell is consumed
        -> crafting_options
    * { character_name == "Aris" and glimmer_moss_stack > 0 } [Refine Glimmer Moss into Poison.]
        You crush the Glimmer Moss, carefully isolating the coagulant you discovered earlier. By mixing it with a mild solvent from your kit, you refine it into a sticky, paralytic poison. You place it in an empty vial, ready for use.
        ~ has_moss_poison_vial += 1
        ~ glimmer_moss_stack -= 1
        -> crafting_options
    * { character_name == "Aris" and has_skulker_venom_gland and has_degraded_power_cell and not has_poison_bomb } [Create a Poison Gas Bomb.]
        This is a dangerous idea... but a brilliant one. You carefully puncture the Skulker's venom gland, siphoning the potent neurotoxin into the casing of the Degraded Power Cell. You rig the cell to overload, not with an EMP, but with a thermal charge that will aerosolize the venom on impact. A devastating biological weapon.
        ~ has_poison_bomb = true
        ~ has_skulker_venom_gland = false
        ~ has_degraded_power_cell = false
        -> crafting_options

    // Lena's Crafting Option
    * { character_name == "Lena" and not has_recurve_bow and has_flexible_polymer and has_tensile_cable } [Construct a Recurve Bow.]
        You take the length of flexible polymer and the high-tensile cable. With your deft hands, you shape the polymer and string the cable, creating a makeshift but deadly silent bow. You'll need to find arrows, but the frame is perfect.
        ~ has_recurve_bow = true
        -> crafting_options
    
    // Equip Options
    * { has_reinforced_club and not club_equipped } [Equip the Reinforced Club.]
        ~ club_equipped = true
        You grip the club tightly. It's a crude but effective weapon. Your Attack has increased.
        ~ update_combat_stats()
        -> crafting_options
    * { has_recurve_bow and not bow_equipped } [Equip the Recurve Bow.]
        ~ bow_equipped = true
        You sling the bow over your shoulder. You'll be able to strike from the shadows. Your Attack has increased.
        ~ update_combat_stats()
        -> crafting_options

    * [That's all for now.]
        -> scene_7a_gearing_up


// === SCENE 8: THE TOWER CLIMB ===
=== scene_8_the_tower ===
Following the AI's directions, you arrive at the base of another massive communications spire. This one is different—a single emergency light pulses at the very top, indicating the location of the next Data Fragment. The main entrance is sealed, but a service ladder leads up to the first floor landing. The climb has begun.
-> tower_floor_1

= tower_floor_1
You haul yourself onto the first-floor landing, a wide platform of rusted metal grating. A lithe contestant, the "Scrambler," is already there. They see you, grin, and make a dash for the stairs to the next level.
<i>PROCTOR: "First subject to ascend demonstrates superior traversal capability."</i>

* [Beat them to the stairs - Agility Check]
    ~ temp roll = RANDOM(1, 6)
    ~ temp total_skill = agility + roll
    { total_skill >= 12:
        // Success
        You're faster. You easily bound over the obstacles and cut them off, claiming the path upwards. They scowl and retreat to find another way.
    - else:
        // Failure
        They're too quick, vaulting over a railing while you're still navigating the debris. They're gone before you can catch them. The path is clear, but your pride is stung.
        ~ resolve -= 3
    }
    -> tower_floor_2

=== tower_floor_2 ===
The second floor is a cramped server room. A hulking figure, the "Brute," blocks the only doorway, cracking their knuckles. "Tower's mine," they grunt. "Get lost or get broken." This will be a fight.
-> setup_brute_battle

=== tower_floor_3 ===
After defeating the Brute, you ascend to the third floor, a darkened observation deck. You don't see anyone, but your instincts scream "trap."
<i>PROCTOR: "First subject to bypass the obstacle demonstrates superior situational awareness."</i>
* [Scan for the trap - Perception/Intelligence Check]
    ~ temp roll = RANDOM(1, 6)
    ~ temp total_skill = perception + intelligence + roll
    { total_skill >= 18:
        // Success
        { character_name == "Aris": Your AI implant flags a hidden pressure plate wired to a jury-rigged arc welder. A nasty trap. | Your eyes catch the faint shimmer of a tripwire connected to a weighted net. Amateurish, but deadly.} You easily disable it. A shadowy figure, the "Ghost," curses from the far side of the room and flees upwards.
    - else:
        // Failure
        You step forward and a trap springs! A heavy cargo net drops from the ceiling, entangling you. It takes you precious moments to cut yourself free. You've lost time, and the Ghost is long gone.
        ~ is_fatigued = true
    }
    -> tower_floor_4

= tower_floor_4
The fourth floor is a chaotic workshop, filled with sparking contraptions. A contestant in a customized tech-suit, the "Tinkerer," is working on a device. "Ah, a new test subject!" they exclaim, leveling a whirring gadget at you.
-> setup_tinkerer_battle

=== tower_floor_5 ===
You reach the final floor before the spire's peak. A contestant with cold, professional eyes, the "Veteran," stands waiting for you. They hold a sharpened piece of rebar like a short sword. "Only one of us gets that fragment," they say calmly. "Let's make this quick."
-> setup_veteran_battle

=== tower_top ===
Panting and bruised, you finally reach the open-air platform at the peak of the tower. The emergency light flashes on the console where the **second Data Fragment** is waiting. You take it.
~ data_fragments += 1
-> scene_9_the_bargain // Now points to the correct next scene

// --- Tower Battle Setups ---
=== setup_brute_battle ===
    ~ current_enemy_name = "The Brute"
    ~ current_enemy_hp = 30
    ~ current_enemy_atk = 7
    ~ current_enemy_def = 4
    -> battle_loop
    
=== setup_tinkerer_battle ===
    ~ current_enemy_name = "The Tinkerer"
    ~ current_enemy_hp = 20
    ~ current_enemy_atk = 8
    ~ current_enemy_def = 2
    -> battle_loop
    
=== setup_veteran_battle ===
    ~ current_enemy_name = "The Veteran"
    ~ current_enemy_hp = 25
    ~ current_enemy_atk = 7
    ~ current_enemy_def = 3
    -> battle_loop

// === SCENE 9: THE BARGAIN (Placeholder) ===
=== scene_9_the_bargain ===
With your second Data Fragment secured, you continue on.
...To be continued...
-> END

