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
    { not has_degraded_power_cell and glimmer_moss_stack == 0 and not has_kinetic_emitter and neuro_stim_state != "AVAILABLE" and not has_reinforced_club and not has_recurve_bow and not has_emp_grenade:
        - Your pockets are empty.
    }
    { has_degraded_power_cell: - Degraded Power Cell }
    { glimmer_moss_stack > 0: - Glimmer Moss Sample (x{glimmer_moss_stack}) }
    { has_kinetic_emitter: - Kinetic Field Emitter ({emitter_charges} charges) }
    { neuro_stim_state == "AVAILABLE": - Neuro-Stim - Single Use }
    { has_reinforced_club: - Reinforced Club }
    { has_recurve_bow: - Recurve Bow }
    { has_emp_grenade: - EMP Grenade (Single Use) }
    { has_metal_pipe: - Sturdy Metal Pipe }
    { has_thick_wiring: - Thick Wiring }
    { has_flexible_polymer: - Flexible Polymer }
    { has_tensile_cable: - High-Tensile Cable }
    { has_copper_wiring: - Copper Wiring }
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