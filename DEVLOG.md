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

# Day 10 - 2021/08/16
I added a new level (road intersection) with a new type of interactable (car). To date, any object on the screen that randomly appears and moves around on its own... I've been just grouping it in the "enemies" folder for lack of a better place to put it. I'm not quite sure where it makes the most sense. I could just rename that folder to "interactables" since they're not enemies - they're just active bodies on the screen that move around.

Another observation I've had is balancing when to move on with a "decent" solution versus spending more time trying to get the "perfect" one. For example, when I implemented the Car, I noticed some behaviour that I forgot to anticipate such as when some players have lost all their health. In this case, the arena closes its walls so the roads of Level 4 become blocked.

What I ended up doing, and I think is okay for now, is I just came up with an "okay" solution that's good enough - which is, if there is a collision, stop  moving. This has the side-effect of piling up cars which isn't great, since the spawnner won't be able to spawn new cars once the `max_spawn_count` has been reached. However, I think right now, I'm still in the phase of implementing the full scope of my demo so I don't want to spend too long on any particular task. The general schedule I'm thinking for releasing a game every month is:
- week 1: build out core mechanics with 2 levels
- week 2: build out game with all levels and functionality
- week 3: play test thoroughly each level and fix obvious issues / things with lack of polish
- week 4: prepare for people other than me to play it, continue adding polish

I think polishing a game and tweaking it to improve the player experience is quite crucial, and I don't want to leave that until the last day. Instead, I want to focus on building the core experience as quick as I can, and then going back later on.

# Day 11 - 2021/08/17
I added a very basic options menu that you can access from start menu. I only had about 30 minutes to spare yesterday, so I really just wanted to get anything done - some progress is better than nothing. I saw a poster a few years ago that had:

1.01^365 = 37.8
0.99^365 = 0.03

With that in mind, I've made it a habit to publish at least one commit per day on this project, no matter how small they are. Even with small commits, there are things I'm learning. For example, yesterday I wasn't sure how I can enable/disable the CanvasLayer that I have the CRT texture on. I noticed in the AutoLoad tab in Project Settings that each global node has an Enabled checkbox. I figured this must be a property I can manipulate, but it turns out, this just affects how you can access the node (e.g. `CRT` vs. `get_node("/root/CRT")`).

# Day 12 - 2021/08/18
I added the first powerup to the game: a red apple. Currently, if a ball collides with the apple, the last player to touch it receives one additional health. If no previous player had touched it (e.g. off a serve), no health is rewarded and the apple does not disappear.

I also made a new spawnner, PowerupSpawnner, that will have a list of potential powerups to spawn along with the probability of their occurrence. For now, it just spawns the apple at some regular interval.

I also spent some time thinking about the colour palette. I initally started with the [ZX Spectrum palette](https://lospec.com/palette-list/zx-spectrum). Howeve, many of my sprites are from Kenney's [1-Bit Pack](https://www.kenney.nl/assets/bit-pack), but I'm not sure what colour palette is used for it. It does introduce a few more colours: blue, yellow, green, red, brown, and a maroon. But I would like to unify all the colours in the game with just a single palette. However, one challenge I'm not sure how to solve is how can I test my changes out without manually replacing every colour in the game.

I also thought a bit about what my fifth level should be. I initially thought I would make a boss level as a way to finish the demo. However, I wonder if this is even necessary - instead, perhaps I should just have a regular fifth level. This would be more similar to games like Bubble Bobble, where you would just simply play through all the levels.

# Day 13 - 2021/08/19
I updated the in-game colour palette to use [PICO-8](https://lospec.com/palette-list/pico-8), added a pause menu, and refactored the existing menus to match the pause menu style.

In terms of choosing a colour palette, what I did was:
1. Search on [Lospec](https://lospec.com/palette-list) for all palettes with max 16 colours, sorted by downloads.
2. Hand pick a few palettes that seem promising: for me, these were [PICO-8](https://lospec.com/palette-list/pico-8), [Island Joy](https://lospec.com/palette-list/island-joy-16), [Bubblegum](https://lospec.com/palette-list/bubblegum-16) and [Vanilla Milkshake](https://lospec.com/palette-list/vanilla-milkshake).
3. Open up a screenshot of my game in Aseprite and make a new frame for each palette.
4. For each palette, make a new frame, and replace the 6 or 7 colours in the screenshot with their replacement from palette. This was easy to do by simply clicking Shift + R, and copy-pasting the new value.

Once I had a frame for each palette, I simply went through each of them, compared them, and picked the one that I thought was the best.

As for the pause menu, the reference project I was using had implemented in a slightly different way. I didn't realize this until after I had finished my implementation and was debugging it trying to figure out why it's not working. Here's how my reference project did it:

World (Node)
- Camera
- UI (CanvasLayer)
  - PauseMenu (ColorRect)

When loaded, the World node is then responsible for determing what level should be loaded on the screen. This way, the UI node that contains the PauseMenu is always present as long as a level is loaded. Otherwise, if you're on the StartMenu for example, the UI node and PauseMenu won't be accessible.

The way I implemented it (or I should say, the way I got it working) was by adding a global singleton:

PauseMenu (CanvasLayer)
- ColorRect

Then in PauseMenu.gd, I simply have some logic that determines if the current scene is a level or not: `get_tree().get_nodes_in_group("Player").size() > 0`.

There are some other approaches I could have used:
- Refactor my code to create a generic World node that controls which Levels gets instanced, similar to the reference project
- Instantiate the PauseMenu on each level

But, for now, I just ended up going through with what I got working. It's not the greatest but it's good enough.

# Day 14 - 2021/08/20
I added the fifth level: one where there's a face in the middle that gets red, large, and angry if it hasn't been hit by a ball in a while. I'm not super thrilled with it - I think it might be a bit boring. But I was really struggling yesterday to come up with something that I felt was pretty good that wasn't this. In the end, I decided just to go through with it, and I can always come to it later if needed.

This marks the end of the second week since I've started on this game. As I said before, I won't be adding any more content at this point. I went through my backlog of tasks for this game and re-prioritized each into three categories: must have, should have, or could have. This is all based on a 1-month timeline, so the "must have" tasks should be done by end of week 3, and the "should have" tasks should be done by end of week 4. 

At the moment, most of my "must have" tasks are polish-related: fixing bugs, adding transitions between levels, adding a lose screen, adding a win screen, and so forth.

# Day 15 - 2021/08/21
I had a very productive day yesterday: fixed two bugs, added a "game over" screen, added a "level selection" screen", and added a "face selection" screen.

Everything I implemented is fairly basic - the level selection screen just lists the levels in numeric order. There's no fancy overworld where a character travels to and from different levels such as in Overcooked 2 or Super Hiking League DX. I definitely feel that with a one-month constraint, I don't really have time to explore different ideas since that puts the project at risk of not being complete by the end of the month. That's something I want to keep in mind for future months.

# Day 16 - 2021/08/22
I added some more UI polish: the label that you are currently on in the UI slides, some sound effects to other menus/screens, and updated each player's life bar to match their player colour.

I did quite a lot of playtesting yesterday and I definitely need to reduce the difficulty. I also need to improve the control of the player - getting the player to move to exactly where you want is not ideal. I've gotten used to it by simply tapping the arrow keys lightly but a new player wouldn't know how to do it. I also have to replace a lot debug-only features (e.g. ball always spawns in the top-left corner) with a real feature (e.g. the player who just allowed a goal gets to serve).

# Day 17 - 2021/08/23
I added the concept of a "serve position". Each Player has a Position2D, named ServingPosition. When the game starts, the human player will have the ball spawn at the serving position. When a player allows a goal, they will become the server and the ball will spawn at their serving position.

I did look into adding more control of where the ball goes when it's served but the implementation was a bit too much for me to get done in just a few hours so I decided to go with something simple.

# Day 18 - 2021/08/24
I had a very productive day:
- added two game difficulty modes (easy and hard)
- refactored menus and shared label components
- fixed a few bugs (i.e. AI colour matches human player, level01 always loads when player restarts the game, pause menu's default label doesn't default to "Resume" when opening it)

For the game difficulty modes, the settings that change are the ball speed, max ball speed, and the AI speed. For the hard difficulty, I used values that definitely give me a challenge to win but are still doable. For the easy difficulty, I ramped these down considerably to a level where I think anyone can win. I'll have to some play testing to see if it's possibly too easy.

For refactoring, I noticed I used the exact same label and configuration across all my menus: 7px font with the lace colour. I simply made a new Label node with this configuration and updated all my existing menus to match it.

# Day 19 - 2021/08/25
Yet another productive day. I spent it polishing up the ghost enemy. When I first implemented, it was very barebones - upon collision, it would just disappear. There would be no death effect, no sound effect, and the ball would just bounce off of it as if it were a wall.

I've:
- Added a shadow underneath the ghost
- Added a death and sound effect that plays when the ghost is hit
- Changed the collision mechanic so the ball doesn't bounce off the ghost but instead, it goes through it with some variation in direction and speed

# Day 20 - 2021/08/26
I added a level completion screen. The way I implemented is every time an AI loses all their health, they send a signal that my global Utils.gd listens to. It checks the scene tree and sees if there's any AIs left with health. If not, then it loads the level cleared screen. For future projects, I feel adding more and more to my Utils.gd isn't the best approach. Ideally what I will do is have a generic LevelManager or GameManager that is responsible for loading levels, transitioning between them, and transitioning away from them to "level cleared" screens.

Something I got really lucky with is Godot's RichTextLabel and its capability. I wanted to add a juicy "level cleared" label but thought I might have to write a shader to create a cool, rainbow effect. Fortunately, Godot already has this built-in and they offer a few different options for cool effects: tornado, wave, shake, etc.

# Day 21 - 2021/08/27
I added a crown beside each completed level in the level selection screen. At least this way, the players have some notion of making progress throughout the demo. Ideally I'd like to add some sort of "demo complete" screen once the players have completed all five levels.

I did explore using the RichTextLabel and its effects to replace my regular Label. However, I ran into an issue where whenever I use an effect, it introduces a large space between the label and the node above. I haven't solved it so for now, I'll continue using the regular Label but hopefully for the next project I can switch over to using RichTextLabel for everything since I think the default effects add a lot of juice to the game with not much extra code.

# Day 22 - 2021/08/28
Very productive day with several bug fixes and some polishing:
- Polished the river level by replacing the octopus instancing logic that was contained in level03.gd with the generic enemy spawnner I had built a while back.
- Dixed a bug where pressing the serve button immediately after you lost your last health and there's only 1 other AI left crashes the game. This happened since it would try find another random AI to serve the ball to, but since there's only 1, it would run in a forever loop without finding one.
- Fixed a bug where pressing the pause button immediately after you lost your last health allows you to restart the level without every seeing the game over screen.
- Added a death effect to cars that triggers when they've been stuck for 1 second. This was my solution to the problem I was facing where cars would just pile up on closed nets in level04.

I also spent some time thinking and testing how to make the game easier for players. The first change I made was I reduced the AI's tracking and speed - this should lead to the AI being scored on more often. The second is I increased the default scale of the players in the easy version. Lastly, I changed the collision sprite on human players to be 1px larger in radius than that of the AIs. Hopefully this leads to more players beating the game and overall, a more enjoyable experience.

# Day 23 - 2021/08/29
Not a very productive day - the only thing I added was a "demo cleared" screen when the player finishes all five levels. On days when I spend a lot of time outside (e.g. yesterday I went hiking for a few hours in the morning), I find it incredibly difficult to do anything but relax afterward. I tried my hand at music composition for a bit in the afternoon but didn't make much progress. As the day went on, I kept looking at my to-do list and didn't see anything that I thought I could reasonably finish in a single day.

I eventually settled on something in the evening, but I definitely don't want to repeat this in the future. Next time, I think I'll try to just pick out some "easy/trivial" tasks that I can knock off, so I still maintain my 1 commit per day and I don't feel unproductive.

Even though I studied music as a kid, I haven't done any music composition in over a decade now. As a result, there's quite a learning curve just getting back to it. I don't know if doing a game every month gives me ample time to really practice and learn new things, as opposed to just execute on a game. I definitely feel the shortcomings in my skills so I want to make sure I have time to actually improve them.

# Day 24 - 2021/08/30
Small additions yesterday: added a sound toggle in the options menu and refactored the start menu. I spent a bit more time trying to make a title screen tune using Bosca Ceoil, but no luck there. I've heard good things about LMMS so I'm going to watch a few tutorials on that today and see what I can do.

# Day 25 - 2021/08/31
I spent more time getting up to speed on LMMS and playing around with trying to compose some basic melodies. At this point in the project, I would say it's code complete. There is almost an endless list of features or changes that I should make and could make, but I'm starting to feel a little burnt out on this project.

I haven't written about burn out yet, and it hasn't really affected me until today. I'm pretty much in a "ready to move on" mindset where I'm satisfied with what I've produced in the last few weeks. I know it's far from perfect but I think it's a good first effort at releasing a game. There's tons of decision I made that I probably would do differently if I were to start it again. 

As a result, I've since started writing a retrospective on my learnings over the last month and my general thoughts going forward. I'm not quite sure if I will publish that in this repository or somewhere else.

# Day 26 - 2021/09/01
Spent most of my time exploring Itch.io project requirements and figuring out how to make the content I need for it. The most important one that took the longest was getting good screenshots and GIFs that I could use. I used QuickTime to record about 10 minutes of gameplay and then I trimmed individual sections to about 3 to 4 seconds. I made 3 to 5 GIFs per level and then I went through and highlighted the best ones.

Unfortunately, I didn't realize until I was done that Itch.io requires GIFs to be smaller than 3MB in size. Fortunately, I only had one or two that exceeded this size limit but it's something I should be aware of going forward.

For filling out the project description, I browsed through some recent projects to get an idea of what others write here. For the most, it seems it's just a 2-3 sentence description, controls, and then credits - nothing complex.

# Day 27 - 2021/09/02
Continued setting up the Itch.io project page and uploaded the game. The main issue I faced was that audio wasn't working. After some searching on Google, I was about to find the resolution in the [Godot Engine Q&A](https://godotengine.org/qa/96597/audio-crashes-and-missing-on-exported-project-3-2-3).

Essentially, I had a SoundFX (Node) singleton with:

```gdscript
var cache = {}
func _ready():
	for file in Utils.list_files_in_directory("res://sounds/", ".wav"):
		cache[file] = load(sounds_path + file)
```

Rather than loading at runtime, I load all .wav files when the project is started. However, this doesn't work when the project is exported because:

> When exporting the project, the imported files can no longer be found in their original locations and are instead stored in the .import folder. However, the .import files are still in their original locations. To use Directory to look through a folder in order to find files, you need to look for the .import files instead. Then, remove the .import from the file name, and load the resulting path (the ResourceLoader will automatically account for the moved file).

Indeed in my `Utils.list_files_in_directory` function, I was using `Directory.new()`. So I had to change the above code to the following in order to get it to work:

```gdscript
func _ready():
	for file in Utils.list_files_in_directory(sounds_path, ".wav.import"):
		file = file.rstrip(".import")
		cache[file] = load(sounds_path + file)
```

I also spent quite a bit of time trying to add an audio file to a recorded video (with existing audio). For reference, I had recorded gameplay using QuickTime with BlackHole 2ch. In order to add another audio so that the two audio tracks are combined, I used this ffmpeg command thanks to [StackOverflow]( 
https://stackoverflow.com/questions/11779490/how-to-add-a-new-audio-not-mixing-into-a-video-using-ffmpeg):

`ffmpeg -i trailer.mov -i audio.m4a -filter_complex "[0:a][1:a]amerge=inputs=2[a]" -map 0:v -map "[a]" -c:v copy -ac 2 -shortest trailer-with-audio.mp4`

I made a trailer with music since Itch.io offers a way to add a YouTube or Video video. But once I uploaded it to YouTube and started filling out the information about the video, I realized I needed a good cover shot with 1280x720 resolution. Then I tried to find some good examples of the general structure of what this should look like.

Lastly, I made a few more changes in preparation for releasing the game:
- Updated the colours to match the Itch.io background
- Set default AI difficulty to easy
- Make the AI easy difficulty slightly better (since they were missing some trivial shots at low speeds)

