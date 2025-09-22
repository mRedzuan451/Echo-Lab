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

=== engage_skulker_setup ===
    // Set the global variables for this specific enemy
    ~ current_enemy_name = "Slick-Skinned Skulker"
    ~ current_enemy_hp = 15
    ~ current_enemy_atk = 8
    ~ current_enemy_def = 2
    ~ used_skill_in_battle = false
    ~ rival_will_miss_next_turn = false
    ~ enemy_is_poisoned = false
    ~ poison_turns_remaining = 0
    ~ is_overcharging = false
    ~ is_countering = false
    The Skulker lets out a piercing shriek and lunges!
    -> battle_loop

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

=== sneak_past_skulker ===
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
    
=== analyze_skulker_env ===
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