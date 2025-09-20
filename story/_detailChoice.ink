// scene 3 choices

=== use_skill ===
{ not found_first_log:
    -> find_first_log_event
}
    
=== find_first_log_event ===
~ found_first_log = true
As you concentrate, your unique skill reveals something unexpected.
{ character_name == "Kaelen":
    While scanning the debris for anything useful, your hand brushes against a flat, metallic object wedged beneath a twisted girder.
}
{ character_name == "Aris":
    Your bio-scan sweeps the room, but it also registers a faint, encrypted energy signature from a small datapad tucked inside a corroded wall panel.
}
{ character_name == "Lena":
    Your eyes, trained to spot things that don't belong, catch the unnatural straight edge of a datapad almost perfectly concealed in the shadows of the ceiling.
}

You retrieve the device. It's an **Archivist Log**, its screen displaying a single, heavily encrypted file.
<i>AI: "Log from a previous test cycle detected. Decryption is possible, but the file is protected by a high-level algorithm."</i>

* [Attempt to decrypt the log - Intelligence Check]
    -> decrypt_first_log
* [Leave it for now.]
    -> scene_3_choices

=== decrypt_first_log ===
    ~ temp original_intelligence = intelligence
    { neuro_stim_state == "ACTIVE":
        ~ intelligence += 3
    }
    You focus on the complex encryption, trying to find a flaw in the code.
    { intelligence >= 7:
        // Success
        With a surge of insight, you find a recursive loop in the encryption key. You bypass it, and a fragment of the log becomes readable. It's a combat record.
        
        <b>LOG FRAGMENT 77-B:</b> "...subject cornered by local fauna (Designation: 'Skulker'). Auditory sensitivity is a critical vulnerability. High-frequency sonics cause neural cascade failure..."
        
        You've learned a critical weakness of the Skulker creatures.
        ~ know_skulker_weakness = true
        
        // If the boost was active, it wears off now
        { neuro_stim_state == "ACTIVE":
            The intense focus fades as the Neuro-Stim wears off, leaving a dull ache behind your eyes.
            ~ neuro_stim_state = "USED"
        }
        ~ intelligence = original_intelligence
        -> scene_3_choices
    - else:
        // Failure
        The code is a nonsensical wall of alien symbols. It's beyond your ability to comprehend right now.
        <i>AI: "Decryption failed. Cognitive processing power is insufficient."</i>
        
        // If the stim is available, the AI offers it
        { neuro_stim_state == "AVAILABLE":
            <i>AI: "A neuro-stimulant is detected in your possession. Administering it may temporarily enhance cognitive function enough to bypass the encryption. This action will consume the device."</i>
            * [Use the Neuro-Stim and try again.]
                You press the Neuro-Stim against your neck. With a sharp hiss, it injects its contents. A cold fire spreads through your mind, clearing the fog of the crash.
                ~ neuro_stim_state = "ACTIVE"
                -> decrypt_first_log
            * [Save it for later.]
                -> scene_3_choices
        - else:
             -> scene_3_choices
        }
    }
    
=== analyze_items ===
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
* {glimmer_moss_stack > 0} [Analyze the Glimmer Moss Sample.]
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
* {found_first_log} [Analyze the Archivist Log #77-B]
    -> decrypt_first_log
* [Done analyzing.]
    -> scene_3_choices

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
    ~ glimmer_moss_stack += 1
    -> scene_3_choices
+   [Leave it be.]
    -> scene_3_choices
