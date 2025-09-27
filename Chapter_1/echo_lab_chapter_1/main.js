(function(storyContent) {

    // Create ink story from the content using inkjs
    var story = new inkjs.Story(storyContent);

    var savePoint = "";

    // If the story asks for a character identity, this stores a mapping from
    // character id (e.g. 'aris') to the choice index in the current choices.
    var pendingChoiceMapping = null;

    let savedTheme;
    let globalTagTheme;

    // Global tags - those at the top of the ink file
    // We support:
    //  # theme: dark
    //  # author: Your Name
    var globalTags = story.globalTags;
    if( globalTags ) {
        for(var i=0; i<story.globalTags.length; i++) {
            var globalTag = story.globalTags[i];
            var splitTag = splitPropertyTag(globalTag);

            // THEME: dark
            if( splitTag && splitTag.property == "theme" ) {
                globalTagTheme = splitTag.val;
            }

            // author: Your Name
            else if( splitTag && splitTag.property == "author" ) {
                var byline = document.querySelector('.byline');
                byline.innerHTML = "by "+splitTag.val;
            }
        }
    }

    var storyContainer = document.querySelector('#story');
    var outerScrollContainer = document.querySelector('.outerContainer');

    // page features setup
    setupTheme(globalTagTheme);
    var hasSave = loadSavePoint();
    setupButtons(hasSave);

    // Set initial save point
    savePoint = story.state.toJson();

    // Kick off the start of the story!
    continueStory(true);

    // Main story processing function. Each time this is called it generates
    // all the next content up as far as the next set of choices.
    function continueStory(firstTime) {

        var paragraphIndex = 0;
        var delay = 0.0;

        // Don't over-scroll past new content
        var previousBottomEdge = firstTime ? 0 : contentBottomEdgeY();

        // Generate story text - loop through available content
        while(story.canContinue) {

            // Get ink to generate the next paragraph
            var paragraphText = story.Continue();
            var tags = story.currentTags;

            // Any special tags included with this line
            var customClasses = [];
            for(var i=0; i<tags.length; i++) {
                var tag = tags[i];

                // Detect tags of the form "X: Y". Currently used for IMAGE and CLASS but could be
                // customised to be used for other things too.
                var splitTag = splitPropertyTag(tag);
				splitTag.property = splitTag.property.toUpperCase();

                // AUDIO: src
                if( splitTag && splitTag.property == "AUDIO" ) {
                  if('audio' in this) {
                    this.audio.pause();
                    this.audio.removeAttribute('src');
                    this.audio.load();
                  }
                  this.audio = new Audio(splitTag.val);
                  this.audio.play();
                }

                // AUDIOLOOP: src
                else if( splitTag && splitTag.property == "AUDIOLOOP" ) {
                  if('audioLoop' in this) {
                    this.audioLoop.pause();
                    this.audioLoop.removeAttribute('src');
                    this.audioLoop.load();
                  }
                  this.audioLoop = new Audio(splitTag.val);
                  this.audioLoop.play();
                  this.audioLoop.loop = true;
                }

                // IMAGE: src
                if( splitTag && splitTag.property == "IMAGE" ) {
                    var imageElement = document.createElement('img');
                    imageElement.src = splitTag.val;
                    storyContainer.appendChild(imageElement);

                    imageElement.onload = () => {
                        console.log(`scrollingto ${previousBottomEdge}`)
                        scrollDown(previousBottomEdge)
                    }

                    showAfter(delay, imageElement);
                    delay += 200.0;
                }

                // LINK: url
                else if( splitTag && splitTag.property == "LINK" ) {
                    window.location.href = splitTag.val;
                }

                // LINKOPEN: url
                else if( splitTag && splitTag.property == "LINKOPEN" ) {
                    window.open(splitTag.val);
                }

                // BACKGROUND: src
                else if( splitTag && splitTag.property == "BACKGROUND" ) {
                    outerScrollContainer.style.backgroundImage = 'url('+splitTag.val+')';
                }

                // CLASS: className
                else if( splitTag && splitTag.property == "CLASS" ) {
                    customClasses.push(splitTag.val);
                }

                // CLEAR - removes all existing content.
                // RESTART - clears everything and restarts the story from the beginning
                else if( tag == "CLEAR" || tag == "RESTART" ) {
                    removeAll("p");
                    removeAll("img");

                    // Comment out this line if you want to leave the header visible when clearing
                    setVisible(".header", false);

                    if( tag == "RESTART" ) {
                        restart();
                        return;
                    }
                }
            }
		
		// Check if paragraphText is empty
		if (paragraphText.trim().length == 0) {
                continue; // Skip empty paragraphs
		}

            // Create paragraph element (initially hidden)
            var paragraphElement = document.createElement('p');
            paragraphElement.innerHTML = paragraphText;
            storyContainer.appendChild(paragraphElement);

            // Add any custom classes derived from ink tags
            for(var i=0; i<customClasses.length; i++)
                paragraphElement.classList.add(customClasses[i]);

            // Fade in paragraph after a short delay
            showAfter(delay, paragraphElement);
            delay += 200.0;
        }

        // Create HTML choices from ink choices

        // Detect whether the current set of choices is asking the player to
        // choose their character identity. If so, open the image selector
        // and map selections to the appropriate ink choice index.
        var charChoiceInfo = detectCharacterChoices(story.currentChoices);
        if (charChoiceInfo.isCharacterSelection) {
            // Store mapping so the confirm handler can pick the right ink choice
            pendingChoiceMapping = charChoiceInfo.mapping; // { charId: choiceIndex }
            showCharacterSelector();
        } else {
            story.currentChoices.forEach(function(choice) {

            // Create paragraph with anchor element
            var choiceTags = choice.tags;
            var customClasses = [];
            var isClickable = true;
            for(var i=0; i<choiceTags.length; i++) {
                var choiceTag = choiceTags[i];
                var splitTag = splitPropertyTag(choiceTag);
				splitTag.property = splitTag.property.toUpperCase();

                if(choiceTag.toUpperCase() == "UNCLICKABLE"){
                    isClickable = false
                }

                if( splitTag && splitTag.property == "CLASS" ) {
                    customClasses.push(splitTag.val);
                }

            }

            
            var choiceParagraphElement = document.createElement('p');
            choiceParagraphElement.classList.add("choice");

            for(var i=0; i<customClasses.length; i++)
                choiceParagraphElement.classList.add(customClasses[i]);

            if(isClickable){
                // use javascript:void(0) to avoid navigation to '#' which can jump the page
                choiceParagraphElement.innerHTML = `<a href='javascript:void(0)'>${choice.text}</a>`
            }else{
                choiceParagraphElement.innerHTML = `<span class='unclickable'>${choice.text}</span>`
            }
            storyContainer.appendChild(choiceParagraphElement);

            // Fade choice in after a short delay
            showAfter(delay, choiceParagraphElement);
            delay += 200.0;

            // Click on choice
            if(isClickable){
                var choiceAnchorEl = choiceParagraphElement.querySelectorAll("a")[0];
                // If this choice is a timed event (e.g. Grab the Neuro-Stim), start a
                // short timer on hover/touch that will remove the choice if the
                // player doesn't click it in time.
                var hoverTimer = null;
                var isTimedChoice = /neuro-stim/i.test(choice.text);

                if (isTimedChoice) {
                    // helper to create the countdown ring element
                    function addCountdown() {
                        removeCountdown();
                        var ring = document.createElement('span');
                        ring.className = 'countdown-ring';
                        // start animation by adding class in next tick
                        setTimeout(function(){ ring.classList.add('countdown-animate'); }, 16);
                        choiceParagraphElement.appendChild(ring);
                        return ring;
                    }

                    function removeCountdown() {
                        var existing = choiceParagraphElement.querySelector('.countdown-ring');
                        if (existing && existing.parentNode) existing.parentNode.removeChild(existing);
                    }

                    // mouse hover starts timer
                    choiceAnchorEl.addEventListener('mouseenter', function() {
                        removeCountdown();
                        addCountdown();
                        hoverTimer = setTimeout(function() {
                            removeCountdown();
                            if (choiceParagraphElement.parentNode) {
                                choiceParagraphElement.parentNode.removeChild(choiceParagraphElement);
                            }
                        }, 1000);
                    });

                    choiceAnchorEl.addEventListener('mouseleave', function() {
                        if (hoverTimer) { clearTimeout(hoverTimer); hoverTimer = null; }
                        removeCountdown();
                    });

                    // touch devices: touchstart to begin timer, touchend to cancel
                    choiceAnchorEl.addEventListener('touchstart', function() {
                        removeCountdown();
                        addCountdown();
                        hoverTimer = setTimeout(function() {
                            removeCountdown();
                            if (choiceParagraphElement.parentNode) {
                                choiceParagraphElement.parentNode.removeChild(choiceParagraphElement);
                            }
                        }, 1000);
                    });
                    choiceAnchorEl.addEventListener('touchend', function() {
                        if (hoverTimer) { clearTimeout(hoverTimer); hoverTimer = null; }
                        removeCountdown();
                    });
                }

                choiceAnchorEl.addEventListener("click", function(event) {

                    // Don't follow <a> link
                    event.preventDefault();

                    // Cancel any pending timed removal for this choice so click proceeds
                    if (hoverTimer) { clearTimeout(hoverTimer); hoverTimer = null; }

                    // Extend height to fit
                    // We do this manually so that removing elements and creating new ones doesn't
                    // cause the height (and therefore scroll) to jump backwards temporarily.
                    storyContainer.style.height = contentBottomEdgeY()+"px";

                    // Remove all existing choices
                    removeAll(".choice");

                    // Tell the story where to go next
                    story.ChooseChoiceIndex(choice.index);

                    // This is where the save button will save from
                    savePoint = story.state.toJson();

                    // Aaand loop
                    continueStory();
                });
            }
            });
        }

		// Unset storyContainer's height, allowing it to resize itself
		storyContainer.style.height = "";

        if( !firstTime )
            scrollDown(previousBottomEdge);

    }

    function restart() {
        story.ResetState();

        setVisible(".header", true);

        // set save point to here
        savePoint = story.state.toJson();

        continueStory(true);

        outerScrollContainer.scrollTo(0, 0);
    }

    // -----------------------------------
    // Various Helper functions
    // -----------------------------------

    // Detects whether the user accepts animations
    function isAnimationEnabled() {
        return window.matchMedia('(prefers-reduced-motion: no-preference)').matches;
    }

    // Fades in an element after a specified delay
    function showAfter(delay, el) {
        if( isAnimationEnabled() ) {
            el.classList.add("hide");
            setTimeout(function() { el.classList.remove("hide") }, delay);
        } else {
            // If the user doesn't want animations, show immediately
            el.classList.remove("hide");
        }
    }

    // Scrolls the page down, but no further than the bottom edge of what you could
    // see previously, so it doesn't go too far.
    function scrollDown(previousBottomEdge) {
        // If the user doesn't want animations, let them scroll manually
        if ( !isAnimationEnabled() ) {
            return;
        }

        // Line up top of screen with the bottom of where the previous content ended
        var target = previousBottomEdge;

        // Can't go further than the very bottom of the page
        var limit = outerScrollContainer.scrollHeight - outerScrollContainer.clientHeight;
        if( target > limit ) target = limit;

        var start = outerScrollContainer.scrollTop;

        var dist = target - start;
        var duration = 300 + 300*dist/100;
        var startTime = null;
        function step(time) {
            if( startTime == null ) startTime = time;
            var t = (time-startTime) / duration;
            var lerp = 3*t*t - 2*t*t*t; // ease in/out
            outerScrollContainer.scrollTo(0, (1.0-lerp)*start + lerp*target);
            if( t < 1 ) requestAnimationFrame(step);
        }
        requestAnimationFrame(step);
    }

    // The Y coordinate of the bottom end of all the story content, used
    // for growing the container, and deciding how far to scroll.
    function contentBottomEdgeY() {
        var bottomElement = storyContainer.lastElementChild;
        return bottomElement ? bottomElement.offsetTop + bottomElement.offsetHeight : 0;
    }

    // Remove all elements that match the given selector. Used for removing choices after
    // you've picked one, as well as for the CLEAR and RESTART tags.
    function removeAll(selector)
    {
        var allElements = storyContainer.querySelectorAll(selector);
        for(var i=0; i<allElements.length; i++) {
            var el = allElements[i];
            el.parentNode.removeChild(el);
        }
    }

    // Used for hiding and showing the header when you CLEAR or RESTART the story respectively.
    function setVisible(selector, visible)
    {
        var allElements = storyContainer.querySelectorAll(selector);
        for(var i=0; i<allElements.length; i++) {
            var el = allElements[i];
            if( !visible )
                el.classList.add("invisible");
            else
                el.classList.remove("invisible");
        }
    }

    // Helper for parsing out tags of the form:
    //  # PROPERTY: value
    // e.g. IMAGE: source path
    function splitPropertyTag(tag) {
        var propertySplitIdx = tag.indexOf(":");
        if( propertySplitIdx != null ) {
            var property = tag.substr(0, propertySplitIdx).trim();
            var val = tag.substr(propertySplitIdx+1).trim();
            return {
                property: property,
                val: val
            };
        }

        return null;
    }

    // Loads save state if exists in the browser memory
    function loadSavePoint() {

        try {
            let savedState = window.localStorage.getItem('save-state');
            if (savedState) {
                story.state.LoadJson(savedState);
                return true;
            }
        } catch (e) {
            console.debug("Couldn't load save state");
        }
        return false;
    }

    // Detects which theme (light or dark) to use
    function setupTheme(globalTagTheme) {

        // load theme from browser memory
        var savedTheme;
        try {
            savedTheme = window.localStorage.getItem('theme');
        } catch (e) {
            console.debug("Couldn't load saved theme");
        }

        // Check whether the OS/browser is configured for dark mode
        var browserDark = window.matchMedia("(prefers-color-scheme: dark)").matches;

        if (savedTheme === "dark"
            || (savedTheme == undefined && globalTagTheme === "dark")
            || (savedTheme == undefined && globalTagTheme == undefined && browserDark))
            document.body.classList.add("dark");
    }

    // Used to hook up the functionality for global functionality buttons
    function setupButtons(hasSave) {

        let rewindEl = document.getElementById("rewind");
        if (rewindEl) rewindEl.addEventListener("click", function(event) {
            removeAll("p");
            removeAll("img");
            setVisible(".header", false);
            restart();
        });

        let saveEl = document.getElementById("save");
        if (saveEl) saveEl.addEventListener("click", function(event) {
            try {
                window.localStorage.setItem('save-state', savePoint);
                document.getElementById("reload").removeAttribute("disabled");
                window.localStorage.setItem('theme', document.body.classList.contains("dark") ? "dark" : "");
            } catch (e) {
                console.warn("Couldn't save state");
            }

        });

        let reloadEl = document.getElementById("reload");
        if (!hasSave) {
            reloadEl.setAttribute("disabled", "disabled");
        }
        reloadEl.addEventListener("click", function(event) {
            if (reloadEl.getAttribute("disabled"))
                return;

            removeAll("p");
            removeAll("img");
            try {
                let savedState = window.localStorage.getItem('save-state');
                if (savedState) story.state.LoadJson(savedState);
            } catch (e) {
                console.debug("Couldn't load save state");
            }
            continueStory(true);
        });

        let themeSwitchEl = document.getElementById("theme-switch");
        if (themeSwitchEl) themeSwitchEl.addEventListener("click", function(event) {
            document.body.classList.add("switched");
            document.body.classList.toggle("dark");
        });

        // Character chooser button - opens the selector UI
        let chooseCharEl = document.getElementById("choose-character");
        if (chooseCharEl) chooseCharEl.addEventListener("click", function(event) {
            event.preventDefault();
            showCharacterSelector();
        });
    }

    // --------------------------
    // Character selection helpers
    // --------------------------

    // Show the character selector UI
    function showCharacterSelector() {
        var selector = document.getElementById('character-selector');
        if (!selector) return;

        // Move selector to the end of the story container so it appears
        // after all the text/images created by the story.
        storyContainer.appendChild(selector);

        selector.classList.remove('hidden');
        // Pre-select previously chosen character if present
        var current = getPlayerCharacter();
        if (current) {
            var btn = selector.querySelector('[data-char="'+current+'"]');
            if (btn) setSelectedOption(btn);
        }

        // Scroll so the selector (at the bottom) is visible
        setTimeout(function() {
            outerScrollContainer.scrollTo(0, contentBottomEdgeY());
        }, 40);
    }

    function hideCharacterSelector() {
        var selector = document.getElementById('character-selector');
        if (!selector) return;
        selector.classList.add('hidden');
        // keep the element in the DOM but hidden so it can be re-used later
    }

    // Mark an option button as selected visually and enable confirm
    function setSelectedOption(btn) {
        var parent = btn.closest('.character-selector');
        if (!parent) return;
        var prev = parent.querySelectorAll('.char-option.selected');
        prev.forEach(function(p){ p.classList.remove('selected'); });
        btn.classList.add('selected');
        var confirm = parent.querySelector('#confirm-character');
        if (confirm) confirm.removeAttribute('disabled');
    }

    // Retrieve saved player character id from localStorage
    function getPlayerCharacter() {
        try {
            return window.localStorage.getItem('player-character');
        } catch (e) {
            return null;
        }
    }

    // Save player character id to localStorage
    function setPlayerCharacter(id) {
        try {
            window.localStorage.setItem('player-character', id);
            // Also set in the ink story variables so .ink can read it directly
            try {
                if (story && story.variablesState) story.variablesState['playerCharacter'] = id;
            } catch (e) {
                console.debug('Could not set ink variable playerCharacter:', e);
            }
        } catch (e) {
            console.warn('Could not save player character');
        }
    }

    // Wire up selector event listeners after DOM is ready
    document.addEventListener('DOMContentLoaded', function() {
        var selector = document.getElementById('character-selector');
        if (!selector) return;

        // Option click
        var options = selector.querySelectorAll('.char-option');
        options.forEach(function(opt){
            opt.addEventListener('click', function(e){
                e.preventDefault();
                setSelectedOption(opt);
            });
        });

        // Confirm click
        var confirm = selector.querySelector('#confirm-character');
        if (confirm) confirm.addEventListener('click', function(e){
            // prevent any default button behavior that could change focus/scroll
            e.preventDefault();
            var sel = selector.querySelector('.char-option.selected');
            if (!sel) return;
            var id = sel.getAttribute('data-char');
            setPlayerCharacter(id);

            // If the story presented character choices, resolve the mapped ink choice
            if (pendingChoiceMapping && pendingChoiceMapping[id] !== undefined) {
                // Remove any rendered textual choices
                removeAll('.choice');
                // Tell the story which choice to pick
                story.ChooseChoiceIndex(pendingChoiceMapping[id]);
                // clear mapping and continue the story
                pendingChoiceMapping = null;
                hideCharacterSelector();
                // Update save point
                savePoint = story.state.toJson();
                    // Ensure the container can resize normally and remove any fixed height
                    try { storyContainer.style.height = ''; } catch (e) {}

                    // Remove focus from buttons/links which can cause scroll jumps
                    try { if (document.activeElement) document.activeElement.blur(); } catch (e) {}

                    continueStory();

                    // After story updates, make sure the page is scrolled to show new content.
                    // Set multiple scroll targets to be robust across browsers/iframes.
                    setTimeout(function() {
                        try { outerScrollContainer.scrollTo(0, contentBottomEdgeY()); } catch (e) {}
                        try { document.documentElement.scrollTop = outerScrollContainer.scrollTop; } catch (e) {}
                        try { document.body.scrollTop = outerScrollContainer.scrollTop; } catch (e) {}
                    }, 80);
                return;
            }

            hideCharacterSelector();
        });
    });

    // Expose getter to other scripts (e.g. story code) via window
    window.getPlayerCharacter = getPlayerCharacter;

    // Detect if a set of choices corresponds to a character identity choice.
    // We look for choice texts that match known character labels and return
    // a mapping from character id to choice index.
    function detectCharacterChoices(choices) {
        // Known character ids and the short name to search for in the choice text.
        // This will match the name anywhere in the choice (e.g. "I am Kaelen 'Rook' Vance, the Soldier.")
        var known = {
            'aris': 'aris',
            'kaelen': 'kaelen',
            'lena': 'lena'
        };

        var mapping = {};
        var foundAny = false;
        for (var i = 0; i < choices.length; i++) {
            var text = choices[i].text.trim().toLowerCase();

            // For each known name, check if it appears anywhere in the choice text
            for (var nameKey in known) {
                if (!known.hasOwnProperty(nameKey)) continue;
                if (text.indexOf(nameKey) !== -1) {
                    mapping[known[nameKey]] = choices[i].index;
                    foundAny = true;
                    // once matched, move to next choice
                    break;
                }
            }
        }

        return { isCharacterSelection: foundAny && Object.keys(mapping).length >= 2, mapping: mapping };
    }

})(storyContent);
