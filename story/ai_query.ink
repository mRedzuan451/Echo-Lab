=== scene_3_ai_query ===
The AI's calm voice is a presence in your mind.
* (ask_where) [Ask: "Where am I?"]
    <i>AI: "You are within Test Site Echo-7, located on a fragment of a planetary body designated 'The Shattered World'. My designation for this zone is the 'Ruined City-Isle'."</i>
    -> scene_3_ai_query
* (ask_what) [Ask: "What is this place? What is the 'Arena'?"]
    <i>AI: "This 'Arena' is a controlled environment for a series of trials conducted by my creators, the Archivists. The objective is to test species' capacity for survival and adaptation."</i>
    -> scene_3_ai_query
* (ask_who) [Ask: "Who is the Proctor?"]
    <i>AI: "The Proctor is the master control AI for this entire experiment. My function is to guide and observe subjects. The Proctor's function is to administrate the trials."</i>
    -> scene_3_ai_query
* (ask_why) [Ask: "Why am I here?"]
    <i>AI: "Your selection criteria are not available in my data banks. Your purpose is to survive and demonstrate mastery of the environment. That is all the data I can provide on the subject."</i>
    -> scene_3_ai_query
* [That's enough for now.]
    -> scene_3_choices

=== scene_5_ai_query ===
The AI is silent for a moment before responding.
* (ask_proctor) [Ask: "Who was that?"]
    <i>AI: "That was the Proctor. It administrates the trials."</i>
    -> scene_5_ai_query
* (ask_drop) [Ask: "What is this 'Supply Drop'?"]
    <i>AI: "A resource distribution event. It is designed to test subjects' risk-assessment and acquisition capabilities under pressure."</i>
    -> scene_5_ai_query
* [That's all I need.]
    -> scene_5_crossroads