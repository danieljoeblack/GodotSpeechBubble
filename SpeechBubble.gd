extends Node2D

onready var text_node = $Anchor/RichTextLabel

const char_time = 0.02
const margin_offset = 15
const max_margin = 250

func _ready():
	visible = false
	set_text("This message is long to demonstrate that the label box is restricted in width!")
	
func set_text(text, wait_time=3):
	visible = true
	
	$Timer.wait_time = wait_time
	$Timer.stop()
	
	text_node.bbcode_text = "[center]"+text+"[/center]"
	
	#duration
	var duration = text_node.text.length() * char_time
	
	#set the size of the bubble
	var text_size = text_node.get_font("normal_font").get_string_size(text_node.text)
	
	#width of label, cannot exceed max_margin 
	var target_box_size = clamp(text_size.x + margin_offset,text_size.x + margin_offset,max_margin)
	
	#number of wrapped lines for height calculation
	var lineCount = text_size.x/max_margin
	
	#animation
	$Tween.remove_all()
	$Tween.interpolate_property(text_node,"margin_right",0,target_box_size, duration)
	
	#durations are multiplied to 2 to ensure the width has time to expand
	#before the text appears to prevent wrapping too soon
	$Tween.interpolate_property(text_node,"margin_top",0,-((text_size.y*lineCount)), duration*2)
	$Tween.interpolate_property(text_node, "percent_visible",0,1,duration*2)	
	
	$Tween.interpolate_property($Anchor,'position',Vector2.ZERO, Vector2(-(target_box_size)/2,0),duration)
	$Tween.start()


func _on_Tween_tween_all_completed():
	$Timer.start()
	#pass


func _on_Timer_timeout():
	visible = false
