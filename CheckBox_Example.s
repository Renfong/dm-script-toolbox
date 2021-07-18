// An example shows the checkbox function
// If the checkbox change the status, the function will be changed.
//
// Renfong
// 2021/07/18

class TestUI : UIFrame {
	number true, false
	TagGroup para1, para2

	TestUI(object self)	{
		true = 1; 
		false = 0;
		result("[TestUI] constructed\n")
	};
	
	~TestUI(object self)	{
		result("[TestUI] destructed\n")
	};
	
	void SelectionAct(object self, TagGroup tgItem)	{
		// To change the status while the checkbox is changing.
		self.SetElementIsEnabled("BtnGroup",tgItem.DLGGetValue())
	};
	
	void BtnResponse(object self)	{
		result("Parameter 1 : "+para1.DLGGetValue()+"\n")
		result("Parameter 2 : "+para2.DLGGetValue()+"\n")
	};
	
	void CreateDialog(object self)	{
		
		// the box is not selected when initiation 
		// To enable/disable the entry by building "SelectionAct" function
		TagGroup cb = DLGCreateCheckbox("IsCheck",false,"SelectionAct").DLGAnchor("West")
		
		TagGroup entry1 = DLGCreateRealField("Parameter 1 : ",para1,5,5,3)
		TagGroup entry2 = DLGCreateRealField("Parameter 2 : ",para2,6,5,3)
		
		// print the value
		TagGroup Btn = DLGCreatePushButton("Print","BtnResponse").DLGFill("X").DLGIdentifier("btn")
		
		// Group the entries and button, we can change their status with ease.
		TagGroup EntryGroup = DLGGroupItems(entry1,entry2).DLGTableLayout(2,1,0).DLGIdentifier("entries")
		TagGroup BtnGroup = DLGGroupItems(EntryGroup,Btn).DLGTableLayout(1,2,0).DLGIdentifier("BtnGroup")
		
		// disable the entries and btn when initiation
		DLGEnabled(BtnGroup,false)
		
		// create dialog
		TagGroup dialog = DLGCreateDialog("Test")
		dialog.DLGAddElement(cb)
		dialog.DLGAddElement(BtnGroup)
		
		self.init(dialog).Display("TestUI")
	};
};

{
	alloc(TestUI).CreateDialog()
}