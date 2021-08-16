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

# Day 4 - 2021/08/10
The main thing I added was detecting when a player loses their health, and if so, remove them from the game and adding a wall where their net used to be. This is pretty identical in functionality to what happened in Quadrapong. I struggled with how to approach this implementation in a way that would keep things simple. I think my final solution is quite good. The left and right walls behind each player, I referred to those as "side posts." They're just StaticBody2D with a ColorRect and CollisionShape. Then I made a "middle post" which is exactly the same except it's a bit longer and in the middle.

When a Net is loaded into the scene, the MiddePost is disabled. When the Net detects a goal scored, if the player has no more health, it enables the MiddlePost.

For now, I've added the logic of removing the player within the Net object but in the future, I imagine I'll have to some sort of global GameManager that is responsible for these actions.

# Day 5 - 2021/08/11
I added a second level (graveyard) with an enemy that appears every few seconds (ghost).

A challenge I had was I didn't know how to add my tilemap tiles at a 8px offset. By default, I could only add them at 16px offsets.  I ended up setting the `cell_size` property 8px by 8px which resolved it, but I'm not quite sure if this is the right approach.

Additionally, I first tried using the Tilemap node for any objects that also required collisions - for example, the gravestones in the graveyard. However, since the sprite's aren't complete rectangles, I wasn't sure if there is a way to add CollisionPolygon2D to tiles in a TileMap. As a result, I ended up just creating StaticBody2Ds for any obstacle I place on the level.

# Day 6 - 2021/08/12
Short update: I added a new level (river forest), added a new enemy (octopus), and added some level selection to the main menu.

There's some duplicate code shared between both the Ghost and Octopus enemies. I think I can definitely refactor how they fade in to appear and fade out to disappear by creating some AnimationPlayer that has two animations: fade_in and fade_out. Then I can re-use this component on any enemies within my game. For now, I'll leave it as is but I've added it to my backlog for next week.

# Day 7 - 2021/08/13
I started adding some sound and visual effects to the game.

I initially started using [Bfxr](https://www.bfxr.net), but I couldn't produce many sound effects that I was too thrilled with. I had used [ChipTone](https://sfbgames.itch.io/chiptone) a few times before so I switched back to it and I found I was able to make the types of sound effects I was looking for. I did briefly watch a video of [Arkanoid (NES)](https://www.youtube.com/watch?v=3luUb7WEm7k) to get a sense of what types of sound effects were used in the game. So far, I've just added some basic menu selection, wall hit, and player hit sounds. 

As for visual effects, I've been inspired by a recent talk I watched, [Juice it or lose it](https://www.youtube.com/watch?v=Fy0aCDmgnxg), by Martin Jonasson and Petri Puhro. I wanted to do similar sorts of "juicy" effects in my game but wasn't exactly sure how to do it. My first instinct was just to use a Tween and tween the player's scale to a certain amount and back. I found I didn't need to make it that complicated - I just need a single tween from 1.3x scale back to 1.0x scale:

```gdscript
func on_hit():
	SoundFX.play("player_hit.wav")
	$Tween.interpolate_property(
		self, # object
		"scale", # property
		Vector2(1.3, 1.3), # initial_val
		Vector2(1.0, 1.0), # final_val
		0.3, # duration
		Tween.TRANS_BACK, # trans_type
		Tween.EASE_IN # ease_type
	)
	$Tween.start()
```

As for the walls, I had something similar in mind. The one thing I wanted to do was add a little color for when the ball hits the wall. I was inspired by a demo in the [Godot docs](https://docs.godotengine.org/en/stable/tutorials/physics/using_kinematic_body_2d.html#bouncing-reflecting) where the wall has a flashing effect on hit. I implemented this in a similar way, where I just start a Tween from red to white.

# Day 8 - 2021/08/14
Not the largest update but I continued adding visual and sound effects to the game: hitting a gravestone, scoring a goal, letting a goal in, and hitting a tree. I also added some quality of life features: press "r" to reset the ball to the middle and "s" to serve it.

To date, I haven't had a hard plan of exactly what I'm doing each day. I have sort of a laundry list of tasks in Trello, sorted by "this week" and "eventually". "This week" are tasks that I generally deem necessary to have some decent sort of demo, and all of my issues or nice-to-have's go under "eventually."

# Day 9 - 2021/08/15
The main things I added were life bars for each player, a UFO enemy, and a generic enemy spawnner that I can reuse across levels.

The generic enemy spawnner is quite simple: it takes a `spawn_interval`, `max_spawn_count` and the enemy scene that it needs to spawn. Every `spawn_interval` seconds, it checks to see how many enemies it's spwanned already - if this is less than `max_spawn_count`, it spawns a new one.

Each enemy stores its own internal logic of how it moves, where it starts, where it moves toward.

Something I have noticed is that I'm reusing the same Tween over and over again in each enemy class:

```gdscript
func on_hit():
	$Tween.interpolate_property(
		self, # object
		"scale", # property
		Vector2(1.2, 1.2), # initial_val
		Vector2(1.0, 1.0), # final_val
		0.2, # duration
		Tween.TRANS_BACK, # trans_type
		Tween.EASE_IN # ease_type
	)
	$Tween.start()
```

It's beginning to be a bit cumbersome to have to do this on every enemy I create (along with every object in the game that becomes bigger on hit). I've thought about making a global Tween and adding a default `interpolate_size` method so that for all objects, I can simply do:

```gdscript
// enemy.gd
func on_hit():
	GlobalTween.interpolate_size(self)

// global_tween.gd
func interpolate_size(object):
	$Tween.interpolate_property(
		object,
		"scale", # property
		Vector2(1.2, 1.2), # initial_val
		object.scale, , # final_val
		0.2, # duration
		Tween.TRANS_BACK, # trans_type
		Tween.EASE_IN # ease_type
	)
	$Tween.start()
```
