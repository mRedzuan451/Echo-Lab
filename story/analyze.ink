=== analyze_items ===
You take a moment to examine your findings.
* {power_cell_stack > 0 and not analyze_power_cell} [Analyze the Degraded Power Cell.]
    -> do_analyze(->analyze_power_cell)
* {glimmer_moss_stack > 0 and not analyzed_moss_type} [Analyze the Glimmer Moss Sample.]
    -> do_analyze(->analyze_moss)
* {found_first_log} [Analyze the Archivist Log #77-B]
    -> decrypt_first_log
* {neuro_stim_state == "AVAILABLE" and not analyzed_neuro_stim_type} [Analyze Neuro-Stim] -> do_analyze(->analyze_neuro_stim)
* {skulker_venom_gland_stack > 0 and not analyzed_venom_gland_type} [Analyze Skulker Venom Gland] -> do_analyze(->analyze_venom_gland)
* {has_moss_poison_vial > 0 and not analyzed_poison_vial_type} [Analyze Moss Poison Vial] -> do_analyze(->analyze_poison_vial)
* {knows_calming_poultice_recipe and not analyzed_poultice_recipe_type} [Analyze Calming Poultice Recipe] -> do_analyze(->analyze_poultice_recipe)
* {has_titan_beetle_carapace and not analyzed_beetle_carapace_type} [Analyze Titan-Beetle Carapace] -> do_analyze(->analyze_beetle_carapace)
* {has_adrenaline_shot and not analyzed_adrenaline_shot_type} [Analyze Adrenaline Shot] -> do_analyze(->analyze_adrenaline_shot)
    
+ [Done analyzing.]
    -> scene_3_choices

// --- GENERIC ANALYSIS LOGIC ---
= do_analyze(-> item_specific_text)
    -> item_specific_text
    
    // Grant random stat boost
    ~ temp stat_roll = RANDOM(1, 4)
    {
        - stat_roll == 1:
            ~ strength += 1
            <i>Your Strength has permanently increased by 1!</i>
        - stat_roll == 2:
            ~ intelligence += 1
            <i>Your Intelligence has permanently increased by 1!</i>
        - stat_roll == 3:
            ~ agility += 1
            <i>Your Agility has permanently increased by 1!</i>
        - else:
            ~ perception += 1
            <i>Your Perception has permanently increased by 1!</i>
    }
    ~ update_combat_stats()
    -> analyze_items

// --- ITEM-SPECIFIC ANALYSIS TEXT AND FLAGS ---
= analyze_power_cell
    ~ analyzed_power_cell_type = true
    { character_name == "Kaelen":
        - You tap the power cell against a metal strut. It sparks weakly. Looks like it has a little juice, but it feels unstable. Probably best not to hit it too hard.
    }
    { character_name == "Aris":
        - You run your multi-tool over the power cell. <i>AI: "Lithium-ion architecture, heavily degraded. Output is unstable, fluctuating between 3 and 19 volts. Could be repurposed for a directed electromagnetic pulse, with a moderate chance of catastrophic failure."</i> Fascinating.
    }
    { character_name == "Lena":
        - It's a standard power cell, the kind used in old maintenance drones. Heavy. You notice a small crack in the casing near the positive terminal. It might be volatile.
    }
    -> grant_random_stat_boost

= analyze_moss
    ~ analyzed_moss_type = true
    { character_name == "Kaelen":
        - You rub the moss between your fingers. It's cool to the touch and leaves a faint glowing residue. Doesn't seem very useful, but it smells... sweet.
    }
    { character_name == "Aris":
        - You analyze the sample. <i>AI: "Fungal sample contains a unique bioluminescent enzyme and a mild coagulant. Spores are airborne. High probability of attracting local fauna."</i> Useful. The coagulant could be refined into a basic healing agent.
    }
    { character_name == "Lena":
        - The moss glows, but the light is faint. You recall seeing similar fungi in deep-cave infiltration missions. The spores are light enough to travel on air currents; anything that hunts by scent would be drawn to this.
    }
    -> grant_random_stat_boost

= analyze_neuro_stim
    ~ analyzed_neuro_stim_type = true
    { character_name == "Kaelen":
        You study the injector. It's military-grade, designed for battlefield medics. Understanding its simple, rugged construction gives you an idea of how to better maintain your own gear.
    }
    { character_name == "Aris":
        You recognize the chemical compound in the vial. It's a complex cocktail of synaptic enhancers. Just tracing the molecular structure in your mind feels like a complex and rewarding puzzle.
    }
    { character_name == "Lena":
        You've seen stims like this before, used by extraction targets who needed to be alert. Deconstructing how it works gives you a better understanding of how to counter their effects... or use them to your advantage.
    }
    -> grant_random_stat_boost

= analyze_venom_gland
    ~ analyzed_venom_gland_type = true
    { character_name == "Kaelen":
        You handle the pulsating sac carefully. It's a reminder of a tough fight, a trophy. Understanding what it took to defeat the creature that grew this makes you feel stronger.
    }
    { character_name == "Aris":
        Fascinating! The neurotoxin is incredibly complex. Analyzing how it attacks the nervous system gives you a flash of insight into how to better protect your own.
    }
    { character_name == "Lena":
        You study the gland, noting its weak points and how quickly the venom degrades when exposed to air. Knowledge of an enemy's biology is a weapon in itself.
    }
    -> grant_random_stat_boost

= analyze_poison_vial
    ~ analyzed_poison_vial_type = true
    { character_name == "Kaelen":
        It's a simple weapon, but effective. Thinking about how to apply it in a fight makes you reconsider your own combat techniques, looking for new openings.
    }
    { character_name == "Aris":
        Your refined poison is stable and potent. Reviewing your own work, you see a slight improvement you could make to the formula, a small but satisfying intellectual victory.
    }
    { character_name == "Lena":
        You practice handling the vial, figuring out the fastest way to apply it to a blade or an arrow without making a sound. The economy of motion is a skill you're always refining.
    }
    -> grant_random_stat_boost

= analyze_poultice_recipe
    ~ analyzed_poultice_recipe_type = true
    { character_name == "Kaelen":
        Jed's knowledge is old-world, practical. It's not about complex science, but about knowing the land. Thinking about that simple, effective wisdom makes you feel more grounded.
    }
    { character_name == "Aris":
        You analyze the chemical properties of the weed Jed pointed out. He was right—it contains a mild sedative. The folk knowledge is surprisingly accurate, a fascinating data point.
    }
    { character_name == "Lena":
        A recipe based on observation, not technology. It's a reminder that the environment itself can be a tool, or an arsenal. A valuable lesson in situational awareness.
    }
    -> grant_random_stat_boost

= analyze_beetle_carapace
    ~ analyzed_beetle_carapace_type = true
    { character_name == "Kaelen":
        The carapace is incredibly dense, a natural shield. Studying how the layers are formed gives you ideas on how to better brace for impact in a fight.
    }
    { character_name == "Aris":
        The chitinous plating is a marvel of bio-engineering. The way it distributes kinetic force is incredibly efficient. You've learned something new about structural integrity.
    }
    { character_name == "Lena":
        You examine the joints in the plating, the places where movement is possible. Understanding its weak points is just as important as understanding its strengths.
    }
    -> grant_random_stat_boost

= analyze_adrenaline_shot
    ~ analyzed_adrenaline_shot_type = true
    { character_name == "Kaelen":
        A shot of pure adrenaline. A soldier's tool for a last stand. Just holding it makes your heart beat faster, your muscles tense in anticipation.
    }
    { character_name == "Aris":
        It's a crude but powerful stimulant. Analyzing its effect on the human body reminds you of the delicate balance of your own biochemistry, and how easily it can be pushed.
    }
    { character_name == "Lena":
        You know what this is for: pushing past your limits when escape is the only option. Thinking about the desperate situations that would require it sharpens your survival instincts.
    }
    -> grant_random_stat_boost
    
// --- SHARED LOGIC TO GRANT THE REWARD ---
= grant_random_stat_boost
    // Grant random stat boost
    ~ temp stat_roll = RANDOM(1, 4)
    {
        - stat_roll == 1:
            ~ strength += 1
            <i>Your Strength has permanently increased by 1!</i>
        - stat_roll == 2:
            ~ intelligence += 1
            <i>Your Intelligence has permanently increased by 1!</i>
        - stat_roll == 3:
            ~ agility += 1
            <i>Your Agility has permanently increased by 1!</i>
        - else:
            ~ perception += 1
            <i>Your Perception has permanently increased by 1!</i>
    }
    ~ update_combat_stats()
    -> analyze_items

// ... (Create a similar `= analyze_...` stitch for every item type) ...