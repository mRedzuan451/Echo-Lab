// === VARIABLE DEFINITIONS ===

// Character stats
VAR strength = 0
VAR intelligence = 0
VAR agility = 0
VAR perception = 0
VAR resolve = 100

// Character Status
VAR is_fatigued = false
VAR is_injured = false

// Player's chosen name
VAR character_name = ""

// Inventory Flags (true = has, false = doesn't have)
VAR has_degraded_power_cell = false
VAR glimmer_moss_stack = 0
VAR has_kinetic_emitter = false
VAR emitter_charges = 0
VAR neuro_stim_state = "NONE" // Can be NONE, AVAILABLE, ACTIVE, USED

// Analyzed item Flags
VAR analyzed_power_cell = false
VAR analyzed_glimmer_moss = false
VAR studied_emitter = false

// Skill System
LIST AllSkills = Survivalist, BioScan, DiscerningEye
VAR player_skills = ()

// Consequence Flags
VAR jed_status = "UNKNOWN" // Can be UNKNOWN, HELPED, HOSTILE, DEAD
VAR scene_4_debuff_stat = "" // To track debuff from Scene 4
VAR rival_has_emitter = false
VAR rival_owes_favour = false

// Data Fragments
VAR data_fragments = 0

// Combat Stats
VAR max_hp = 0
VAR hp = 0
VAR atk = 0
VAR def = 0

// Global Combat State Variables
VAR current_enemy_name = ""
VAR current_enemy_hp = 0
VAR current_enemy_atk = 0
VAR current_enemy_def = 0
VAR is_defending = false

// Rival Battle Stats & Flags
VAR rival_hp = 0
VAR rival_max_hp = 0
VAR rival_atk = 0
VAR rival_def = 0
VAR used_skill_in_battle = false
VAR rival_will_miss_next_turn = false

// Skill Usage Flags (for specific scenes)
VAR used_survivalist_in_bay = false
VAR used_bioscan_in_bay = false
VAR used_discerningeye_in_bay = false

// Archivist Log Flags
VAR found_first_log = false
VAR know_skulker_weakness = false

// Crafted Weapon Flags
VAR has_reinforced_club = false
VAR has_recurve_bow = false
VAR has_emp_grenade = false

// Crafting Resources
VAR has_metal_pipe = false
VAR has_thick_wiring = false
VAR has_flexible_polymer = false
VAR has_tensile_cable = false
VAR has_copper_wiring = false
VAR has_magnetic_coil = false

// Equip Equipment
VAR emitter_equipped = false
VAR club_equipped = false
VAR bow_equipped = false