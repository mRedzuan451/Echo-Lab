# Chapter 1: The Drop - Script Outline

**Objective:** Introduce the player to the world, core survival mechanics, the AI, and the first major event. The player must acquire their first Data Fragment and activate the Archive Gate.

---

### **SCENE 1: IMPACT**

* **LOCATION:** Drop Pod, moments before landing.
* **CHARACTERS:** The Player.
* **SUMMARY:** The chapter opens with the player confined and disoriented inside a drop pod during a violent atmospheric re-entry. They witness the shattered planet through a viewport before the pod crashes, knocking them unconscious.
* **PLAYER CHOICE:** None. This scene is a non-interactive cinematic to establish the tone and setting.
* **OUTCOME:** The player blacks out. Leads to Scene 2.

---

### **SCENE 2: AWAKENING**

* **LOCATION:** Ruined Maintenance Bay (The first room).
* **CHARACTERS:** The Player, The AI (voice).
* **SUMMARY:** The player awakens to the AI implant activating in their head. The drop pod door opens, revealing the bay. The AI provides location data ("Test Site Echo-7," "Ruined City-Isle"). The player must choose a character, which sets their base stats.
* **PLAYER CHOICE:**
    1.  Select a character (Kaelen, Aris, or Lena).
* **OUTCOME:** Base stats are set. The player is now in control and can explore the room. Leads to Scene 3.

---

### **SCENE 3: THE FIRST ROOM**

* **LOCATION:** Ruined Maintenance Bay.
* **CHARACTERS:** The Player, The AI.
* **SUMMARY:** The player explores the starting room, which contains a rusted locker and a patch of Glimmer Moss. This scene serves as a tutorial for basic skill checks and resource gathering.
* **PLAYER CHOICE:**
    1.  **Investigate the Locker:** A skill check is required (Strength to force, Agility to pick, or Intelligence to hotwire).
    2.  **Investigate the Moss:** A skill check is required (Perception to notice details, Aris's Bio-Scan for full analysis).
    3.  **Query the AI:** Interact with the AI for more lore/context.
    4.  **Leave the room.**
* **OUTCOME:** The player potentially gains their first resources (**Degraded Power Cell**, **Glimmer Moss Sample**). After exploring, they proceed through the collapsed doorway. Leads to Scene 4.

---

### **SCENE 4: THE FIRST OBSTACLE**

* **LOCATION:** A collapsed transit tunnel connecting the Maintenance Bay to the Plaza.
* **CHARACTERS:** The Player.
* **SUMMARY:** To reach the plaza, the player must navigate a short but unstable tunnel. The floor is a mess of twisted metal and rubble, and the ceiling groans under the strain. This is a mandatory challenge to proceed.
* **PLAYER CHOICE (All characters see all options):**
    1.  **[BRUTE FORCE]:** Shove a large piece of debris to create a stable, direct path.
    2.  **[ANALYZE]:** Scan the structure for the most stable route and reinforce a weak point with scrap metal.
    3.  **[NAVIGATE]:** Nimbly climb and weave through the most dangerous, but quickest, path.
* **OUTCOME:**
    * **SUCCESS (Choosing the correct option for your character):**
        * If you are **Kaelen** and choose **[BRUTE FORCE]**...
        * If you are **Aris** and choose **[ANALYZE]**...
        * If you are **Lena** and choose **[NAVIGATE]**...
        * ...you succeed. You use your natural talents to pass through the tunnel unharmed, all attributes intact.
    * **FAILURE (Choosing the incorrect option for your character):**
        * If you are Kaelen and choose to Analyze, or Lena and choose Brute Force, etc...
        * ...your attempt is clumsy and ill-suited to your skills. A piece of rubble gives way, and you get through, but you are injured or exhausted. You receive a temporary debuff or a minor permanent reduction (e.g., -1) to the attribute you tried to use (Strength for Brute Force, Intelligence for Analyze, or Agility for Navigate). This will make the skill check in Scene 5A more difficult.
    * Leads to Scene 5.

---

### **SCENE 5: THE CROSSROADS & THE ANNOUNCEMENT**

* **LOCATION:** A ruined city plaza outside the transit tunnel.
* **CHARACTERS:** The Player, The Proctor (voice).
* **SUMMARY:** The player emerges into a larger area with two clear paths. A high-Perception character may notice tracks. The Proctor's booming voice announces the **Major Event: The Drop**, a time-limited supply cache landing in the plaza.
* **PLAYER CHOICE:**
    1.  **Go for the Supply Drop:** Head towards the contested location.
    2.  **Ignore the Drop:** Choose a path (rooftops or subway) to avoid the conflict.
* **OUTCOME:** Leads to either **Scene 5A** (Go for Drop) or **Scene 6** (Ignore Drop).

---

### **SCENE 5A: THE CACHE**

* **LOCATION:** Central Plaza, near the supply cache landing zone.
* **CHARACTERS:** The Player, their Rival.
* **SUMMARY:** The player approaches the supply cache and finds their Rival already there. This is their first meeting, a direct confrontation over a valuable prize.
* **PLAYER CHOICE:**
    1.  **Direct Confrontation (Skill Check):** Challenge the Rival. The check will be harder if the player failed in Scene 4.
    2.  **Create a Diversion.**
    3.  **Observe and Withdraw.**
* **OUTCOME:** The player may gain the **Kinetic Field Emitter** at the cost of starting a hostile relationship, or play it safe. Leads to Scene 6.

---

### **SCENE 6: THE FIRST TEST**

* **LOCATION:** Deeper within the chosen path (rooftops or subway).
* **CHARACTERS:** The Player, The AI.
* **SUMMARY:** The player discovers their first "Test Chamber" and must complete it to earn a Data Fragment.
* **PLAYER CHOICE:** The test is path-dependent (Traversal or Combat/Stealth).
* **OUTCOME:** Player acquires the **first Data Fragment**. Leads to Scene 7.

---

### **SCENE 7: THE BARGAIN**

* **LOCATION:** A dilapidated hab-block, lit by a single emergency light. Rain streaks down a grimy window.
* **CHARACTERS:** The Player, Jedediah "Jed".
* **SUMMARY:** The AI directs the player toward a faint energy signature. Inside a small, ruined apartment, they find Jed. He's an older, weathered man, slumped against a wall with a makeshift splint on his leg. He has a Data Fragment clutched in his hand, but his canteen is empty and lying on its side. He looks up at the player, not with fear, but with weary resignation.

* **Jed's Opening Dialogue:** "Well, look what the cat dragged in. Don't worry, I'm not looking for a fight. Leg's busted. All I need is a canteen of clean water. This place is picked clean. You bring me some water, and this shiny little doodad is all yours. I can't get to the Gate like this anyway."

* **PLAYER CHOICE (Character-Dependent):**

    * **If Kaelen:**
        * **1. [HELP - Endurance Check]:** "Stay put. I'll find you some water."
            * **Outcome:** Kaelen finds a nearby water source but must fend off a few Skulkers attracted to the area. He returns, battered but successful. Jed gives him the fragment and a nod of respect.
            * **Consequence Flag:** `Jed_Helped` set. Jed is now a potential ally.

        * **2. [INTIMIDATE - Strength Check]:** "The fragment. Now. Or we see how that other leg holds up."
            * **Outcome:** Kaelen's threat is palpable. Jed, seeing no other option, tosses him the fragment with a look of pure contempt. "You're just like the others," he mutters.
            * **Consequence Flag:** `Jed_Hostile` set. Jed will remember this and may actively work against the player later.

        * **3. [ATTACK]:** (Say nothing and attack him.)
            * **Outcome:** Jed is in no condition to fight back. Kaelen takes the fragment from his body. The AI's voice is cold and flat in his mind: *"Subject neutralized. A logical, if predictable, outcome."*
            * **Consequence Flag:** `Jed_Dead` set.

    * **If Aris:**
        * **1. [HELP - Intelligence Check]:** "Your splint is inadequate. I can craft a proper medical brace, and I have water purification tablets. Let's make a deal."
            * **Outcome:** Aris uses his technical skill to craft a high-quality brace for Jed's leg. In return, Jed gratefully hands over the fragment and a piece of useful lore about the local flora.
            * **Consequence Flag:** `Jed_Helped` set. Jed is now a potential ally with high respect for Aris's skills.

        * **2. [DECEIVE - Intelligence Check]:** "I have a powerful healing salve. Let me apply it. But I'll need to hold the fragment while I work, as a show of good faith."
            * **Outcome:** Aris applies a useless poultice of crushed leaves. While Jed is distracted by the placebo, Aris pockets the fragment and slips away. Jed's curses follow him down the corridor.
            * **Consequence Flag:** `Jed_Hostile` set. Jed will remember being outsmarted and will be wary of the player's tricks in the future.

        * **3. [ATTACK]:** (Use a crafted poison or trap.)
            * **Outcome:** Aris uses his knowledge to neutralize Jed without a direct fight. He retrieves the fragment. The AI notes, *"Subject neutralized. An efficient application of available resources."*
            * **Consequence Flag:** `Jed_Dead` set.

    * **If Lena:**
        * **1. [HELP - Perception Check]:** "I'll get your water. But I'm scouting the area first."
            * **Outcome:** Lena's sharp eyes spot a hidden rainwater collector on a nearby balcony that others would have missed. She retrieves the water safely and quickly. Jed is impressed by her efficiency and gives her the fragment, plus a tip about a hidden route.
            * **Consequence Flag:** `Jed_Helped` set. Jed is now a potential ally who sees Lena as a reliable survivor.

        * **2. [STEAL - Agility Check]:** "Look out!" (Create a diversion and attempt to snatch the fragment).
            * **Outcome:** Lena points to the window, yelling a warning. As Jed's head whips around, she uses her speed to snatch the fragment from his hand and dart out of the room before he can react.
            * **Consequence Flag:** `Jed_Hostile` set. Jed will remember Lena's speed and ruthlessness.

        * **3. [ATTACK]:** (Use a stealth attack.)
            * **Outcome:** Lena slips into the shadows and neutralizes Jed before he knows what's happening. She takes the fragment. The AI comments, *"Subject neutralized. Minimal energy expenditure. Optimal."*
            * **Consequence Flag:** `Jed_Dead` set.

* **OUTCOME:** The player acquires the **second Data Fragment** and sets a critical story flag that will shape the narrative of Chapter 2 and beyond. Leads to Scene 7.

---

### **SCENE 8: THE LAIR**

* **LOCATION:** A heavily defended nest.
* **CHARACTERS:** The Player, Alpha Skulker Matriarch.
* **SUMMARY:** The player finds the third Data Fragment in the nest of the zone's Apex Predator.
* **PLAYER CHOICE:** Direct assault, environmental sabotage, or stealth infiltration.
* **OUTCOME:** Player acquires the **third and final Data Fragment**. Leads to Scene 9.

---

### **SCENE 9: THE GATE**

* **LOCATION:** A hidden, ancient-looking part of the ruins.
* **CHARACTERS:** The Player, The AI.
* **SUMMARY:** With all fragments, the AI reveals the location of the Archive Gate. The player activates it.
* **PLAYER CHOICE:** Step through the Gate.
* **OUTCOME:** Chapter 1 concludes as the player is transported to the next zone.
