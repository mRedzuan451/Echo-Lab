// === DYNAMIC STAT CALCULATION ===
=== function update_combat_stats() ===
    // 1. Calculate BASE stats from attributes
    { character_name == "Kaelen":
        // The Soldier: Strength is key for attack and health.
        ~ max_hp = 15 + (strength * 2)
        ~ atk = 2 + strength
        ~ def = agility
    }
    { character_name == "Aris":
        // The Bio-Hacker: Intelligence drives his attack power.
        ~ max_hp = 12 + strength
        ~ atk = 1 + intelligence
        ~ def = agility + 1
    }
    { character_name == "Lena":
        // The Infiltrator: Agility makes her a fast hitter.
        ~ max_hp = 14 + strength
        ~ atk = 2 + agility
        ~ def = INT(perception / 2)
    }

    // 2. Apply BONUSES from equipped items
    { emitter_equipped:
        { studied_emitter:
            { character_name == "Aris":
                ~ atk += 4 // Aris gets the biggest bonus
            - else:
                ~ atk += 3 // Other characters get a good bonus
            }
        - else:
            ~ atk += 2 // Standard bonus if not studied
        }
    }
    { club_equipped:
        ~ atk += 2
        { club_is_upgraded:
            ~ atk += 1 // The upgrade adds an extra +1 attack
        }
    }
    { bow_equipped:
        ~ atk += 2 // A base bonus for now, can be changed later
    }
    // (Future equipment bonuses would go here)
    
    ~ return true

// === ITEM FUNCTIONS ===
=== function use_emitter_charge() ===
    { has_kinetic_emitter and emitter_charges > 0:
        ~ emitter_charges -= 1
        The Kinetic Field Emitter discharges with a powerful hum.
        { emitter_charges == 0:
            A final surge of power leaves the device inert, its internal mechanisms fused.
            It's broken for good.
        }
        ~ return true
    - else:
        ~ return false
    }
    
=== function display_status() ===
    -- Character Status --
    Name: {character_name}
    HP: {hp} / {max_hp}
    Attack: {atk}
    Defense: {def}
    
    -- Skills --
    { player_skills:
        {player_skills}
    - else:
        No skills learned.
    }
    
    -- Attributes --
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
    { power_cell_stack == 0 and glimmer_moss_stack == 0 and not has_kinetic_emitter and neuro_stim_state != "AVAILABLE" and not has_reinforced_club and not has_recurve_bow and not has_emp_grenade:
        - Your pockets are empty.
    }
    { power_cell_stack > 0: - Degraded Power Cell (x{power_cell_stack }) }
    { glimmer_moss_stack > 0: - Glimmer Moss Sample (x{glimmer_moss_stack}) }
    { has_kinetic_emitter: - Kinetic Field Emitter ({emitter_charges} charges) }
    { neuro_stim_state == "AVAILABLE": - Neuro-Stim - Single Use }
    { has_reinforced_club:
        - Reinforced Club {club_is_upgraded:(Upgraded)}
    }
    { has_recurve_bow: - Recurve Bow }
    { has_emp_grenade: - EMP Grenade (Single Use) }
    { has_metal_pipe: - Sturdy Metal Pipe }
    { has_thick_wiring: - Thick Wiring }
    { has_flexible_polymer: - Flexible Polymer }
    { has_tensile_cable: - High-Tensile Cable }
    { has_copper_wiring: - Copper Wiring }
    { skulker_venom_gland_stack > 0: - Skulker Venom Gland (x{skulker_venom_gland_stack}) }
    { has_moss_poison_vial > 0:
        - Moss Poison Vial (x{has_moss_poison_vial})
    }
    { poison_bomb_stack: - Poison Gas Bomb (x{poison_bomb_stack}) }
    { has_club_upgrade_kit: - Club Upgrade Kit }
    { knows_calming_poultice_recipe: - Recipe: Calming Poultice }
    { silent_arrow_count > 0: - Silent Arrows (x{silent_arrow_count}) }
    { scrap_arrow_count > 0: - Scrap Arrows (x{scrap_arrow_count}) }
    { shock_arrow_count > 0: - Shock Arrows (x{shock_arrow_count}) }
    { has_titan_beetle_carapace: - Titan-Beetle Carapace }
    { has_adrenaline_shot: - Adrenaline Shot (Single Use) }
    { has_magnetic_coil: - Magnetic Coil }
    
    -- Logs & Intel --
    { not found_first_log:
        No intel recovered.
    }
    { found_first_log and not know_skulker_weakness:
        Archivist Log \#77-B (Encrypted)
    }
    { know_skulker_weakness:
        Intel: Skulkers are vulnerable to high-frequency sonics.
    }
    
=== check_status(-> return_to) ===
    ~ display_status()
    + [Return.]
        -> return_to

=== crafting_options(-> return_point) ===
    You lay out your scavenged materials.
    
    // Kaelen's Crafting Option
    + { character_name == "Kaelen" and not has_reinforced_club and has_metal_pipe and has_thick_wiring } [Fashion a Reinforced Club.]
        You take the sturdy metal pipe and thick wiring you found. Using your strength, you wrap the wiring tightly around one end, creating a weighted, brutal-looking club. It feels solid in your hands.
        ~ has_reinforced_club = true
        ~ atk += 2
        -> crafting_options(return_point)

    // Aris's Crafting Option
    + { character_name == "Aris" and power_cell_stack > 0 and not has_emp_grenade } [Assemble an EMP Grenade.]
        You carefully pry open the casing of the Degraded Power Cell. Bypassing the safety regulators, you rig it to overload on impact. It's a volatile, single-use weapon, perfect for disabling electronics... or stunning biological targets.
        ~ has_emp_grenade = true
        ~ power_cell_stack -= 1 // The cell is consumed
        -> crafting_options(return_point)
    + { character_name == "Aris" and glimmer_moss_stack > 0 } [Refine Glimmer Moss into Poison.]
        You crush the Glimmer Moss, carefully isolating the coagulant you discovered earlier. By mixing it with a mild solvent from your kit, you refine it into a sticky, paralytic poison. You place it in an empty vial, ready for use.
        ~ has_moss_poison_vial += 1
        ~ glimmer_moss_stack -= 1
        -> crafting_options(return_point)
    + { character_name == "Aris" and skulker_venom_gland_stack > 0 and power_cell_stack > 0} [Create a Poison Gas Bomb.]
        This is a dangerous idea... but a brilliant one. You carefully puncture the Skulker's venom gland, siphoning the potent neurotoxin into the casing of the Degraded Power Cell. You rig the cell to overload, not with an EMP, but with a thermal charge that will aerosolize the venom on impact. A devastating biological weapon.
        ~ poison_bomb_stack += 1
        ~ skulker_venom_gland_stack -= 1
        ~ power_cell_stack -= 1
        -> crafting_options(return_point)

    // Lena's Crafting Option
    * { character_name == "Lena" and not has_recurve_bow and has_flexible_polymer and has_tensile_cable } [Construct a Recurve Bow.]
        You take the length of flexible polymer and the high-tensile cable. With your deft hands, you shape the polymer and string the cable, creating a makeshift but deadly silent bow. You'll need to find arrows, but the frame is perfect.
        ~ has_recurve_bow = true
        ->crafting_options(return_point)
    + { character_name == "Lena" and has_recurve_bow } [Fletch Scrap Arrows.]
        You find a few thin pieces of rebar for shafts and some sharpened scrap metal for heads. With some tattered fabric for fletching, you can assemble a small quiver's worth of arrows.
        ~ temp arrows_crafted = RANDOM(2, 4)
        ~ scrap_arrow_count += arrows_crafted
        You craft {arrows_crafted} scrap arrows.
        -> crafting_options(return_point)
    + { character_name == "Lena" and has_recurve_bow and scrap_arrow_count > 0 and power_cell_stack > 0 } [Craft Shock Arrows.]
        You carefully attach the live wire from a Degraded Power Cell to the head of a scrap arrow. It's a crude but effective way to deliver a powerful electrical jolt on impact. You manage to create a small bundle of them before the power cell is drained.
        ~ temp arrows_crafted2 = RANDOM(1, 3)
        ~ shock_arrow_count += arrows_crafted2
        ~ scrap_arrow_count -= arrows_crafted2
        ~ power_cell_stack -= 1
        You craft {arrows_crafted} shock arrows.
        -> crafting_options(return_point)
    
    // Equip Options
    * { has_reinforced_club and not club_equipped } [Equip the Reinforced Club.]
        ~ club_equipped = true
        You grip the club tightly. It's a crude but effective weapon. Your Attack has increased.
        ~ update_combat_stats()
        -> crafting_options(return_point)
    * { has_recurve_bow and not bow_equipped } [Equip the Recurve Bow.]
        ~ bow_equipped = true
        You sling the bow over your shoulder. You'll be able to strike from the shadows. Your Attack has increased.
        ~ update_combat_stats()
        -> crafting_options(return_point)

    * [That's all for now.]
        -> return_point
        
=== use_glimmer_moss_tunnel(is_safe) ===
    ~ glimmer_moss_stack -= 1
    ~ temp heal_amount = 0
    You pull out the pouch of glowing moss.
    { character_name == "Aris":
        // Aris is an expert
        Knowing its properties, you create a crude but effective poultice. The mild coagulant works quickly, and you feel a surge of vitality as the bioluminescent enzymes knit your tissues back together. You recover a significant amount of health.
        ~ heal_amount = INT(max_hp * 0.5) // Heals for 50% of max HP
    - else:
        // Kaelen and Lena are just guessing
        You crush the moss and apply it to your wounds, hoping for the best. It feels cool and soothing, and you notice your bruises fading slightly. It's not a miracle cure, but it helps. You recover a small amount of health.
        ~ heal_amount = INT(max_hp * 0.2) // Heals for 20% of max HP
    }
    ~ hp += heal_amount
    { hp > max_hp:
        ~ hp = max_hp // Don't overheal
    }
    The moss dissolves into a faint, glowing dust, its regenerative properties spent.
    ~ is_injured = false

    // --- RANDOM ATTACK CHECK ---
    { not is_safe:
        ~ temp attack_chance = RANDOM(1, 4)
        { attack_chance == 1:
            As the glow fades, you hear a frantic chittering sound. A small, rat-like creature with pale skin darts out from a crack in the wall, attracted by the moss's sweet scent. It nips at your boot before you can react, then vanishes back into the darkness. It didn't hurt, but the startling encounter has left you on edge.
            ~ resolve -= 3
        }
    }
    ->->