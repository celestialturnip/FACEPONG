# Day 1 - 2021/08/07
I spent the day mostly brainstorming different ideas of what to implement and how to implement them.

Ideas included:
- 2P / co-op mode (either with human or AI allies)
- Different "arena" shapes (e.g. hexagon, circle, etc)
- Different enemies and boss fights
- Different levels and "biomes" (e.g. graveyards with ghosts, road with cars)
- Foosball level with 2-3 players per side and players can only move in one dimension
- Infinite mode where the first level is a triangle with three players, the second is a square with four players, etc.
- Colour and face picker for when player starts the game

One approach that I want to follow differently from the prototype is relying on the editor to handcraft levels. With the prototype, I started off using the editor to place every element in the level. I found it a bit tedious to make sure everything is pixel perfect so I converted everything over to generating every level element programatically. But when I think ahead of the different types of levels I want to make, I think it'll be more manageable in the long-term if I design the levels in the editor, and if there's any I want to re-use (e.g. standard 4-player layout), I can simply duplicate them. I want to minimize the amount of level-specific code I have to write.

# Day 2 - 2021/08/08
I got started on re-implementation of my prototype. Aside from some housekeeping of adding utility functions and configs, the main thing I added was player and ball scenes, with their movement and basic AI.

I did experiment with a different approach for the AI from my prototype. In the prototype, I simply updated the AI's input to be in the direction of the ball at all times. I found this to be a little unnatural since humans tend to only follow the ball if it's moving their way - otherwise, they either stay in the middle or move toward where they predict the ball to go. The approach I tried using was adding an Area2D and having the AI only move toward the ball when the ball is within the AI's Area2D. However, this approach wasn't better. I had to increase the size of the Area2D otherwise the AI would not track the ball until it was too late. But I had to increase it so much that it was almost tracking the entire field of play anyway

# Day 3 - 2021/08/09
I finished the first level which is a replica of the Quadrapong layout. I spent some time looking into an issue where the player gets pushed off their starting axis and added a fix to this. I also updated the controls so the player has some acceleration when moving from side to side. This should make it more smooth and easier to do finer movements.
