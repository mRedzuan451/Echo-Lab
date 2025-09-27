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
+ {power_cell_stack > 0 || glimmer_moss_stack > 0 || found_first_log or not analyzed_first_log} [Analyze Items.]
    -> analyze_items
* [Leave through the collapsed doorway.]
    -> scene_4_the_first_obstacle

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
    ~ analyzed_first_log = true
    ~ temp original_intelligence = intelligence
    { neuro_stim_state == "ACTIVE":
        ~ intelligence += 4
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
        ~ intelligence = original_intelligence + 1
        ~ perception += 1
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
    
=== locker_encounter ===
The locker is old and heavy. The locking mechanism is a simple electronic keypad, now dark and corroded. The door itself is dented and sealed shut with rust.

{ character_name == "Kaelen":
    // Kaelen's Action: Brute Force
    You plant your feet, grip the edge of the locker door, and pull with everything you've got.
    { strength >= 7:
        // Success
        The metal groans, shrieks, and finally tears open with a deafening CRUNCH. Inside, you find a **Degraded Power Cell**. It's heavy, but it might be useful.
        ~ power_cell_stack += 1
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
        ~ power_cell_stack += 1
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
        ~ power_cell_stack += 1
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
