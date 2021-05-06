// Pushbutton UI template
//
// 2021/04/21
// Renfong

class UI_Functions : object {
	number true, false
	
	UI_Functions(object self) {
		true = 1; false = 0
		result("Obect \"UI_Functions\" ["+self.ScriptObjectGetID()+"] constructed. \n")
	};
	
	~UI_Functions(object self) {
		result("Obect\"UI_Functions\" ["+self.ScriptObjectGetID()+"] deconstructed. \n")
	};
	
	void btn1response(object self) {
		OKdialog("This is a template")
	};
};

class MainUI : UIFrame {
	TagGroup btn1
	object UI_Functions
	number true, false, ver
	MainUI(object self){
		true = 1; false = 0; ver=0.1;
		UI_Functions = alloc(UI_Functions)
		result("Obect \"MainUI\" ["+self.ScriptObjectGetID()+"] constructed. \n")
	};
	
	~MainUI(object self){
		result("Obect \"MainUI\" ["+self.ScriptObjectGetID()+"] deconstructed. \n")
	};
	
	void btn1response (object self) {
		UI_Functions.btn1response()
	};
	
	TagGroup ButtonGroup1(object self) {
		TagGroup box_items
		TagGroup box = DLGCreateBox("Group 1", box_items)
		box.DLGExternalPadding(5,5)
		box.DLGInternalPadding(25,10)
		
		btn1 = DLGCreatePushButton("btn1 name", "btn1response")
		DLGEnabled(btn1, 1)
		DLGIdentifier(btn1, "btn1").DLGFill("X").DLGExternalPadding(0,-1)
		box_items.DLGAddElement(btn1)
		
		return box
	};
	
	void CreateDialog(object self){
		TagGroup position
		position = DLGBuildPositionFromApplication()
		position.TagGroupSetTagAsTagGroup("Width", DLGBuildAutoSize())
		position.TagGroupSetTagAsTagGroup("Height", DLGBuildAutoSize())
		position.TagGroupSetTagAsTagGroup("X", DLGBuildRelativePosition("Inside", 1))
		position.TagGroupSetTagAsTagGroup("Y", DLGBuildRelativePosition("Inside", 1))
		
		TagGroup dialog_items
		TagGroup dialog = DLGCreateDialog("TemplateUI", dialog_items).DLGPosition(position)
		dialog_items.DLGAddElement(self.ButtonGroup1())
		object dialog_frame = self.init(dialog)
		dialog_frame.Display("UIFrame_v"+ver)
		
	};
}

{
	alloc(MainUI).CreateDialog()
}