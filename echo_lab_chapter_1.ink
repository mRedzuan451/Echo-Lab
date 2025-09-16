// === ECHO LAB: CHAPTER 1 - THE DROP ===
// This is the playable script for the first chapter of the game.

// === VARIABLE DEFINITIONS ===
// Character stats
VAR strength = 0
VAR intelligence = 0
VAR agility = 0
VAR perception = 0
VAR resolve = 100

// Player's chosen name
VAR character_name = ""

// Inventory Flags (true = has, false = doesn't have)
VAR has_degraded_power_cell = false
VAR has_glimmer_moss_sample = false
VAR has_kinetic_emitter = false

// Consequence Flags
VAR jed_status = "UNKNOWN" // Can be UNKNOWN, HELPED, HOSTILE, DEAD
VAR scene_4_debuff_stat = "" // To track debuff from Scene 4

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
Your head throbs. The AI implant in your brain comes online with a soft chime, its voice a calm whisper against the panic in your mind.

<i>"Implant activated. Vital signs are... suboptimal, but stable. Welcome to the Arena. You have been assigned to Test Site Echo-7."</i>

You try to remember who you are. The name comes first, then the skills.
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
    -> check_status
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

= check_status
    -- Character Status --
    Name: {character_name}
    Strength: {strength}
    Intelligence: {intelligence}
    Agility: {agility}
    Perception: {perception}
    Resolve: {resolve}
    
    -- Inventory --
    { not has_degraded_power_cell and not has_glimmer_moss_sample:
        - Your pockets are empty.
    }
    { has_degraded_power_cell:
        - Degraded Power Cell
    }
    { has_glimmer_moss_sample:
        - Glimmer Moss Sample
    }
    --------------------
    * [Return.]
        -> scene_3_choices

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
* {character_name == "Kaelen"} [FORCE IT OPEN - Strength Check]
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
    -> scene_3_choices
* {character_name == "Aris"} [HOTWIRE THE KEYPAD - Intelligence Check]
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
    -> scene_3_choices
* {character_name == "Lena"} [PICK THE LOCK - Agility Check]
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
    -> scene_3_choices
* [Leave it alone.]
    -> scene_3_choices

= moss_encounter
You move closer to the wall. The moss gives off a soft, ethereal green light. It pulses gently, like a slow heartbeat.
* {character_name == "Aris"} [Use Bio-Scan.]
    <i>AI: "Glimmer Moss. Bioluminescent fungus. Mildly regenerative properties. Caution: Spores are a known attractant for subterranean fauna."</i>
    -> harvest_moss
* {character_name != "Aris"} [Examine it closely.]
    { perception >= 6:
        // Success
        You notice the ground beneath the moss is disturbed with small tracks, and you can smell a strange, sweet scent. This moss is more than just a pretty light; it's an active part of the ecosystem here.
    - else:
        // Failure
        It's a weird glowing plant. Looks cool, but you don't know anything else about it.
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

// === SCENE 5A: THE CACHE (Placeholder) ===
=== scene_5a_the_cache ===
// This scene is not yet written. The player goes for the supply cache.
You head towards the smoking crater where the supply cache landed.
...To be continued...
-> END


// === SCENE 6: THE FIRST TEST (Placeholder) ===
=== scene_6_first_test ===
// This scene is not yet written. The player ignores the cache and finds another path.
You decide to ignore the supply drop and look for a safer route.
...To be continued...
-> END