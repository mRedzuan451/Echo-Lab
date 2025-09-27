=== find_jed_for_fragment ===
Inside, you find an older, weathered man slumped against a wall with a makeshift splint on his leg. He has a Data Fragment clutched in his hand, but his face is pale with pain. This must be Jed.
He looks up at you, not with fear, but with weary resignation. "Well, look what the cat dragged in," he rasps. "Don't suppose you've got a working power cell on you? This old diagnostic tool is dead, and I need to see how bad this leg is." He gestures to the fragment. "It's yours if you can help."

* { power_cell_stack > 0 } [Trade a Power Cell for the fragment.]
    You nod, pulling a Degraded Power Cell from your pack. Jed's eyes light up with relief. "Thank you, friend. A deal's a deal." He tosses you the fragment.
    ~ power_cell_stack -= 1
    ~ data_fragments += 1
    ~ jed_status = "HELPED"
    -> check_for_jed_gift

* [Intimidate him for the fragment - Strength Check]
    -> intimidate_jed

* [Leave him.]
    You decide not to get involved and back out of the room, leaving the old man to his fate. The fragment remains out of reach.
    // The story continues, but you'll be a fragment short.
    -> check_for_jed_gift

= intimidate_jed
    ~ temp roll = RANDOM(1, 6)
    ~ temp total_skill = strength + roll
    { total_skill >= 13:
        // Success
        "I don't have time for this. Give me the fragment," you growl. Jed sizes you up, then scoffs and throws the fragment at your feet. "Fine. Take it. You're just like the others."
        ~ data_fragments += 1
        ~ jed_status = "HOSTILE"
        -> scene_9c_final_preparations
    - else:
        // Failure
        You try to look threatening, but Jed just gives you a tired smile. "Save your breath, kid. I've seen scarier things in a mirror. No cell, no fragment."
        * [Attack him.]
            -> attack_jed
        * [Back down.]
            -> scene_9c_final_preparations
    }

= attack_jed
    You lunge at the old man, deciding to take the fragment by force. Jed isn't surprised. With a weary sigh, he pulls a hidden trigger on the floor.
    ~ temp trap_roll = RANDOM(1, 10)
    { trap_roll == 1:
        // RARE SUCCESS (10% chance)
        You see the trap mechanism a split second before it springs—a powerful stun baton swinging out from a wall panel. You manage to dodge it. Jed looks genuinely surprised. You snatch the fragment from his hand before he can react further.
        ~ data_fragments += 1
        ~ jed_status = "DEAD" // Assuming you finish the job after
        -> scene_9c_final_preparations
    - else:
        // FAILURE (90% chance)
        A powerful stun baton swings out from a hidden wall panel, slamming into your side with a crackle of electricity. The shock is immense, leaving you gasping on the floor as your vision whites out.
        ~ hp -= 15
        // Check if the character survives the damage
        { hp <= 0:
            -> game_over_death
        - else:
            ~ is_injured = true
            ~ jed_status = "HOSTILE"
            Jed shakes his head. "Told you. Scarier things in a mirror." He waits for you to recover before pointing to the door. "Now get out."
            You drag yourself out of the room, empty-handed and in agony.
            -> scene_9c_final_preparations
        }
    }

=== meet_jed_friendly ===
Inside, you find an older, weathered man slumped against a wall with a makeshift splint on his leg. He eyes you warily as you enter. "Just passin' through," he says. "Don't mind me." This is your first encounter with another non-hostile contestant.
* { glimmer_moss_stack > 0 } [Offer him a Glimmer Moss sample for his leg.]
    You offer him one of your moss samples. He looks surprised, then accepts it with a grateful nod. "Well, I'll be. Thanks. Here, take this in return."
    ~ glimmer_moss_stack -= 1
    ~ jed_status = "HELPED"
    
    { character_name == "Kaelen":
        He hands you a roll of thick, resin-soaked wrappings. "Saw you eyein' that pipe you carry. This'll make the grip better, add some weight to your swing. Should make your club a proper weapon."
        ~ has_club_upgrade_kit = true
    }
    { character_name == "Aris":
        He points to a common-looking weed growing in a crack in the floor. "See that? Most folks think it's useless. But if you crush the leaves and mix 'em with a bit of moss, makes a real fine poultice. Calms the nerves." You've learned the recipe for a Calming Poultice.
        ~ knows_calming_poultice_recipe = true
    }
    { character_name == "Lena":
        He reaches into his pack and pulls out a small, tightly wrapped bundle. "You look like you know how to stay quiet. These might help." He hands you a bundle of five arrows, fletched with a dark, soft feather that makes them almost silent in flight.
        ~ silent_arrow_count += 5
    }
    -> check_for_jed_gift
* [Leave him be.]
    You give a nod and back out of the room, leaving him in peace.
    -> scene_9c_final_preparations
    
// === SCENE 9B: LEAVING JED'S AREA ===
=== check_for_jed_gift ===
{ jed_status == "HELPED":
    -> jed_parting_gift
- else:
    // If you didn't help Jed, continue on as normal.
    -> scene_9c_final_preparations
}

=== jed_parting_gift ===
As you head for the collapsed doorway, a voice calls out from the shadows. "Hold on a minute, friend." Jed limps towards you, leaning on a makeshift crutch.

"You did me a real kindness back there," he says, his eyes grateful. "Most folks in this place would've just put a knife in my back. The Arena... it changes people."

He holds out a slightly damaged datapad. "I've been here a while. Found a few of these logs and cracked 'em. Nothing that'll tell you how to win, but... it helps to know what you're up against. You should have them."

You take the datapad. He's unlocked several entries for you.

<b>UNLOCKED LOG 14-G:</b> "Test Site Echo-7's primary function is to observe species' adaptation to catastrophic environmental collapse. The Shattered World provides an ideal crucible. Survival is the only metric."
~ log_knows_site_purpose = true

<b>UNLOCKED LOG 29-A:</b> "Note on planetary destruction: Previous experiment in terraforming using resonant frequencies resulted in cascading geological failure. The Archivists deemed the outcome 'sub-optimal but informative'."
~ log_knows_shattered_world_cause = true

<b>UNLOCKED LOG 55-C:</b> "The Proctor AI administrates the trials with perfect efficiency. It is unconstrained by ethics or empathy, operating solely on the parameters of the experiment. Do not attempt to reason with it."
~ log_knows_proctor_ethics = true

Jed gives you a final nod. "Good luck out there. Try not to die." He turns and limps back into the shadows of the maintenance bay.

-> scene_9c_final_preparations

// === SCENE 9C: FINAL PREPARATIONS ===
=== scene_9c_final_preparations ===
The AI indicates that the final Data Fragment is located in a heavily defended nest nearby. This is likely the last major confrontation in this zone. You find a defensible spot to make your final preparations before the assault.
    
* [Manage Equipment and Crafting.]
    -> manage_equipment
+ [Scavenge the area one last time.]
    -> final_scavenge
+ [Check Status.]
    -> check_status(-> scene_9c_final_preparations)
+ { has_kinetic_emitter and emitter_charges > 0 } [Use the Emitter to clear the blocked passage.]
    -> clear_passage_with_emitter
* [Proceed to the final location.]
    -> scene_10_the_lair

= clear_passage_with_emitter
    You notice a side passage that seems to lead towards the lair, but it's completely blocked by a massive pile of collapsed girders.
    * [Use an Emitter charge to clear it.]
        { use_emitter_charge():
            You unleash a focused blast of kinetic energy. The girders groan and shift, pushed aside by the immense force, revealing a hidden path. Beyond the rubble, you find a small supply cache left by a previous contestant.
            // Reward for using the Emitter
            ~ glimmer_moss_stack += 2
            ~ power_cell_stack += 1
            You've found some extra supplies! The path is now clear.
        }
        -> scene_9c_final_preparations
    * [Save your charges.]
        -> scene_9c_final_preparations

= manage_equipment
    You lay out your gear, checking everything is in order.
    * { has_kinetic_emitter and emitter_charges <= 0 and power_cell_stack > 0 } [Use a Power Cell to recharge the Emitter.]
        You connect the unstable Power Cell to the Emitter's charging port. The cell sputters and whines as its energy is drained, but the Emitter's internal lights hum back to life. It's fully charged.
        ~ power_cell_stack -= 1
        ~ emitter_charges = 3
        -> manage_equipment
    * { has_adrenaline_shot } [Use the Adrenaline Shot.]
        You inject the adrenaline directly into your thigh. Your heart hammers in your chest, and your senses sharpen to a razor's edge. You feel faster, more agile.
        ~ has_adrenaline_shot = false
        ~ agility += 1
        ~ update_combat_stats()
        <i>AI: "Unscheduled bio-stimulant administered. Agility permanently increased to {agility}."</i>
        -> manage_equipment
    * { has_reinforced_club and has_club_upgrade_kit and not club_is_upgraded } [Apply the Upgrade Kit to the Club.]
        You take the resin-soaked wrappings Jed gave you and apply them to your club. The grip is more secure, and the added weight feels powerful. Your club has been upgraded!
        ~ club_is_upgraded = true
        ~ club_power_slots = 3
        ~ has_club_upgrade_kit = false
        ~ update_combat_stats() // Recalculate stats with the new upgrade
        -> manage_equipment
    * { has_titan_beetle_carapace and character_name == "Kaelen" } [Craft Titan-Beetle Armor.]
        You use the heavy carapace and some scavenged straps to create a crude but effective breastplate. It's heavy, but it will offer significant protection.
        ~ has_titan_beetle_carapace = false
        // TODO: Add a flag for this armor and update the stat function.
        -> manage_equipment
    + [View Crafting Options.]
        -> crafting_options(-> manage_equipment)
    + [Return.]
        -> scene_9c_final_preparations

=== final_scavenge ===
    You scour the nearby ruins for any last-minute supplies.
    + [Search for Glimmer Moss.]
        -> final_scavenge_moss
    + [Search for Power Cells.]
        -> final_scavenge_cells
    + [Scavenge a collapsed hab-unit.]
        -> scavenge_hab_unit
    + { character_name == "Lena" and has_recurve_bow } [Scavenge for materials to fletch arrows.]
        -> scavenge_for_arrows
    + [Stop scavenging.]
        -> scene_9c_final_preparations

= scavenge_for_arrows
    You shift your focus, looking not for bulky items, but for things that are long, straight, and sharp. You find a few thin pieces of rebar for shafts and some sharpened scrap metal for heads. With some tattered fabric for fletching, you can assemble a small quiver's worth of arrows.
    ~ temp arrows_crafted = RANDOM(2, 4)
    ~ scrap_arrow_count += arrows_crafted
    You craft {arrows_crafted} scrap arrows.
    -> final_scavenge

= final_scavenge_moss
    ~ temp roll = RANDOM(1, 3)
    { roll <= 2:
        // Success
        You find another small patch of the glowing fungus.
        ~ glimmer_moss_stack += 1
    - else:
        // Failure
        You find nothing. This area seems picked clean for now.
    }
    -> final_scavenge

= final_scavenge_cells
    ~ temp roll = RANDOM(1, 4)
    { roll == 1:
        // Success
        Tucked inside a damaged console, you find another Degraded Power Cell.
        ~ power_cell_stack += 1
    - else:
        // Failure
        You find plenty of scrap, but no functional power sources.
    }
    -> final_scavenge
    
= scavenge_hab_unit
    You pry open the door of a collapsed hab-unit, hoping to find something valuable inside.
    ~ temp roll = RANDOM(1, 5)
    {
        - roll == 1:
            // Outcome 1: Fight an Ambush Skulker
            A sharp hiss echoes from the darkness inside. A Slick-Skinned Skulker, disturbed from its nest, lunges at you!
            -> setup_ambush_skulker_battle
            
        - roll == 2:
            // Outcome 2: Find a Titan Beetle
            { not has_titan_beetle_carapace:
                Inside, you find the remains of a massive, armored beetle. Its iridescent carapace is almost entirely intact. This could be fashioned into some sturdy armor.
                ~ has_titan_beetle_carapace = true
                You've found a Titan-Beetle Carapace.
            - else:
                You find another beetle husk, but this one has been picked clean. Nothing of value remains.
            }
            -> final_scavenge
            
        - roll == 3:
            // Outcome 3: Find a Stat Boost Item
            { not has_adrenaline_shot:
                You find a derelict first-aid station. Most of it is looted, but you find one sealed container with a single auto-injector inside, labeled "Adrenaline." This could permanently boost your reaction speed.
                ~ has_adrenaline_shot = true
                You've found an Adrenaline Shot.
            - else:
                You find a looted first-aid station, but it's completely empty.
            }
            -> final_scavenge
        
        - roll == 4:
            // Outcome 4: Find a new Archivist Log
            { not log_knows_ally_buff:
                You find the skeletal remains of another contestant. Unlike the one in the bay, this one was clearly a strategist. Their datapad is still active, containing a single, encrypted Archivist Log about combat synergy.
                -> decrypt_ally_buff_log
            - else:
                You find another looted body. Nothing of value remains.
                -> final_scavenge
            }
            
        - else:
            // Outcome 5: Failure
            The hab-unit is completely picked clean. There's nothing of value left.
            -> final_scavenge
    }

= decrypt_ally_buff_log
    You access the log. It appears to be a tactical analysis of multi-subject combat trials.
    <i>AI: "Log is encrypted. High-level intelligence required."</i>
    * [Attempt to decrypt the log - Intelligence Check]
        { intelligence >= 8:
            // Success
            You find a weakness in the encryption and the file opens. It's a log detailing how to coordinate with an ally to exploit an enemy's blind spots. You've learned a new skill: **Targeted Analysis**.
            ~ log_knows_ally_buff = true
            ~ player_skills += TargetedAnalysis
            -> final_scavenge
        - else:
            // Failure
            The tactical jargon and complex data is beyond you. The log remains locked.
            -> final_scavenge
        }
    * [Leave it.]
        -> final_scavenge

= setup_ambush_skulker_battle
    // Set the global variables for this specific enemy
    ~ current_enemy_name = "Ambush Skulker"
    ~ current_enemy_hp = 15
    ~ current_enemy_atk = 8
    ~ current_enemy_def = 2
    // Reset battle state flags
    ~ used_skill_in_battle = false
    ~ rival_will_miss_next_turn = false
    ~ enemy_is_poisoned = false
    ~ poison_turns_remaining = 0
    ~ is_overcharging = false
    ~ is_countering = false
    -> battle_loop