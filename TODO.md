# TODOs

## Systems
- [X] Dialogue
 Walking up to people and talking to them
 Writing dialogue as external dialogue tree text files
 Variable handling in dialogue trees
- [X]  Audio
 Audio system for playing both soundtrack and sound effects
- [ ] Clue
 Tracking of gathered clues
 Tracking of completed clue sets/identities
 Both system and UI elements
- [ ] Suggesting
 Walking up to people and suggesting an identity
 Rejecting and accepting
 World visual effect based on identified state
- [ ] Layered world rework
 Current one is an ugly hack to explore and communicate the idea.
 Walking up to a "tunnel"-node should show a prompt, and if the player keeps walking in the direction of the "tunnel", they should be quickly transported to the other end
 These "tunnels" should be placed down side-streets and intersections
 The player should play a bespoke animation when walking down a "tunnel"
### Stretch goals
- [ ] World interactables and indoors
 Being able to enter houses would be cool, talk to people indoors as well.
 Seeing in-world objects and "chatting" them up would add some neat variety. This can be hacked together as a character without a model, should not be difficult. Required to be able to enter houses, probably.
- [ ] Day-night-cycle
 Having characters move around the world on a timed path depending on time of day would add a lot of life to the world, but it would also let us get more game out of fewer world assets.
- [ ] Appointments
 Appointments depend on indoors and day/night
 When talking to people, they could sometimes agree to swing by your office
 To end a day, you'd go back to your office, and people would drop by to talk
 Prime place to find more clues, and maybe even suggest an identity
 Adds a time element to the clue hunting, making it even more dynamic and varied
- [ ] Pride-flag drawing system
 When the player has figured out an identity, they could be given the opportunity to draw a pride flag.
 Could be as simple as selecting an amount of stripes and a set of colours to fill those stripes. Maybe a symbol in the middle, maybe an arrow on the side.
## Content
- [ ] Audio
 Soundtrack
 Sound effects
- [ ] character assets
 A beautiful, precious little guy walking around and helping people
- [ ] Alien character assets
 All the poor sods who need help
- [ ] World assets
 Cardboard edges on a beautifully rendered cityscape
- [ ] Identities
 We need to invent some identities, give them names, and some tropes / common archetypes
- [ ] Dialogue
 Just... so much dialogue
- [ ] UI assets
- [ ] Dialogue
 - Mock-up
 - fonts
 - Potentially character portraits
 - UI panel, scroll bar
 - Buttons
 - Potentially a per-line UI element of some kind, such as a speech-bubble, or simply a line on the side
- [ ] Clues
 - Mock-up
 - Some sort of per-clue and per-identity UI element
- [ ] Suggestion screen
 Needs a mock-up
 Could be as simple as a list of unlocked identities, could be as complex as a Papers Please-style system, where you point out past clues collected and connect them to an identity.
### Stretch goals
- [ ] Alien character behavioural scripting
 If there is a day-night-cycle, our aliens need to be told where to be when
## Exploration
- [ ] 2D alternative
 Currently the prototype is in 3D, which might be strange for a 2D game. We should try implementing something roughly equivalent using a 2D camera instead, perhaps with Parallax screens, or just containers we move ourselves.
- [ ] Camera settings and visual polish
 In the current prototype, I haven't done more than muck around with the settings. We need to figure out the lighting and camera settings that work best for our vibe. With a cardboard world, I feel a distance blur similar to a tilt-shift style could work well to sell the scale. It also tends to look very charming, which I think fits the vibe.
