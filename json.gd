extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var data = {}
var itemFields = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass




func _on_OpenButton_pressed():
	$Panel/FileDialog.popup()

func _on_FileDialog_file_selected(path):
	var data_file = File.new()
		
	if data_file.open(path, File.READ) != OK:  # If parse OK
		print("Error: ", data_file.error)
		print("Error Line: ", data_file.error_line)
		print("Error String: ", data_file.error_string)
			
	var data_text = data_file.get_as_text()
	data_file.close()
	var data_parse = JSON.parse(data_text)
	if data_parse.error != OK:
		print("Error: ", data_parse.error)
		print("Error Line: ", data_parse.error_line)
		print("Error String: ", data_parse.error_string)
		return
	data = data_parse.result
	#print("DATA: ")
	#print(data)
	# print(data["hello"])
	for key in data:
		$Panel/ItemList.add_item(key)
	makeFields()

func makeFields():
	#for field in data.first():
	if !data.empty():
		for field in data["Energy Drink"]: 
			# need to not hardcode and read from source of truth file
			var row = HBoxContainer.new()
			var label = Label.new()
			label.valign = Label.VALIGN_CENTER
			label.rect_min_size = Vector2(120, 40)
			row.add_child(label)
			label.text = field
			var edit = LineEdit.new()
			edit.rect_min_size = Vector2(200, 40)
			row.add_child(edit)
			edit.text = ""
			var expand = Button.new()
			expand.name = "ExpandButton"
			#expand.icon = load("res://expand_icon.png")
			expand.rect_min_size = Vector2(40, 40)
			row.add_child(expand)
			expand.connect("pressed", self, "_on_ExpandButton_pressed", [row])
			$Panel/ScrollContainer/Panel.add_child(row)
			itemFields[field] = row

	

func _on_ExpandButton_pressed(row):
	print("expanded")
	var popup = PopupDialog.new()
	popup.rect_min_size = Vector2(500, 400)
#	popup.set_anchor(MARGIN_LEFT, 0.25)
#	popup.set_anchor(MARGIN_RIGHT, 0.75)
#	popup.set_anchor(MARGIN_TOP, 0.25)
#	popup.set_anchor(MARGIN_BOTTOM, 0.75)
	$Panel.add_child(popup)
	popup.popup_centered()
	popup.popup()
	
	var field_text = row.get_child(1).text
	var text_edit = TextEdit.new()
	text_edit.text = field_text
	text_edit.wrap_enabled = true
	text_edit.rect_min_size = Vector2(450, 300)
	popup.add_child(text_edit)
	text_edit.set_anchor_and_margin(MARGIN_LEFT, 0, 25, true)
	text_edit.set_anchor_and_margin(MARGIN_TOP, 0, 25)
	var save = Button.new()
	save.text = "Save"
	save.rect_min_size = Vector2(100, 40)
	var cancel = Button.new()
	cancel.text = "Cancel"
	cancel.rect_min_size = Vector2(100, 40)
	popup.add_child(save)
	popup.add_child(cancel)
	save.set_anchor_and_margin(MARGIN_TOP, 0, 340, false)
	save.set_anchor_and_margin(MARGIN_LEFT, 0, 25, false)
	cancel.set_anchor_and_margin(MARGIN_TOP, 0, 340, false)
	cancel.set_anchor_and_margin(MARGIN_LEFT, 0, 150, false)
	print(row.get_child(1).text)

func _on_ItemList_item_selected(index):
	var item_key = $Panel/ItemList.get_item_text(index)
	var item = data[item_key]
	$Panel/ItemLabel.text = item_key
	for field in item:
		itemFields[field].get_child(1).text = String(item[field])
	
