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
VAR rival_name = ""

// === RIVAL RELATIONSHIP SYSTEM ===
CONST GRUDGE = 20
CONST HOSTILE = 50
CONST NORMAL = 80
CONST FRIENDLY = 100
VAR rival_relationship = HOSTILE

// Flag for the final battle's endgame state
VAR rival_is_waiting_for_opening = false

// Rival Emitter Charges
VAR rival_emitter_charges = 0

// Rival Skill Usage Flags
VAR rival_used_non_combat_skill = false
VAR rival_used_combat_skill = false

// Inventory Flags (true = has, false = doesn't have)
VAR power_cell_stack = 0
VAR glimmer_moss_stack = 0
VAR has_kinetic_emitter = false
VAR emitter_charges = 0
VAR neuro_stim_state = "NONE" // Can be NONE, AVAILABLE, ACTIVE, USED

// Analyzed item Flags
VAR analyzed_power_cell = false
VAR analyzed_glimmer_moss = false
VAR studied_emitter = false

// Skill System
LIST AllSkills = Survivalist, BioScan, DiscerningEye, HeavyHitter, Overcharge, CounterAttack, TargetedAnalysis
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
VAR rival_is_defending = false

// Skill Usage Flags (for specific scenes)
VAR used_survivalist_in_bay = false
VAR used_bioscan_in_bay = false
VAR used_discerningeye_in_bay = false

// Archivist Log Flags
VAR found_first_log = false
VAR know_skulker_weakness = false
// Jed's Unlocked Log Intel
VAR log_knows_site_purpose = false
VAR log_knows_shattered_world_cause = false
VAR log_knows_proctor_ethics = false

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

// Aris's Organic Resources & Crafted Items
VAR skulker_venom_gland_stack = 0
VAR has_moss_poison_vial = 0 // Can craft multiple
VAR poison_bomb_stack = false

// Poison Status Effect
VAR enemy_is_poisoned = false
VAR poison_turns_remaining = 0

// Equip Equipment
VAR emitter_equipped = false
VAR club_equipped = false
VAR bow_equipped = false

// New Skill State Flags
VAR is_overcharging = false
VAR is_countering = false
VAR enemy2_will_miss_next_turn = false

// Jed's Character-Specific Rewards
VAR has_club_upgrade_kit = false
VAR knows_calming_poultice_recipe = false
VAR silent_arrow_count = 0
VAR scrap_arrow_count = 0
VAR shock_arrow_count = 0
VAR club_is_upgraded = false

// New Scavenging Finds
VAR has_titan_beetle_carapace = false
VAR has_adrenaline_shot = false

// === SCENE 10: FINAL BATTLE STATE ===
// Contribution Tracking
VAR player_contribution = 0
VAR rival_contribution = 0
VAR jed_contribution = 0
VAR ally_3_contribution = 0
VAR ally_4_contribution = 0

// Add these to track ally health and status
VAR ally_3_hp = 20
VAR ally_4_hp = 20
VAR ally_3_is_down = false
VAR ally_4_is_down = false

// Boss Stats & State
VAR alpha_skulker_hp = 0
VAR alpha_skulker_max_hp = 0
VAR alpha_skulker_atk = 0
VAR alpha_skulker_def = 0
VAR alpha_is_berserk = false

// Rival Event Flags
VAR rival_is_in_danger = false

// === 2v2 BATTLE STATE ===
VAR enemy2_name = ""
VAR enemy2_hp = 0
VAR enemy2_atk = 0
VAR enemy2_def = 0
VAR jed_hp = 0
VAR jed_max_hp = 20
VAR jed_atk = 6
VAR jed_def = 4

// Analyzed Item Type Flags
VAR analyzed_power_cell_type = false
VAR analyzed_moss_type = false
VAR analyzed_emitter_type = false
VAR analyzed_neuro_stim_type = false
VAR analyzed_club_type = false
VAR analyzed_bow_type = false
VAR analyzed_emp_grenade_type = false
VAR analyzed_metal_pipe_type = false
VAR analyzed_thick_wiring_type = false
VAR analyzed_polymer_type = false
VAR analyzed_cable_type = false
VAR analyzed_copper_wiring_type = false
VAR analyzed_magnetic_coil_type = false
VAR analyzed_venom_gland_type = false
VAR analyzed_poison_vial_type = false
VAR analyzed_poison_bomb_type = false
VAR analyzed_club_upgrade_type = false
VAR analyzed_poultice_recipe_type = false
VAR analyzed_silent_arrows_type = false
VAR analyzed_scrap_arrows_type = false
VAR analyzed_shock_arrows_type = false
VAR analyzed_beetle_carapace_type = false
VAR analyzed_adrenaline_shot_type = false

// New Log & Skill Flags
VAR log_knows_ally_buff = false
VAR jed_is_buffed = false