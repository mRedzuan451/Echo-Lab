// === ECHO LAB: CHAPTER 1 - THE DROP ===
// This is the playable script for the first chapter of the game.

// === VARIABLE DEFINITIONS ===
// Character stats
VAR strength = 0
VAR intelligence = 0
VAR agility = 0
VAR perception = 0
VAR resolve = 100

// Character Status
VAR is_fatigued = false
VAR is_injured = false

// Player's chosen name
VAR character_name = ""

// Inventory Flags (true = has, false = doesn't have)
VAR has_degraded_power_cell = false
VAR has_glimmer_moss_sample = false
VAR has_kinetic_emitter = false

// === SKILL SYSTEM ===
LIST AllSkills = Survivalist, BioScan, DiscerningEye
VAR player_skills = ()

// Consequence Flags
VAR jed_status = "UNKNOWN" // Can be UNKNOWN, HELPED, HOSTILE, DEAD
VAR scene_4_debuff_stat = "" // To track debuff from Scene 4
VAR rival_has_emitter = false

// Data Fragments
VAR data_fragments = 0

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
    // (Future equipment bonuses would go here)
    
    ~ return true

// Global Combat State Variables
VAR current_enemy_name = ""
VAR current_enemy_hp = 0
VAR current_enemy_atk = 0
VAR current_enemy_def = 0
VAR is_defending = false

// Rival Battle Stats & Flags
VAR rival_hp = 0
VAR rival_max_hp = 0
VAR rival_atk = 0
VAR rival_def = 0

// Analyzed item
VAR analyzed_power_cell = false
VAR analyzed_glimmer_moss = false
VAR studied_emitter = false

VAR emitter_charges = 0

// === ITEM FUNCTIONS ===
=== function use_emitter_charge() ===
    { has_kinetic_emitter and emitter_charges > 0:
        ~ emitter_charges -= 1
        The Kinetic Field Emitter discharges with a powerful hum.
        { emitter_charges == 0:
            A final surge of power leaves the device inert, its internal mechanisms fused. It's broken for good.
        }
        ~ return true
    - else:
        ~ return false
    }

// Equip Item
VAR emitter_equipped = false

// === GAME START ===
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
+ [Use Skill]
        -> use_skill
+ [Check Status.]
    -> check_status(-> scene_3_choices)
+ {has_degraded_power_cell || has_glimmer_moss_sample} [Analyze Items.]
    -> analyze_items
* [Leave through the collapsed doorway.]
    -> scene_4_the_first_obstacle

// === SKILL MECHANICS ===
=== use_skill ===
You focus, preparing to use your unique training.
* { player_skills ? Survivalist and not used_survivalist_here } [Use Survivalist]
    ~ temp used_survivalist_here = true
    You scan the wreckage with a soldier's eye for anything useful. Amidst a pile of debris, you spot a small, intact water purifier unit from a standard-issue survival kit, likely overlooked by scavengers. A valuable find for later.
    // TODO: Add "Water Purifier" to inventory
    -> scene_3_choices
    
* { player_skills ? BioScan and not used_bioscan_here } [Use Bio-Scan]
    ~ temp used_bioscan_here = true
    You activate your implant's bio-scanner, sweeping the room. The patch of moss on the wall lights up in your vision.
    <i>AI: "Glimmer Moss. Bioluminescent fungus. Mildly regenerative properties. Caution: Spores are a known attractant for subterranean fauna."</i>
    -> scene_3_choices

* { player_skills ? DiscerningEye and not used_discerningeye_here } [Use Discerning Eye]
    ~ temp used_discerningeye_here = true
    You scan the room not for what's there, but for what's out of place. The wall behind the rusted locker seems... off. A slight discoloration, a seam that isn't quite right. You've found a hidden maintenance panel.
    // TODO: Add a new choice to scene_3_choices to open the panel
    -> scene_3_choices
    
* [Never mind.]
    -> scene_3_choices
    
= analyze_items
You take a moment to examine your findings.
* {has_degraded_power_cell} [Analyze the Degraded Power Cell.]
    ~ analyzed_power_cell = true
    { character_name == "Kaelen":
        - You tap the power cell against a metal strut. It sparks weakly. Looks like it has a little juice, but it feels unstable. Probably best not to hit it too hard.
    }
    { character_name == "Aris":
        - You run your multi-tool over the power cell. <i>AI: "Lithium-ion architecture, heavily degraded. Output is unstable, fluctuating between 3 and 19 volts. Could be repurposed for a directed electromagnetic pulse, with a moderate chance of catastrophic failure."</i> Fascinating.
    }
    { character_name == "Lena":
        - It's a standard power cell, the kind used in old maintenance drones. Heavy. You notice a small crack in the casing near the positive terminal. It might be volatile.
    }
    -> analyze_items
* {has_glimmer_moss_sample} [Analyze the Glimmer Moss Sample.]
    ~ analyzed_glimmer_moss = true
    { character_name == "Kaelen":
        - You rub the moss between your fingers. It's cool to the touch and leaves a faint glowing residue. Doesn't seem very useful, but it smells... sweet.
    }
    { character_name == "Aris":
        - You analyze the sample. <i>AI: "Fungal sample contains a unique bioluminescent enzyme and a mild coagulant. Spores are airborne. High probability of attracting local fauna."</i> Useful. The coagulant could be refined into a basic healing agent.
    }
    { character_name == "Lena":
        - The moss glows, but the light is faint. You recall seeing similar fungi in deep-cave infiltration missions. The spores are light enough to travel on air currents; anything that hunts by scent would be drawn to this.
    }
    -> analyze_items
* [Done analyzing.]
    -> scene_3_choices

=== check_status(-> return_to) ===
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
    { not has_degraded_power_cell and not has_glimmer_moss_sample and not has_kinetic_emitter:
        - Your pockets are empty.
    }
    { has_degraded_power_cell:
        - Degraded Power Cell
    }
    { has_glimmer_moss_sample:
        - Glimmer Moss Sample
    }
    { has_kinetic_emitter:
        - Kinetic Field Emitter ({emitter_charges} charges)
    }
    
    * [Return.]
        -> return_to
        
// === BATTLE MECHANIC ===
=== battle_loop ===
    // Display current status
    You have {hp} HP. The {current_enemy_name} has {current_enemy_hp} HP.
    
    * [Attack]
        -> player_attack
        
    * [Defend]
        ~ is_defending = true
        You brace for an attack, increasing your defense for this turn.
        -> enemy_turn
        
= player_attack
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

= enemy_turn
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

=== battle_won ===
The {current_enemy_name} collapses. You are victorious.
// Check which enemy was defeated to continue the correct story path
{ current_enemy_name == "Slick-Skinned Skulker":
    -> skulker_win
- else:
    // A default win case, in case you add other battles
    -> END
}

=== battle_lost ===
Your vision fades to black as the creature's final blow lands.
// Check which enemy defeated you
{ current_enemy_name == "Slick-Skinned Skulker":
    -> skulker_lose
- else:
    // A default lose case
    -> END
}

=== scene_3_ai_query ===
The AI's calm voice is a presence in your mind.
* (ask_where) [Ask: "Where am I?"]
    <i>AI: "You are within Test Site Echo-7, located on a fragment of a planetary body designated 'The Shattered World'. My designation for this zone is the 'Ruined City-Isle'."</i>
    -> scene_3_ai_query
* (ask_what) [Ask: "What is this place? What is the 'Arena'?"]
    <i>AI: "This 'Arena' is a controlled environment for a series of trials conducted by my creators, the Archivists. The objective is to test species' capacity for survival and adaptation."</i>
    -> scene_3_ai_query
* (ask_who) [Ask: "Who is the Proctor?"]
    <i>AI: "The Proctor is the master control AI for this entire experiment. My function is to guide and observe subjects. The Proctor's function is to administrate the trials."</i>
    -> scene_3_ai_query
* (ask_why) [Ask: "Why am I here?"]
    <i>AI: "Your selection criteria are not available in my data banks. Your purpose is to survive and demonstrate mastery of the environment. That is all the data I can provide on the subject."</i>
    -> scene_3_ai_query
* [That's enough for now.]
    -> scene_3_choices

=== locker_encounter ===
The locker is old and heavy. The locking mechanism is a simple electronic keypad, now dark and corroded. The door itself is dented and sealed shut with rust.

{ character_name == "Kaelen":
    // Kaelen's Action: Brute Force
    You plant your feet, grip the edge of the locker door, and pull with everything you've got.
    { strength >= 7:
        // Success
        The metal groans, shrieks, and finally tears open with a deafening CRUNCH. Inside, you find a **Degraded Power Cell**. It's heavy, but it might be useful.
        ~ has_degraded_power_cell = true
    - else:
        // Failure
        You throw your shoulder against the door, but it only groans in protest. The rust holds it fast. You've only succeeded in bruising your shoulder and making a lot of noise.
        ~ resolve -= 1
    }
}
{ character_name == "Aris":
    // Aris's Action: Hotwire
    You spot a frayed power conduit hanging from the ceiling. Rerouting the cable, you attempt to send a jolt of power to the corroded keypad.
    { intelligence >= 8:
        // Success
        It sparks to life for just a moment, long enough for the lock to disengage with a loud THUNK. Inside, you find a **Degraded Power Cell**. Fascinating.
        ~ has_degraded_power_cell = true
    - else:
        // Failure
        You try to create a circuit, but the components are too decayed. A final spark from the conduit singes your fingers and the keypad goes completely dead. It's useless now.
        ~ resolve -= 1
    }
}
{ character_name == "Lena":
    // Lena's Action: Lockpick
    The keypad is dead, but the manual override is still intact. Your deft fingers search for the tumblers.
    { agility >= 7:
        // Success
        With a series of satisfying clicks, the lock disengages. The door swings open silently. Inside, you find a **Degraded Power Cell**. A valuable find.
        ~ has_degraded_power_cell = true
    - else:
        // Failure
        You work at the lock, but the internal mechanism is rusted solid. A lockpick snaps with a sharp *tink*, leaving the lock hopelessly jammed. There's no getting in that way now.
        ~ resolve -= 1
    }
}
-> scene_3_choices

== moss_encounter ===
You move closer to the wall. The moss gives off a soft, ethereal green light. It pulses gently, like a slow heartbeat.

{ character_name == "Aris":
    // Aris's Action: Bio-Scan
    <i>AI: "Glimmer Moss. Bioluminescent fungus. Mildly regenerative properties. Caution: Spores are a known attractant for subterranean fauna."</i>
- else:
    // Kaelen/Lena's Action: Examine
    { perception >= 6:
        // Success
        You notice the ground beneath the moss is disturbed with small tracks, and you can smell a strange, sweet scent. This moss is more than just a pretty light; it's an active part of the ecosystem here.
    - else:
        // Failure
        It's a weird glowing plant. Looks cool, but you don't know anything else about it.
    }
}
-> harvest_moss
        
= harvest_moss
+   [Take a sample.]
    You scrape a handful of the glowing moss off the wall and store it in a pouch. It feels cool and damp to the touch.
    ~ has_glimmer_moss_sample = true
    -> scene_3_choices
+   [Leave it be.]
    -> scene_3_choices

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
        ~ rival_atk = 5
        ~ rival_def = 3
    }
    { character_name == "Aris": // Rival is Jinx
        ~ rival_max_hp = 18
        ~ rival_atk = 6
        ~ rival_def = 2
    }
    { character_name == "Lena": // Rival is Isha
        ~ rival_max_hp = 20
        ~ rival_atk = 5
        ~ rival_def = 4
    }
    ~ rival_hp = rival_max_hp
    -> rival_battle_loop

= rival_battle_loop
    You have {hp}/{max_hp} HP. Your rival has {rival_hp}/{rival_max_hp} HP.
    * [Attack!]
        -> rival_player_attack

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
    // --- Rival's Turn ---
    ~ temp r_multiplier = RANDOM(8, 12) / 10.0
    ~ temp r_base_dmg = rival_atk - def
    { r_base_dmg < 1: 
        ~ r_base_dmg = 1
    }
    ~ temp r_final_dmg = INT(r_base_dmg * r_multiplier)
    ~ hp -= r_final_dmg
    Your rival counters, hitting you for {r_final_dmg} damage!
    
    { hp <= max_hp / 2:
        -> rival_battle_lose_choice
    - else:
        -> rival_battle_loop
    }

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
{ hp <= max_hp / 4: // If HP is at 25% or less
    ~ is_injured = true
    ~ is_fatigued = false
    You're badly wounded, and every movement is a struggle.
- else: hp <= max_hp / 2: // If HP is at 50% or less
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
* { is_injured and not has_glimmer_moss_sample } [Look for something to treat your wounds.]
    -> look_for_moss
* { analyzed_glimmer_moss and has_glimmer_moss_sample } [Use the Glimmer Moss to tend to your wounds.]
    -> use_glimmer_moss
* [Continue on.]
    -> scene_6_first_test
* { has_kinetic_emitter and not studied_emitter } [Study the Kinetic Field Emitter.]
    -> study_emitter
* { has_kinetic_emitter and not emitter_equipped } [Equip the Kinetic Field Emitter.]
    -> equip_emitter
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
    ~ has_glimmer_moss_sample = true
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
    ~ has_glimmer_moss_sample = false
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
        -> scene_8_the_race
    }

// --- PATH B: THE SUBWAY TEST ---
=== scene_6b_subway ===
You descend into a flooded subway station, lit by the eerie green glow of moss. In the center of the platform is a functioning Archivist terminal, humming with power.
<i>AI: "Archivist Test Chamber detected. Objective: Access the terminal to download one Data Fragment."</i>
A single, powerful Slick-skinned Skulker guards the terminal, its eyeless head twitching at every sound.
* { has_kinetic_emitter and emitter_charges > 0 } [Use the Emitter's concussive blast ({emitter_charges} left).]
        { use_emitter_charge():
            // The function returned true, so the usage was successful.
            The blast hits the Skulker, sending it flying backwards into the tunnel wall with a wet smack. It's stunned and incapacitated. The path to the terminal is clear, and you easily download the **first Data Fragment**.
            ~ data_fragments += 1
            -> scene_7_the_fragment
        }
        
* { has_kinetic_emitter and emitter_charges <= 0 } [Attempt to use the broken Emitter.]
    You raise the Emitter and try to activate it, but it remains silent and cold. The power is completely spent. It's useless.
    -> scene_6b_subway
* [Engage the Skulker - Strength Check]
    ~ temp roll = RANDOM(1, 6)
    ~ temp total_skill = strength + roll
    { total_skill >= 10:
        // Success
        You charge, tackling the creature head-on. It's a brutal, short-lived fight that leaves you breathless but victorious. You access the terminal and download the **first Data Fragment**.
        ~ data_fragments += 1
        -> scene_7_the_fragment
    - else:
        // Failure
        The creature is faster and stronger than you anticipated. It lands a vicious blow, forcing you to retreat back into the tunnels, wounded. The terminal remains out of reach.
        <i>AI: "Subject has failed the test. Data Fragment unretrievable."</i>
        ~ resolve -= 10
        ~ is_injured = true
        -> scene_8_the_race
    }
* [Sneak to the Terminal - Agility Check]
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
        ~ is_injured = true
        -> scene_8_the_race
    }
* [Analyze the Environment - Intelligence Check]
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
        -> scene_8_the_race
    }

= setup_skulker_battle
    // Set the global variables for this specific enemy
    ~ current_enemy_name = "Slick-Skinned Skulker"
    ~ current_enemy_hp = 15
    ~ current_enemy_atk = 5
    ~ current_enemy_def = 2
    -> battle_loop // Now, start the battle loop

=== skulker_win ===
    The path to the terminal is clear. You download the **first Data Fragment**.
    ~ data_fragments += 1
    -> scene_7_the_fragment

=== skulker_lose ===
    You have been defeated by the Skulker.
    -> END

// === SCENE 7: THE FRAGMENT (Placeholder) ===
=== scene_7_the_fragment ===
// This scene will detail the player examining the fragment.
You hold the Data Fragment. It hums with a faint energy.
...To be continued...
-> scene_8_the_race


// === SCENE 8: THE RACE (Placeholder) ===
=== scene_8_the_race ===
// This scene will be the next major objective.
The AI directs you towards a new energy signature.
...To be continued...
-> END