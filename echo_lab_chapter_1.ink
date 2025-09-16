// === ECHO LAB: CHAPTER 1 - THE DROP ===
// This is the playable script for the first chapter of the game.

// === VARIABLE DEFINITIONS ===
// Character stats
VAR strength = 0
VAR intelligence = 0
VAR agility = 0
VAR perception = 0
VAR resolve = 100 // Initializing Resolve. Starting at 100 as a base.
VAR character_name = ""

// Inventory Flags (0 = doesn't have, 1 = has)
VAR has_degraded_power_cell = 0
VAR has_glimmer_moss_sample = 0
VAR has_kinetic_emitter = 0

// Consequence Flags
VAR jed_status = "UNKNOWN" // Can be UNKNOWN, HELPED, HOSTILE, DEAD

// === GAME START ===
-> scene_1_impact


// === SCENE 1: IMPACT ===
=== scene_1_impact ===
Darkness. Cold metal against your cheek. The low, thrumming hum of a machine you don't recognize.
<br><br>
A sudden, violent lurch throws you against your restraints. A single red light flashes in the cramped space, illuminating a small, grimy viewport. Through it, you see a sight that makes your blood run cold: a shattered planet, pieces of its continents hanging silently in the black void of space, wreathed in a sickly green energy.
<br><br>
An alarm blares. The hum becomes a roar. The tiny pod you're in shudders as it hits the upper atmosphere, the viewport glowing white-hot. This isn't a rescue. It's a re-entry.
<br><br>
The impact is absolute. Metal screams, your vision whites out, and then... nothing.
<br><br>
Silence.
<br><br>
-> scene_2_awakening


// === SCENE 2: AWAKENING ===
=== scene_2_awakening ===
Your head throbs. The AI implant in your brain comes online with a soft chime, its voice a calm whisper against the panic in your mind.
<br><br>
<i>"Implant activated. Vital signs are... suboptimal, but stable. Welcome to the Arena. You have been assigned to Test Site Echo-7."</i>
<br><br>
You try to remember who you are. The name comes first, then the skills.
    * [I am Kaelen "Rook" Vance, the Soldier.]
        ~ character_name = "Kaelen"
        ~ strength = 7
        ~ intelligence = 3
        ~ agility = 4
        ~ perception = 5
        ~ resolve = 100
        -> scene_3_the_first_room
    * [I am Dr. Aris Thorne, the Bio-Hacker.]
        ~ character_name = "Aris"
        ~ strength = 3
        ~ intelligence = 8
        ~ agility = 4
        ~ perception = 6
        ~ resolve = 100
        -> scene_3_the_first_room
    * [I am Lena "Ghost" Petrova, the Infiltrator.]
        ~ character_name = "Lena"
        ~ strength = 4
        ~ intelligence = 5
        ~ agility = 7
        ~ perception = 8
        ~ resolve = 100
        -> scene_3_the_first_room

// === SCENE 3: THE FIRST ROOM ===
=== scene_3_the_first_room ===
The door of your drop pod hisses open, dumping you onto a floor of cracked concrete slick with rainwater and alien moss.
<br><br>
<i>AI: "Location confirmed. Maintenance Bay. Zone designation: Ruined City-Isle."</i>
<br><br>
You're in a cavernous, ruined maintenance bay. The air is thick with the smell of ozone and decay. A single emergency light casts long, dancing shadows across shattered computer terminals and the skeletal remains of what might have been a maintenance worker.
<br><br>
Across the room, you see a patch of faintly glowing moss clinging to a damp wall. Next to it is a heavy, rusted metal locker. The only way out is a collapsed doorway to the north, choked with rubble but passable.
-> scene_3_choices

= scene_3_choices
    * **[Investigate the rusted locker.]**
        -> locker_encounter
    * **[Investigate the glowing moss.]**
        -> moss_encounter
    * **[Query the AI.]**
    * The AI's calm voice responds in your mind.
    * **[Ask: "Where am I?"]**
        * *AI: "You are within Test Site Echo-7, located on a fragment of a planetary body designated 'The Shattered World'. My designation for this zone is the 'Ruined City-Isle'."*
    * **[Ask: "What is this place? What is the 'Arena'?"]**
        * *AI: "This 'Arena' is a controlled environment for a series of trials conducted by my creators, the Archivists. The objective is to test species' capacity for survival and adaptation."*
    * **[Ask: "Who is the Proctor?"]**
        * *AI: "The Proctor is the master control AI for this entire experiment. My function is to guide and observe subjects. The Proctor's function is to administrate the trials."*
    * **[Ask: "Why am I here?"]**
        * *AI: "Your selection criteria are not available in my data banks. Your purpose is to survive and demonstrate mastery of the environment. That is all the data I can provide on the subject."*
    * **[Leave through the collapsed doorway.]**
        -> scene_4_the_first_obstacle

= locker_encounter
The locker is old and heavy. The locking mechanism is a simple electronic keypad, now dark and corroded. The door itself is dented and sealed shut with rust.
    * {character_name == "Kaelen"} [FORCE IT OPEN - Strength Check]
        You plant your feet, grip the edge of the locker door, and pull with everything you've got.
        { strength >= 7:
            // Success
            The metal groans, shrieks, and finally tears open with a deafening CRUNCH. Inside, you find a **Degraded Power Cell**. It's heavy, but it might be useful.
            ~ has_degraded_power_cell = 1
        - else:
            // Failure
            You throw your shoulder against the door, but it only groans in protest. The rust holds it fast. You've only succeeded in bruising your shoulder and making a lot of noise.
            ~ resolve = resolve - 1
        }
        -> scene_3_choices
    * {character_name == "Aris"} [HOTWIRE THE KEYPAD - Intelligence Check]
        You spot a frayed power conduit hanging from the ceiling. Rerouting the cable, you attempt to send a jolt of power to the corroded keypad.
        { intelligence >= 8:
            // Success
            It sparks to life for just a moment, long enough for the lock to disengage with a loud THUNK. Inside, you find a **Degraded Power Cell**. Fascinating.
            ~ has_degraded_power_cell = 1
        - else:
            // Failure
            You try to create a circuit, but the components are too decayed. A final spark from the conduit singes your fingers and the keypad goes completely dead. It's useless now.
            ~ resolve = resolve - 1
        }
        -> scene_3_choices
    * {character_name == "Lena"} [PICK THE LOCK - Agility Check]
        The keypad is dead, but the manual override is still intact. Your deft fingers search for the tumblers.
        { agility >= 7:
            // Success
            With a series of satisfying clicks, the lock disengages. The door swings open silently. Inside, you find a **Degraded Power Cell**. A valuable find.
            ~ has_degraded_power_cell = 1
        - else:
            // Failure
            You work at the lock, but the internal mechanism is rusted solid. A lockpick snaps with a sharp *tink*, leaving the lock hopelessly jammed. There's no getting in that way now.
            ~ resolve = resolve - 1
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
    + [Take a sample.]
        You scrape a handful of the glowing moss off the wall and store it in a pouch. It feels cool and damp to the touch.
        ~ has_glimmer_moss_sample = 1
        -> scene_3_choices
    + [Leave it be.]
        -> scene_3_choices

// === SCENE 4: THE FIRST OBSTACLE ===
=== scene_4_the_first_obstacle ===
// Placeholder for the next scene.

-> END
