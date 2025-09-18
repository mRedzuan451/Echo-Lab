document.addEventListener('DOMContentLoaded', () => {
    const storyContainer = document.getElementById('story');
    const choicesContainer = document.getElementById('choices');

    // 1. Load your compiled JSON file
    fetch('echo_lab_chapter_1.json')
        .then(response => response.text())
        .then(json => {
            // 2. Create a new inkjs story
            const myStory = new inkjs.Story(json);
            continueStory();
        });

    function continueStory() {
        // Clear previous story text and choices
        storyContainer.innerHTML = '';
        choicesContainer.innerHTML = '';

        // 3. Continue the story until there's content to show
        while (myStory.canContinue) {
            const text = myStory.Continue();
            const p = document.createElement('p');
            p.innerHTML = text;
            storyContainer.appendChild(p);
        }

        // 4. Display the current choices
        if (myStory.currentChoices.length > 0) {
            myStory.currentChoices.forEach(choice => {
                const choiceButton = document.createElement('button');
                // Use the same button style from your index.html
                choiceButton.classList.add('btn', 'w-full', 'p-4', 'rounded-lg', 'text-left');
                choiceButton.innerHTML = choice.text;

                // Add a click event listener
                choiceButton.addEventListener('click', () => {
                    // 5. Tell the story which choice was made
                    myStory.ChooseChoiceIndex(choice.index);
                    // Continue the story
                    continueStory();
                });

                choicesContainer.appendChild(choiceButton);
            });
        } else {
            // Story is over
            const endMessage = document.createElement('p');
            endMessage.innerHTML = '--- End of Chapter ---';
            storyContainer.appendChild(endMessage);
        }
    }
});