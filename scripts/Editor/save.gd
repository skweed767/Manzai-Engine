extends Node

func save():
	var vbox_nodes = $"../ScrollContainer/VBoxContainer".get_children()
	var manzaiData = ""
	for text_node in vbox_nodes:
		manzaiData += text_node.text + "	"
	
	var beginningData = "\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r: main"
	var endingData = "\r\r\r;\r"
	var save_dict = str(beginningData,manzaiData,endingData)
	return save_dict

func save_game():    
	var game_file = FileAccess.open("res://Manzai.pss", FileAccess.WRITE)
	var ManzaiComplete = save()
	game_file.store_line(ManzaiComplete)
	print(ManzaiComplete)

func _on_pressed() -> void:
	save_game()

func _on_mz_wait_chr_pressed() -> void:
	var label = Label.new()
	label.text = '\rMzWaitText'
	$"../ScrollContainer/VBoxContainer".add_child(label)

func _on_mz_set_bg_pressed() -> void:
	var label = Label.new()
	label.text = '\rMzSetBG'
	
	var option = OptionButton.new()
	option.text = '\rMzSetBG'
	option.add_item("1",1)
	option.add_item("2",1)
	option.item_count = 2
	option.selected = 1
	$"../ScrollContainer/VBoxContainer".add_child(label)
	$"../ScrollContainer/VBoxContainer".add_child(option)
