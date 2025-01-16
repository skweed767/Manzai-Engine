extends Node2D

signal ManzaiNext

var auto_toggle = false

var character_left 
var character_right 

var character_left_attention = false
var character_right_attention = false

var character_slots = [null,null,null,null,null]
var reading = false

var sheet_texts = {}
var current_sheet

var line 

var file_access

var regex_patterns = {
"PlayBGM": RegEx.new(),
"LoadBGM": RegEx.new(),
"StopBGM": RegEx.new(),
"PlaySE": RegEx.new(),
"MzSetBG": RegEx.new(),
"MzStartDemoDarkness": RegEx.new(),
"MzEffectAll": RegEx.new(),
"MzWaitEffectAll": RegEx.new(),
"MzEnterChr": RegEx.new(),
"MzDeleteChr": RegEx.new(),
"MzExitChr": RegEx.new(),
"MzSetText": RegEx.new(),
"MzWaitText": RegEx.new(),
"MzLoadChr": RegEx.new(),
"Wait": RegEx.new(),
"MzWaitChr": RegEx.new(),
"MzAttentionChr": RegEx.new(),
"SystemAbort": RegEx.new(),
"SetVolumeBGM": RegEx.new(),
}

var character_names = {
0: "Ringo", 
1: "Risukuma", 
2: "Maguro", 
3: "Ringo", 
4: "Ringo", 
5: "Ringo", 
6: "Arle", 
7: "Ringo", 
8: "Ringo", 
9: "Ringo", 
10: "Ringo", 
11: "Ringo", 
12: "Ringo", 
13: "Ringo", 
14: "Ringo", 
15: "Ringo", 
16: "Ringo", 
17: "Tee",
18: "Ringo", 
19: "Ringo", 
20: "Ringo", 
21: "Ringo", 
22: "Ringo", 
23: "Ringo", 
24: "Ringo", 
25: "Ringo", 
26: "Ringo", 
27: "Ringo", 
28: "Ringo", 
29: "Ringo", 
30: "Carbuncle", 
}

var music_files = {
	0: "res://scenes/Loader/PPT/Music/Spaceship.tscn",
	1: "res://scenes/Loader/PPT/Music/Relaxed.tscn",
	2: "res://scenes/Loader/PPT/Music/World.tscn",
	3: "res://scenes/Loader/PPT/Music/Weird.tscn",
	4: "res://scenes/Loader/PPT/Music/Hunkydory.tscn",
	5: "res://scenes/Loader/PPT/Music/Wrong.tscn",
	6: "res://scenes/Loader/PPT/Music/Lonely.tscn",
	7: "res://scenes/Loader/PPT/Music/On.tscn",
	8: "res://scenes/Loader/PPT/Music/Edge.tscn",
	9: "res://scenes/Loader/PPT/Music/Homecoming.tscn",
	10: "pretend the ppt intro is here"
}

var mz_backgrounds = {
1: "res://scenes/Loader/PPT/Backgrounds/nahewoods.tscn",
2: "res://scenes/Loader/PPT/Backgrounds/puzzleleague.tscn",
3: "res://scenes/Loader/PPT/Backgrounds/tetris.tscn",
4: "res://scenes/Loader/PPT/Backgrounds/bigbang.tscn",
5: "res://scenes/Loader/PPT/Backgrounds/party.tscn",
6: "res://scenes/Loader/PPT/Backgrounds/arcade.tscn",
7: "res://scenes/Loader/PPT/Backgrounds/lessonday.tscn",
8: "res://scenes/Loader/PPT/Backgrounds/lessonsunset.tscn",
9: "res://scenes/Loader/PPT/Backgrounds/lessonnight.tscn",
10: "res://scenes/Loader/PPT/Backgrounds/shuttle1.tscn",
11: "res://scenes/Loader/PPT/Backgrounds/shuttle2.tscn",
12: "res://scenes/Loader/PPT/Backgrounds/shuttle3.tscn",
13: "res://scenes/Loader/PPT/Backgrounds/nahewoods.tscn",
14: "res://scenes/Loader/PPT/Backgrounds/nahewoods.tscn",
15: "res://scenes/Loader/PPT/Backgrounds/space.tscn",
16: "res://scenes/Loader/PPT/Backgrounds/edge.tscn",
17: "res://scenes/Loader/PPT/Backgrounds/science.tscn",
18: "res://scenes/Loader/PPT/Backgrounds/academytet.tscn",
19: "res://scenes/Loader/PPT/Backgrounds/puyoswirl.tscn",
20: "res://scenes/Loader/PPT/Backgrounds/school.tscn",
21: "res://scenes/Loader/PPT/Backgrounds/schoolshuttle1.tscn",
22: "res://scenes/Loader/PPT/Backgrounds/nahewoods.tscn",
23: "res://scenes/Loader/PPT/Backgrounds/shuttle4.tscn",
24: "res://scenes/Loader/PPT/Backgrounds/playroom.tscn",
25: "res://scenes/Loader/PPT/Backgrounds/puyobirds.tscn",
26: "res://scenes/Loader/PPT/Backgrounds/schoolshuttle.tscn",
27: "res://scenes/Loader/PPT/Backgrounds/constellation.tscn",
28: "res://scenes/Loader/PPT/Backgrounds/primp.tscn",
29: "res://scenes/Loader/PPT/Backgrounds/primptet.tscn",
30: "res://scenes/Loader/PPT/Backgrounds/primpschool.tscn",
31: "res://scenes/Loader/PPT/Backgrounds/forest.tscn",
32: "res://scenes/Loader/PPT/Backgrounds/memory.tscn",
33: "res://scenes/Loader/PPT/Backgrounds/constellation1.tscn",
34: "res://scenes/Loader/PPT/Backgrounds/power.tscn",
35: "res://scenes/Loader/PPT/Backgrounds/shopping.tscn",
}

var voice_bank = {
0: "res://assets/PPT/Voice/eng/Act 1-1/MZV_01_01_1_000.wav",
1: "res://assets/PPT/Voice/eng/Act 1-1/MZV_01_01_1_001.wav",
2: "res://assets/PPT/Voice/eng/Act 1-1/MZV_01_01_1_002.wav",
3: "res://assets/PPT/Voice/eng/Act 1-1/MZV_01_01_1_003.wav",
4: "res://assets/PPT/Voice/eng/Act 1-1/MZV_01_01_1_004.wav",
5: "res://assets/PPT/Voice/eng/Act 1-1/MZV_01_01_1_005.wav",
6: "res://assets/PPT/Voice/eng/Act 1-1/MZV_01_01_1_006.wav",
7: "res://assets/PPT/Voice/eng/Act 1-1/MZV_01_01_1_007.wav",
8: "res://assets/PPT/Voice/eng/Act 1-1/MZV_01_01_1_008.wav",
9: "res://assets/PPT/Voice/eng/Act 1-1/MZV_01_01_1_009.wav",
10: "res://assets/PPT/Voice/eng/Act 1-1/MZV_01_01_1_010.wav",
11: "res://assets/PPT/Voice/eng/Act 1-1/MZV_01_01_1_011.wav",
12: "res://assets/PPT/Voice/eng/Act 1-1/MZV_01_01_1_012.wav",
13: "res://assets/PPT/Voice/eng/Act 1-1/MZV_01_01_1_013.wav",
14: "res://assets/PPT/Voice/eng/Act 1-1/MZV_01_01_1_014.wav",
15: "res://assets/PPT/Voice/eng/Act 1-1/MZV_01_01_1_015.wav",
16: "res://assets/PPT/Voice/eng/Act 1-1/MZV_01_01_1_016.wav",
17: "res://assets/PPT/Voice/eng/Act 1-1/MZV_01_01_1_017.wav",
18: "res://assets/PPT/Voice/eng/Act 1-1/MZV_01_01_1_018.wav",
19: "res://assets/PPT/Voice/eng/Act 1-1/MZV_01_01_1_019.wav",
20: "res://assets/PPT/Voice/eng/Act 1-1/MZV_01_01_1_020.wav",
21: "res://assets/PPT/Voice/eng/Act 1-1/MZV_01_01_1_021.wav",
22: "res://assets/PPT/Voice/eng/Act 1-1/MZV_01_01_1_022.wav",
23: "res://assets/PPT/Voice/eng/Act 1-1/MZV_01_01_1_023.wav",
24: "res://assets/PPT/Voice/eng/Act 1-1/MZV_01_01_1_024.wav",
25: "res://assets/PPT/Voice/eng/Act 1-1/MZV_01_01_1_025.wav",
26: "res://assets/PPT/Voice/eng/Act 1-1/MZV_01_01_1_026.wav",
27: "res://assets/PPT/Voice/eng/Act 1-1/MZV_01_01_1_027.wav",
28: "res://assets/PPT/Voice/eng/Act 1-1/MZV_01_01_1_028.wav",
29: "res://assets/PPT/Voice/eng/Act 1-1/MZV_01_01_1_029.wav",
30: "res://assets/PPT/Voice/eng/Act 1-1/MZV_01_01_1_030.wav",
31: "res://assets/PPT/Voice/eng/Act 1-1/MZV_01_01_1_031.wav",
32: "res://assets/PPT/Voice/eng/Act 1-1/MZV_01_01_1_032.wav",
33: "res://assets/PPT/Voice/eng/Act 1-1/MZV_01_01_1_033.wav",
34: "res://assets/PPT/Voice/eng/Act 1-1/MZV_01_01_1_034.wav",
35: "res://assets/PPT/Voice/eng/Act 1-1/MZV_01_01_1_035.wav",
36: "res://assets/PPT/Voice/eng/Act 1-1/MZV_01_01_1_036.wav",
}

func _input(event):
	if reading == true and auto_toggle == false and event is InputEventScreenTouch:
		if event.is_pressed():
			ManzaiNext.emit()
			$"Sfx Container/Next".play()

func next_line():
	if reading == true and auto_toggle == false and Input.is_action_just_pressed("ManzaiNext"):
		ManzaiNext.emit()
		$"Sfx Container/Next".play()
 
	match auto_toggle:
		true: 
			if Input.is_action_just_pressed("AutoToggle"):
				auto_toggle = false
			$"Overlay/Buttons/Auto ON/Label".text = "Auto OFF"
		false:
			if Input.is_action_just_pressed("AutoToggle"):
				auto_toggle = true
			$"Overlay/Buttons/Auto ON/Label".text = "Auto ON"

func _ready():
	# Load XML file
	var parser = XMLParser.new()
	var file_parse = parser.open("res://assets/PPT/Text/English/chapter01English.xml")
	if file_parse != OK:
		return
	load_xml_file(parser)

	# Load PSS file
	file_access = FileAccess.open("res://Manzai.pss", FileAccess.READ)
	if file_access == null:
		print("<Error> Unable to access pss file")
		return
	load_pss_file(file_access)

func load_xml_file(parser: XMLParser):
	while parser.read() == OK:
		if parser.get_node_type() == XMLParser.NODE_ELEMENT:
			if parser.get_node_name() == "sheet":
				current_sheet = int(len(sheet_texts))
				sheet_texts[current_sheet] = []
			elif parser.get_node_name() == "text" and current_sheet != null:
				var text_data = parser.get_node_data().rstrip(" \t\r\n")  # Remove whitespace characters from the end
				if text_data != "":  # Check if text_data is not empty after removing trailing whitespace
					sheet_texts[current_sheet].append(text_data)
		elif parser.get_node_type() == XMLParser.NODE_TEXT and current_sheet != null:
			var text_data = parser.get_node_data().rstrip(" \t\r\n")  # Remove whitespace characters from the end
			if text_data != "":  # Check if text_data is not empty after removing trailing whitespace
				sheet_texts[current_sheet].append(text_data)

func load_pss_file(file_access: FileAccess):
	regex_patterns["LoadBGM"].compile("LoadBGM\\s*(\\S+)")
	regex_patterns["PlayBGM"].compile("PlayBGM\\s*(\\S+)\\s*(\\S+)")
	regex_patterns["StopBGM"].compile("StopBGM\\s*(\\S+)\\s*(\\S+)")
	regex_patterns["PlaySE"].compile("PlaySE\\s*(\\d+)|MzPlaySE_loop\\s*(\\d+)")
	regex_patterns["MzSetBG"].compile("MzSetBG\\s*(\\d+)")
	regex_patterns["MzStartDemoDarkness"].compile("MzStartDemoDarkness")
	regex_patterns["MzEffectAll"].compile("MzEffectAll\\s*(\\d+)")
	regex_patterns["MzWaitEffectAll"].compile("MzWaitEffectAll")
	regex_patterns["MzEnterChr"].compile("MzEnterChr\\s*(\\S+)\\s*(\\S+)")
	regex_patterns["MzDeleteChr"].compile("MzDeleteChr\\s*(\\S+)")
	regex_patterns["MzExitChr"].compile("MzExitChr\\s+(\\d+)")
	regex_patterns["MzSetText"].compile("MzSetText\\s*(\\S+)\\s*(\\S+)\\s*(\\S+)\\s*(\\S+)")
	regex_patterns["MzWaitText"].compile("MzWaitText")
	regex_patterns["MzLoadChr"].compile("MzLoadChr\\s*(\\d+)\\s*(\\d+)")
	regex_patterns["Wait"].compile("Wait\\s*(\\d+)")
	regex_patterns["MzWaitChr"].compile("MzWaitChr\\s*(\\d+)")
	regex_patterns["MzAttentionChr"].compile("MzAttentionChr\\s*(\\d+)")
	regex_patterns["SystemAbort"].compile("SystemAbort")
	regex_patterns["SetVolumeBGM"].compile("SetVolumeBGM\\s*(\\d+)\\s*(\\d+)")

	while not file_access.eof_reached():
		var line = file_access.get_line()

# Load Characters
		var mz_load_chr = regex_patterns["MzLoadChr"].search_all(line)
		for match in mz_load_chr:
			var character_id = int(match.get_string(2))
			var character_scene = load("res://scenes/Loader/PPT/Characters/" + character_names[character_id] + ".tscn")
			if character_scene != null:
				var character_node = character_scene.instantiate()  # Use instantiate() instead of instance()
				add_child(character_node) # Add the new Node2D object to the scene
				character_slots.insert(int(match.get_string(1)), character_node) # Insert the character node into the character_slots array

# Enter Character into scene
		var mz_enter_chr = regex_patterns["MzEnterChr"].search_all(line)
		for match in mz_enter_chr:
			var character_slot_index = int(match.get_string(2))
			var character_node = character_slots[character_slot_index]
			# Play the animation on the character node
			var animation_player = character_node.get_node("AnimationPlayer")
			if animation_player != null:
				match int(match.get_string(1)):
					0:
						await get_tree().create_timer(0.3).timeout
						animation_player.play("Enter (Right)")  
						character_right = character_node.get_node("AnimationPlayer")
					1:
						await get_tree().create_timer(0.3).timeout
						animation_player.play("Enter (Left)")  
						character_left = character_node.get_node("AnimationPlayer")

# Exit Character from scene
		var mz_exit_chr: RegExMatch = regex_patterns["MzExitChr"].search(line)
		if mz_exit_chr != null:
			match int(mz_exit_chr.strings[0]):
				0:
					await get_tree().create_timer(0.3).timeout
					character_right.play_backwards("Enter (Right)")
				1:
					await get_tree().create_timer(0.3).timeout
					character_left.play_backwards("Enter (Left)")
				2:
					await get_tree().create_timer(0.3).timeout
					character_left.play_backwards("Enter (Left)")
					character_right.play_backwards("Enter (Right)")

		# Manzai Delete Character
		var mz_delete_chr: RegExMatch = regex_patterns["MzDeleteChr"].search(line)
		if mz_delete_chr != null:
			var character_id = int(mz_delete_chr.strings[1])
			if character_id < character_slots.size():  # Check if character_id is a valid index
				var node = character_slots[character_id]
				if node != null:
					remove_child(node)  # Remove the character node from the scene
					character_slots.erase(node)  # Remove the character node from the character_slots array

		# Manzai Wait Character
		var mz_wait_chr: RegExMatch = regex_patterns["MzWaitChr"].search(line)
		if mz_wait_chr != null:
			match int(mz_wait_chr.strings[0]):
				0:
					if character_right.is_playing():
						await character_right.animation_finished
				1: 
					if character_left.is_playing():
						await character_left.animation_finished
				2:
					if character_right.is_playing():
						await character_right.animation_finished 
						await character_left.animation_finished 

		"""
		# Manzai Attention Character
		var mz_attention_chr = regex_patterns["MzAttentionChr"].search_all(line)
		for match in mz_attention_chr:
			match int(match.get_string(0)):
				0:
					if character_left_attention == true:
						character_left.play_backwards("Attention")
						character_left_attention = false
					print("Right")
					if character_right_attention == false:
						character_right.queue("Attention")
						character_right_attention = true
				1: 
					if character_right_attention == true:
						character_right.play_backwards("Attention")
						character_right_attention = false
					print("Left")
					if character_left_attention == false:
						character_left.queue("Attention")
						character_left_attention = true
				2:
					if character_left_attention == false:
						character_left.queue("Attention")
						character_left_attention = true
					print("Both")
					if character_right_attention == false:
						character_right.queue("Attention")
						character_right_attention = true
		"""

# Set Manzai Background
		var mz_set_bg = regex_patterns["MzSetBG"].search_all(line)
		for match in mz_set_bg:
			$Background.add_child(load(mz_backgrounds[int(match.get_string(1))]).instantiate())

			# Start manzai on a black screen
		var demo_darkness = regex_patterns["MzStartDemoDarkness"].search_all(line)
		for match in demo_darkness:
			$Background/StartDemoDarkness.show() 

			# I added this command because I'm stupid
		var system_abort = regex_patterns["SystemAbort"].search_all(line)
		for match in system_abort:
			await get_tree().create_timer(INF).timeout

			# I added this command because I'm stupid
		var set_volume_bgm = regex_patterns["SetVolumeBGM"].search_all(line)
		for match in set_volume_bgm:
			var volume = (int(match.get_string(2)) - 60)  
			match int(match.get_string(1)):
				0:
					$"Music Container"/Spaceship.volume_db = volume
				1:
					$"Music Container"/Relaxed.volume_db = volume
				2:
					$"Music Container"/World.volume_db = volume
				3:
					$"Music Container"/Weird.volume_db = volume
				4:
					$"Music Container"/Hunkydory.volume_db = volume
				5:
					$"Music Container"/Wrong.volume_db = volume
				6:
					$"Music Container"/Lonely.volume_db = volume
				7:
					$"Music Container"/On.volume_db = volume
				8:
					$"Music Container"/Edge.volume_db = volume
				9:
					$"Music Container"/Homecoming.volume_db = volume

# Manzai Scene Effect
		var mz_effect_all = regex_patterns["MzEffectAll"].search_all(line)
		for match in mz_effect_all:
			if int(match.get_string(1)) != -1:
				match int(match.get_string(1)):
					0:
						pass
					1: 
						$Background/StartDemoDarkness/Fade.play_backwards("fade out")
					2:
						$Background/StartDemoDarkness/Fade.play("fade out")
					3:
						$Background/StartDemoDarkness/Fade.play_backwards("fade out white")
					4:
						$Background/StartDemoDarkness/Fade.play("fade out white")

# Manzai Scene Effect
		var mz_wait_effect_all = regex_patterns["MzEffectAll"].search_all(line)
		for match in mz_wait_effect_all:
			if not $Background/StartDemoDarkness/Fade.animation_finished:
				await $Background/StartDemoDarkness/Fade.animation_finished

		# Load Manzai Music
		var load_bgm = regex_patterns["LoadBGM"].search_all(line)
		for match in load_bgm:
			var load_music = int(match.get_string(1))
			$"Music Container".add_child(load(music_files[load_music]).instantiate())

		var mz_play_se: RegExMatch = regex_patterns["PlaySE"].search(line)
		if mz_play_se != null:
			match int(mz_play_se.strings[0]):
				0:
					$"Sfx Container/Alarm".play()
				1:
					$"Sfx Container/Explode".play()
				2:
					$"Sfx Container/Fall".play()
				3:
					$"Sfx Container/Horror".play()
				4:
					$"Sfx Container/Punch".play()
				5:
					$"Sfx Container/Happy".play()
				6:
					$"Sfx Container/Slap".play()

			# Play Manzai Music
		var mz_bgm = regex_patterns["PlayBGM"].search_all(line)
		for match in mz_bgm:
			match int(match.get_string(1)):
				0:
					$"Music Container"/Spaceship.play()
				1: 
					$"Music Container"/Relaxed.play()
				2: 
					$"Music Container"/World.play()
				3: 
					$"Music Container"/Weird.play()
				4:
					$"Music Container"/Hunkydory.play()
				5: 
					$"Music Container"/Wrong.play()
				6:
					$"Music Container"/Lonely.play()
				7:
					$"Music Container"/On.play()
				8:
					$"Music Container"/Edge.play()
				9:
					$"Music Container"/Homecoming.play()

			# Stop Manzai Music
		var mz_stop_bgm: RegExMatch = regex_patterns["StopBGM"].search(line)
		if mz_stop_bgm != null:
			match int(mz_stop_bgm.strings[1]):
				0:
					$"Music Container"/Spaceship.stop()
				1: 
					$"Music Container"/Relaxed.stop()
				2: 
					$"Music Container"/World.stop()

# Wait function 
		var mz_wait: RegExMatch = regex_patterns["Wait"].search(line)
		if mz_wait != null:
			var wait_time = int(mz_wait.strings[1]) / 1000
			await get_tree().create_timer(wait_time).timeout

		var mz_set_text = regex_patterns["MzSetText"].search_all(line)
		for match in mz_set_text:
			reading = true
			var sheet_index = int(match.get_string(1))
			var text_line = int(match.get_string(2))
			var speaker_dir = int(match.get_string(3))
			var speech_bubble = int(match.get_string(4))

			if character_left != null:
				if not character_left.animation_finished:
					await character_left.animation_finished
			if character_right != null:
				if not character_right.animation_finished:
					await character_right.animation_finished

			match speaker_dir:
				0:
					$"Speech bubble/Bubble".flip_h = false
					if character_right != null:
						match character_right.get_parent().name:
							'ringo':
								$Text.add_theme_color_override("font_color", "ed5786")
							'risukuma':
								$Text.add_theme_color_override("font_color", "db6152")
							'maguro':
								$Text.add_theme_color_override("font_color", "805cb6")
							'arle':
								$Text.add_theme_color_override("font_color", "3d5b96")
							'tee':
								$Text.add_theme_color_override("font_color", "805cb6")
							'carbuncle':
								$Text.add_theme_color_override("font_color", "db6152")

				1:
					$"Speech bubble/Bubble".flip_h = true
					if character_left != null:
						match character_left.get_parent().name:
							'ringo':
								$Text.add_theme_color_override("font_color", "ed5786")
							'risukuma':
								$Text.add_theme_color_override("font_color", "db6152")
							'maguro':
								$Text.add_theme_color_override("font_color", "805cb6")
							'arle':
								$Text.add_theme_color_override("font_color", "3d5b96")
							'tee':
								$Text.add_theme_color_override("font_color", "805cb6")
							'carbuncle':
								$Text.add_theme_color_override("font_color", "db6152")


			match speech_bubble:
				0:
					$"Speech bubble/Bubble".region_rect = Rect2(0, 700, 1128, 338,)
					$"Speech bubble".show()
					$"Speech bubble/AnimationPlayer".play("Bubble")
					await $"Speech bubble/AnimationPlayer".animation_finished
				1: 
					$"Speech bubble/Bubble".region_rect = Rect2(0, 700, 1128, 338,)
					$"Speech bubble".show()
					$"Speech bubble/AnimationPlayer".play("Bubble")
					await $"Speech bubble/AnimationPlayer".animation_finished
				2: 
					$"Speech bubble/Bubble".region_rect = Rect2(0, 700, 1128, 338,)
					$"Speech bubble".show()
					$"Speech bubble/AnimationPlayer".play("Bubble")
					await $"Speech bubble/AnimationPlayer".animation_finished
				3: 
					$"Speech bubble/Bubble".region_rect = Rect2(0, 700, 1128, 338,)
					$"Speech bubble".show()
					$"Speech bubble/AnimationPlayer".play("Bubble")
					await $"Speech bubble/AnimationPlayer".animation_finished
				4: 
					$"Speech bubble/Bubble".region_rect = Rect2(0, 700, 1128, 338,)
					$"Speech bubble".show()
					$"Speech bubble/AnimationPlayer".play("Bubble")
					await $"Speech bubble/AnimationPlayer".animation_finished
				5: 
					$"Speech bubble/Bubble".region_rect = Rect2(0, 700, 1128, 338,)
					$"Speech bubble".show()
					$"Speech bubble/AnimationPlayer".play("Bubble")
					await $"Speech bubble/AnimationPlayer".animation_finished
				6: 
					$"Speech bubble/Bubble".region_rect = Rect2(0, 700, 1128, 338,)
					$"Speech bubble".show()
					$"Speech bubble/AnimationPlayer".play("Bubble")
					await $"Speech bubble/AnimationPlayer".animation_finished
				7: 
					$"Speech bubble/Bubble".region_rect = Rect2(0, 700, 1128, 338,)
					$"Speech bubble".show()
					$"Speech bubble/AnimationPlayer".play("Bubble")
					await $"Speech bubble/AnimationPlayer".animation_finished
				8: 
					$"Speech bubble/Bubble".region_rect = Rect2(0, 700, 1128, 338,)
					$"Speech bubble".show()
					$"Speech bubble/AnimationPlayer".play("Bubble")
					await $"Speech bubble/AnimationPlayer".animation_finished
				9: 
					$"Speech bubble/Bubble".region_rect = Rect2(0, 700, 1128, 338,)
					$"Speech bubble".show()
					$"Speech bubble/AnimationPlayer".play("Bubble")
					await $"Speech bubble/AnimationPlayer".animation_finished

			if text_line < sheet_texts[sheet_index].size():
				$Text.show()
				$Text.text = sheet_texts[sheet_index][text_line]
				if text_line in voice_bank:
					$AudioStreamPlayer.stream = load(voice_bank[text_line])
					$AudioStreamPlayer.play()
				$Text/AnimationPlayer.play('Speech')
				print($AudioStreamPlayer.stream.get_length())
				$Text/AnimationPlayer.speed_scale == $AudioStreamPlayer.stream.get_length() 
				print('next line')
				await get_tree().create_timer(0.1).timeout

		# Manzai Text
		var mz_wait_text = regex_patterns["MzWaitText"].search_all(line)
		for match in mz_wait_text:
			if auto_toggle == false:
				await ManzaiNext
				await get_tree().create_timer(0.250).timeout 
			if auto_toggle == true:
				await $Text/AnimationPlayer.animation_finished
				await get_tree().create_timer(1).timeout 

			reading = false
			$Text.text = ""
			$"Speech bubble/AnimationPlayer".play_backwards("Bubble")

func _process(delta: float) -> void:
	next_line()
