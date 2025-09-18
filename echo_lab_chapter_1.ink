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

// Consequence Flags
VAR jed_status = "UNKNOWN" // Can be UNKNOWN, HELPED, HOSTILE, DEAD
VAR scene_4_debuff_stat = "" // To track debuff from Scene 4
VAR rival_has_emitter = false

// Data Fragments
VAR data_fragments = 0

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
    -> scene_3_the_first_room
* [I am Dr. Aris Thorne, the Bio-Hacker.]
    ~ character_name = "Aris"
    ~ strength = 3
    ~ intelligence = 8
    ~ agility = 4
    ~ perception = 6
    -> scene_3_the_first_room
* [I am Lena "Ghost" Petrova, the Infiltrator.]
    ~ character_name = "Lena"
    ~ strength = 4
    ~ intelligence = 5
    ~ agility = 7
    ~ perception = 8
    -> scene_3_the_first_room

// === SCENE 3: THE FIRST ROOM ===
=== scene_3_the_first_room ===
The door of your drop pod hisses open, dumping you onto a floor of cracked concrete slick with rainwater and alien moss.
<i>AI: "Location confirmed. Maintenance Bay. Zone designation: Ruined City-Isle."</i>

You're in a cavernous, ruined maintenance bay. The air is thick with the smell of ozone and decay. A single emergency light casts long, dancing shadows across shattered computer terminals and the skeletal remains of what might have been a maintenance worker.
Across the room, you see a patch of faintly glowing moss clinging to a damp wall. Next to it is a heavy, rusted metal locker. The only way out is a collapsed doorway to the north, choked with rubble but passable.
-> scene_3_choices

= scene_3_choices
* [Investigate the rusted locker.]
    -> locker_encounter
* [Investigate the glowing moss.]
    -> moss_encounter
* [Query the AI.]
    -> scene_3_ai_query
+ [Check Status.]
    -> check_status(-> scene_3_choices)
+ {has_degraded_power_cell || has_glimmer_moss_sample} [Analyze Items.]
    -> analyze_items
* [Leave through the collapsed doorway.]
    -> scene_4_the_first_obstacle
    
= analyze_items
You take a moment to examine your findings.
* {has_degraded_power_cell} [Analyze the Degraded Power Cell.]
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
        - Kinetic Field Emitter
    }
    * [Return.]
        -> return_to

= scene_3_ai_query
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

= locker_encounter
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

= moss_encounter
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
        - else: // Lena
            You receive a -1 debuff to Agility.
            ~ agility -= 1
            ~ scene_4_debuff_stat = "Agility"
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
        - else: // Lena
            You receive a -1 debuff to Agility.
            ~ agility -= 1
            ~ scene_4_debuff_stat = "Agility"
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
        - else: // Aris
            You receive a -1 debuff to Intelligence.
            ~ intelligence -= 1
            ~ scene_4_debuff_stat = "Intelligence"
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

// === SCENE 5A: THE CACHE ===
=== scene_5a_the_cache ===
You sprint towards the center of the plaza. A large, metallic crate is half-buried in a smoking crater. Standing over it, having just forced the main lock, is a figure you instantly recognize with a cold dread. Your Rival.

// --- Kaelen vs. Xander ---
{ character_name == "Kaelen":
    Xander "Vulture" Kade is kicking at a secondary lock on the crate. He smirks as you approach. "Look what the drop pod dragged in. Little late to the party, Rook. I've already claimed this prize."
    * [CONFRONT - Strength Check]: "You've claimed nothing. Step aside, Xander."
        { strength >= 7:
            // Success
            Your raw, imposing presence gives Xander pause. He sizes you up and scoffs, "Fine. You can have the scraps." He kicks the crate, popping open the main compartment, but a smaller, secondary compartment remains locked. Xander walks away with a sneer, having taken something, but the main prize is yours.
            ~ has_kinetic_emitter = true
            ~ strength += 1
        - else:
            // Failure
            Your exhaustion shows. Xander laughs. "You look weak, Rook." A brief, brutal scuffle ensues.
            { has_degraded_power_cell:
                // Use the power cell - Draw
                Shoved back, you see an opportunity. You pull out the Degraded Power Cell and slam it against the crate's exposed wiring. A violent surge of energy fries the locking mechanism with a loud ZAP, but also overloads the device inside. A wisp of acrid smoke curls from the crate.
                Xander stares, his smirk gone. "What did you do?!" He kicks the crate open to find the emitter fused into a slag of molten electronics. "Idiot! You destroyed it!" Annoyed, he shoves you aside and storms off.
                ~ has_degraded_power_cell = false
                ~ has_kinetic_emitter = false
                ~ resolve -= 5 // Penalty for a draw
            - else:
                // Original failure - Defeat
                You're shoved back, and Xander manages to break the secondary lock, grabbing the Kinetic Field Emitter before retreating. "Always a step behind," he taunts.
                ~ has_kinetic_emitter = false
                ~ rival_has_emitter = true
                ~ resolve -= 10 // Penalty for defeat
            }
        }
        -> scene_6_first_test
    * [WITHDRAW]: "Keep it. It's probably trapped."
        Xander watches you go with a look of contemptuous victory. You are safe, but have given a powerful tool to your worst enemy.
        ~ has_kinetic_emitter = false
        ~ rival_has_emitter = true
        ~ resolve -= 5 // Penalty for withdrawal
        -> scene_6_first_test
}

// --- Aris vs. Jinx ---
{ character_name == "Aris":
    Jinx is tinkering with the crate's lock, sparks flying from a jury-rigged device. She grins maniacally. "Ooh, a new lab rat! Come to see the light show? I'm about to give this thing a little... percussive maintenance."
    * [DECEIVE - Intelligence Check]: "Stop! That's an Archivist thermal-sync lock. One more spark and you'll flash-fry everything. Let me bypass the core."
        { intelligence >= 8:
            // Success
            Your confident, technical jargon makes Jinx hesitate, intrigued. "Ooh, dangerous! I like it." She lets you work. You "bypass" the core, but actually rewire it to a secondary latch, popping it open silently. You grab the Kinetic Field Emitter and make a run for it before she realizes she's been tricked.
            ~ has_kinetic_emitter = true
            ~ intelligence += 1
        - else:
            // Failure
            Jinx sees a flaw in your technobabble. "Nice try, lab coat, but you forgot the secondary capacitor!" She moves to trigger her device.
            { has_degraded_power_cell:
                // Use the power cell - Draw
                Thinking fast, you jam the Degraded Power Cell into a port on her contraption. "Then I'll just have to add another one!" you retort. The resulting power feedback is spectacular. Sparks fly, Jinx yelps and jumps back, and the cache's lock and the emitter inside are both fried instantly.
                She stares at the smoking mess, then at you, her grin wider than ever. "Ooooh! You're FUN! You broke my toy, but you made a much bigger bang!" She cackles and vanishes.
                ~ has_degraded_power_cell = false
                ~ has_kinetic_emitter = false
                ~ resolve -= 5 // Penalty for a draw
            - else:
                // Original failure - Defeat
                She triggers her device. A localized EMP blast shorts out your AI map and pops the crate. Jinx cackles, grabs the Emitter, and vanishes into the ruins.
                ~ has_kinetic_emitter = false
                ~ rival_has_emitter = true
                ~ resolve -= 10 // Penalty for defeat
            }
        }
        -> scene_6_first_test
    * [WITHDRAW]: "You're insane. It's all yours."
        You back away slowly. Jinx doesn't seem to notice, too engrossed in her work. A moment later, a small explosion is heard. You are safe, but Jinx now has a new, powerful toy.
        ~ has_kinetic_emitter = false
        ~ rival_has_emitter = true
        ~ resolve -= 5 // Penalty for withdrawal
        -> scene_6_first_test
}

// --- Lena vs. Isha ---
{ character_name == "Lena":
    You approach from the shadows. Isha "Hawkeye" is calmly examining the crate's lock. She doesn't turn, but speaks in a low voice. "I heard you five minutes ago. The wind carried the sound of your boots. Come out where I can see you."
    * [INFILTRATE - Agility Check]: (From hiding) Create a diversion to draw her away.
        { agility >= 7:
            // Success
            Realizing you're spotted, you use it. You throw a rock far to the left, but simultaneously circle to the right. Isha's head tracks the sound, and your silent movement allows you to reach the crate from her blind spot, pop the emergency latch, and grab the Kinetic Field Emitter before she can reacquire her target.
            ~ has_kinetic_emitter = true
            ~ agility += 1
        - else:
            // Failure
            Your movement isn't silent enough. As you reach for the crate, an arrow whistles past your ear, embedding itself in the metal. "Too slow," Isha says.
            { has_degraded_power_cell:
                // Use the power cell - Draw
                Pinned down, you make a desperate move. You toss the unstable Power Cell towards the crate's control panel. The impact is enough. The cell ruptures, bathing the crate in a shower of sparks that shorts out the contents completely.
                Isha lowers her bow, an unreadable expression on her face. "A scorched-earth tactic. You'd rather no one have it than lose. Interesting." She gives a slow nod and melts back into the shadows.
                ~ has_degraded_power_cell = false
                ~ has_kinetic_emitter = false
                ~ resolve -= 5 // Penalty for a draw
            - else:
                // Original failure - Defeat
                A tense chase ensues, forcing you to retreat empty-handed.
                ~ has_kinetic_emitter = false
                ~ rival_has_emitter = true
                ~ resolve -= 10 // Penalty for defeat
            }
        }
        -> scene_6_first_test
    * [REVEAL SELF]: Step out from the shadows. "I'm not here for a fight. Just a look."
        Isha turns, a predatory smile on her face. "A look is all you'll get." She expertly opens the crate, takes the Emitter, and gives you a final nod. "Now you know what I have. Run." It's a warning and a promise. The hunt has begun.
        ~ has_kinetic_emitter = false
        ~ rival_has_emitter = true
        ~ resolve -= 5 // Penalty for withdrawal
        -> scene_6_first_test
}


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
    { agility >= 8: // Lena excels here
        // SUCCESS
        You move with grace and speed, the dizzying height feeling like home. You easily navigate the broken ladders and exposed rebar, retrieving the **first Data Fragment** from the antenna array at the top.
        ~ data_fragments += 1
        -> scene_7_the_fragment
    - else:
        { agility >= 5 || strength >= 6: // A tough character can power through
            // PARTIAL SUCCESS
            You struggle, muscles burning, but you make it. {character_name == "Kaelen": At one point, a handhold crumbles, and you only manage to hang on through sheer, raw strength.|You manage to hang on through sheer grit.} You retrieve the fragment but are exhausted by the effort.
            ~ data_fragments += 1
            ~ is_fatigued = true
            -> scene_7_the_fragment
        - else: // A character with low physical stats will fail
            // FAILURE
            A handhold crumbles under your grip, and a gust of wind throws you off balance. You fall a short distance, slamming into a lower platform. Wounded and aching, you realize you can't reach the top from here.
            <i>AI: "Subject has failed the test. Data Fragment unretrievable."</i>
            ~ resolve -= 10
            ~ is_injured = true
            -> scene_8_the_race
        }
    }

// --- PATH B: THE SUBWAY TEST ---
=== scene_6b_subway ===
You descend into a flooded subway station, lit by the eerie green glow of moss. In the center of the platform is a functioning Archivist terminal, humming with power.
<i>AI: "Archivist Test Chamber detected. Objective: Access the terminal to download one Data Fragment."</i>
A single, powerful Slick-Skinned Skulker guards the terminal, its eyeless head twitching at every sound.
* { has_kinetic_emitter } [Use the Emitter's concussive blast.]
    // Auto-Success with the right tool
    You raise the Emitter and unleash a silent, powerful wave of kinetic energy. The blast hits the Skulker, sending it flying backwards into the tunnel wall with a wet smack. It's stunned and incapacitated. The path to the terminal is clear, and you easily download the **first Data Fragment**.
    ~ data_fragments += 1
    -> scene_7_the_fragment
* [Engage the Skulker - Strength Check]
    { strength >= 6:
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
    { agility >= 6:
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
    { intelligence >= 7:
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