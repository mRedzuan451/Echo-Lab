// === SCENE 7: SCAVENGING ===
=== scene_7_scavenge ===
Knowing you'll need more than just wits to survive, you decide to scavenge the immediate area before moving on.
{ scene_6a_rooftops > 0: // Rooftops context
    The wreckage of the comms tower is a tangled mess of metal supports and snapped cables.
}
{ scene_6b_subway > 0: // Subway context
    The derelict subway cars and dark maintenance tunnels are full of old, decaying equipment.
}

* [Search for useful components.]
    -> scavenge_action
* [Ignore scavenging and move on to crafting.]
    -> scene_7a_gearing_up

= scavenge_action
    You spend some time carefully picking through the debris.
    { character_name == "Kaelen":
        Your strength allows you to pry open a sealed maintenance hatch that others couldn't budge. Inside, you find a sturdy metal pipe and a spool of thick wiring, perfect for a weapon.
        ~ has_metal_pipe = true
        ~ has_thick_wiring = true
    }
    { character_name == "Lena":
        Your sharp eyes spot a high-tensile cable still intact amidst the chaos, and you deftly cut it free. Nearby, a shattered wall panel contains a sheet of flexible polymer, exactly what you need for a bow limb.
        ~ has_flexible_polymer = true
        ~ has_tensile_cable = true
    }
    { character_name == "Aris":
        Your trained eyes spot useful components that others would dismiss as junk. You salvage some intact copper wires and a magnetic coil from a ruined transformer.
        ~ has_copper_wiring = true
        ~ has_magnetic_coil = true
        { power_cell_stack == 0:
             // If Aris used the first one, he can find another
             Tucked away inside the transformer's casing is another Degraded Power Cell, apparently undamaged by the overload. A lucky find.
             ~ power_cell_stack += 1
        }
    }
    You've gathered what you can.
    -> scene_7a_gearing_up

// === SCENE 7A: GEARING UP ===
=== scene_7a_gearing_up ===
Before you proceed, you find a relatively sheltered alcove in the ruins to catch your breath and take stock of what you have. This is a good opportunity to prepare for what's ahead.
+ [Use your resources to craft something useful.]
    -> crafting_options (-> scene_7a_gearing_up)
+ [Scour the area for more resources.]
    -> scene_7b_grinding
* { not has_reinforced_club and not has_recurve_bow and not has_emp_grenade } [Save your resources and move on.]
    -> scene_8_the_tower
+ { has_reinforced_club or has_recurve_bow or has_emp_grenade or has_moss_poison_vial or poison_bomb_stack > 0 } [You are prepared. Move on.]
    -> scene_8_the_tower
+ [Check Status]
    -> check_status( -> scene_7a_gearing_up)



// === SCENE 7B: RESOURCE GRINDING ===
=== scene_7b_grinding ===
You scan the immediate vicinity for any useful materials you may have missed.
+ [Search the damp crevices for Glimmer Moss.]
    -> grind_moss
+ [Sift through the wreckage for Power Cells.]
    -> grind_power_cells
+ [Stop searching and return.]
    -> scene_7a_gearing_up

= grind_moss
    ~ temp roll = RANDOM(1, 3)
    { roll <= 2:
        // Success
        You find another small patch of the glowing fungus. You add it to your collection.
        ~ glimmer_moss_stack += 1
    - else:
        // Failure
        You search for a while but find nothing. This area seems picked clean for now.
    }
    -> scene_7b_grinding

= grind_power_cells
    ~ temp roll = RANDOM(1, 4)
    { roll == 1:
        // Success
        Your persistence pays off. Wedged inside a damaged console, you find another Degraded Power Cell.
        ~ power_cell_stack += 1
    - else:
        // Failure
        You find plenty of scrap, but no functional power sources.
    }
    -> scene_7b_grinding