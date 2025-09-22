=== tower_floor_2 ===
The second floor is a cramped server room. A hulking figure, the "Brute," blocks the only doorway, cracking their knuckles. "Tower's mine," they grunt. "Get lost or get broken." This will be a fight.
-> setup_brute_battle

=== tower_floor_3 ===
After defeating the Brute, you ascend to the third floor, a darkened observation deck. You don't see anyone, but your instincts scream "trap."
<i>PROCTOR: "First subject to bypass the obstacle demonstrates superior situational awareness."</i>
* [Scan for the trap - Perception/Intelligence Check]
    ~ temp roll = RANDOM(1, 6)
    ~ temp total_skill = perception + intelligence + roll
    { total_skill >= 18:
        // Success
        { character_name == "Aris": Your AI implant flags a hidden pressure plate wired to a jury-rigged arc welder. A nasty trap. | Your eyes catch the faint shimmer of a tripwire connected to a weighted net. Amateurish, but deadly.} You easily disable it. A shadowy figure, the "Ghost," curses from the far side of the room and flees upwards.
    - else:
        // Failure
        You step forward and a trap springs! A heavy cargo net drops from the ceiling, entangling you. It takes you precious moments to cut yourself free. You've lost time, and the Ghost is long gone.
        ~ is_fatigued = true
    }
    -> tower_buffer_room(-> tower_floor_4)

= tower_floor_4
The fourth floor is a chaotic workshop, filled with sparking contraptions. A contestant in a customized tech-suit, the "Tinkerer," is working on a device. "Ah, a new test subject!" they exclaim, leveling a whirring gadget at you.
-> setup_tinkerer_battle

=== tower_floor_5 ===
You reach the final floor before the spire's peak. A contestant with cold, professional eyes, the "Veteran," stands waiting for you. They hold a sharpened piece of rebar like a short sword. "Only one of us gets that fragment," they say calmly. "Let's make this quick."
-> setup_veteran_battle

=== tower_top ===
Panting and bruised, you finally reach the open-air platform at the peak of the tower. The emergency light flashes on the console where the **second Data Fragment** is waiting. You take it.
~ data_fragments += 1
-> scene_9_the_bargain // Now points to the correct next scene

// === SCENE 8A: TOWER BUFFER ROOM ===
=== tower_buffer_room(-> next_floor) ===
You find a small, cramped access corridor between the floors. The sounds of combat have faded, giving you a brief moment to recover before ascending further.
    * { is_fatigued } [Shake off the fatigue.]
        You stretch your aching muscles and take a long drink of water. The weariness recedes, and you feel ready to continue.
        ~ is_fatigued = false
        -> tower_buffer_room(next_floor)
        
    + { glimmer_moss_stack > 0 and is_injured } [Use Glimmer Moss ({glimmer_moss_stack} left).]
        // We will call the existing moss scene, then return here.
        -> use_glimmer_moss_tunnel(true) -> tower_buffer_room(next_floor)
        
    + [Proceed to the next floor.]
        Steeling yourself, you continue your ascent.
        -> next_floor
    
    + [Check Status]
        -> check_status(-> tower_buffer_room)

// --- Tower Battle Setups ---
=== setup_brute_battle ===
    ~ current_enemy_name = "The Brute"
    ~ current_enemy_hp = 30
    ~ current_enemy_atk = 8
    ~ current_enemy_def = 4
    ~ enemy2_hp = 0 // Signal that there is no second enemy
    -> battle_loop
    
=== setup_tinkerer_battle ===
    ~ current_enemy_name = "The Tinkerer"
    ~ current_enemy_hp = 20
    ~ current_enemy_atk = 8
    ~ current_enemy_def = 2
    ~ enemy2_hp = 0 // Signal that there is no second enemy
    -> battle_loop
    
=== setup_veteran_battle ===
    ~ current_enemy_name = "The Veteran"
    ~ current_enemy_hp = 25
    ~ current_enemy_atk = 7
    ~ current_enemy_def = 3
    ~ enemy2_hp = 0 // Signal that there is no second enemy
    -> battle_loop