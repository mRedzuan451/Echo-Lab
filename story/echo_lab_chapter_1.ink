// === ECHO LAB: CHAPTER 1 - THE DROP ===
INCLUDE _variables.ink
INCLUDE _systems.ink
INCLUDE scene_3.ink
INCLUDE scene_5.ink
INCLUDE scene_6.ink
INCLUDE scene_7.ink
INCLUDE scene_8.ink
INCLUDE scene_9.ink
INCLUDE scene_10.ink
INCLUDE ai_query.ink
INCLUDE analyze.ink
INCLUDE _battle_mechanic.ink
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
The name comes first, then the title.
* [I am Kaelen "Rook" Vance, the Soldier.]
    ~ character_name = "Kaelen"
    ~ rival_name = "Xander"
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
    ~ rival_name = "Jinx"
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
    ~ rival_name = "Isha"
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
    -> tower_buffer_room(-> tower_floor_2)



// === SCENE 9: THE BARGAIN ===
=== scene_9_the_bargain ===
{ data_fragments < 2:
    // --- Failure Path: You still need the second fragment ---
    Having failed to secure the fragment at the tower, your AI directs you to another faint energy signature. It leads you to a dilapidated hab-block, lit by a single emergency light.
    -> find_jed_for_fragment
- else:
    // --- Success Path: You already have the fragment ---
    As you search for a path forward from the tower, you come across a small, fortified room in a hab-block. It seems recently occupied.
    -> meet_jed_friendly
}

// === SCENE 10: THE LAIR ===
=== scene_10_the_lair ===
With your preparations complete, the AI directs you into a massive, cavernous subway nexus. Several tunnels converge here, and a derelict subway train rests in the center. Atop the main platform, a shimmering, inactive Archive Gate stands, but it is not unguarded.

Nine other contestants are gathered here, a tense and hostile silence hanging in the air. You see your Rival among them, and you also spot Jed, who gives you a nod or a glare depending on your history.

The Proctor's voice echoes through the cavern, cold and final.
<i>PROCTOR: "The final test for this zone has begun. The Archive Gate is guarded by the zone's Apex Predator: the Alpha Skulker Matriarch. The five subjects who contribute most to its defeat will be awarded the final Data Fragment. All others will be deemed... substandard. Good luck."</i>

As if on cue, a wave of smaller Skulkers floods from the tunnels, a living tide of claws and teeth between you and the main platform.
-> lair_horde_battle