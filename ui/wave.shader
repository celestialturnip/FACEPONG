// source: https://old.reddit.com/r/godot/comments/9mvg9y/wave_effect_on_richtextlabel/
shader_type canvas_item;

uniform float height = 1.0;
uniform float curve = .05;
uniform float speed = 5.0;

void vertex() {
    VERTEX.y += height*sin(VERTEX.x*curve+TIME*speed);
}