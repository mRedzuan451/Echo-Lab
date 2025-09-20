// scene 3 choices
// === SKILL MECHANICS ===
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

