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
