// Interactive UI template
//
// 2021/05/06
// Renfong

interface call_functions{
	number GetBoxNumber(object self);
};

class UI_Functions : object {
	number true, false
	number UIObjectID
	object MainUI
	
	void SetUIObjectID(object self, number id) {
		UIObjectID = id
		MainUI = GetScriptObjectFromID(UIObjectID)
	};
	
	UI_Functions(object self) {
		true = 1; false = 0
		result("Obect \"UI_Functions\" ["+self.ScriptObjectGetID()+"] constructed. \n")
	};
	
	~UI_Functions(object self) {
		true = 1; false = 0
		result("Obect\"UI_Functions\" ["+self.ScriptObjectGetID()+"] deconstructed. \n")
	};
	
	void btn1response(object self) {
		number num = MainUI.GetBoxNumber()
		OKdialog("Number = "+num)
		
	};
};

class MainUI : UIFrame {
	TagGroup btn1, numbox
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
	
	TagGroup ButtonGroup1(object self) {
		TagGroup box_items, labels
		TagGroup box = DLGCreateBox("Box 1", box_items)
		box.DLGExternalPadding(5,5)
		box.DLGInternalPadding(25,10)
		
		labels = DLGCreateLabel("Give a number : ").DLGAnchor("West")
		numbox = DLGCreateIntegerField(3,5).DLGAnchor("West")
		TagGroup group1 = DLGGroupItems(labels, numbox)
		group1.DLGTableLayout(2,1,0)
		box_items.DLGAddElement(group1)
		
		btn1 = DLGCreatePushButton("btn1 name", "btn1response")
		DLGEnabled(btn1, 1)
		DLGIdentifier(btn1, "btn1").DLGFill("X").DLGExternalPadding(0,-1)
		box_items.DLGAddElement(btn1)
		
		return box
	};
	
	number GetBoxNumber(object self){
		number num = DLGGetValue(numbox)
		return num
	};
	
	void btn1response (object self) {
		UI_Functions.btn1response()
		result(self.GetBoxNumber()+" in the box.\n")
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
		
		UI_Functions.SetUIObjectID(self.ScriptObjectGetID())
	};
	
}

{
	alloc(MainUI).CreateDialog()
}