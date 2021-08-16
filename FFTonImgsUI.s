class FFTonImgsUI:UIFrame	{
	// todo: line 75
	// Renfong @ TSMC
	// 2021/08/17
	
	number true, false
	number ver
	TagGroup tgScale, tgPos
	
	FFTonImgsUI(object self)	{
		ver=1.0
		true=1; false=0;
		result( "'FFTonImgsUI' [obj ID: "+self.ScriptObjectGetID().hex()+"] constructed.\n");
	};
	
	~FFTonImgsUI(object self)	{
		result( "'FFTonImgsUI' [obj ID: "+self.ScriptObjectGetID().hex()+"] destructed.\n");
	};
	
	image MosianFFT(object self, image img) {
		// the main scirpt is written by Vincent Hou
		number rows, cols;
		number cx, cy;							// center coordinates of FFT
		img.GetSize( cols, rows );				// get image size
		cx = floor(cols/2); cy = floor(rows/2);		// get center coordinates
		// computee boundary conditions
		image imgBound := exprsize( cols, rows, 0.0 );
		imgBound[0, 0, rows, 1] = img[0, cols-1, rows, cols] - img[0, 0, rows, 1];
		imgBound[0, cols-1, rows, cols] = -imgBound[0, 0, rows, 1];
		imgBound[0, 0, 1, cols] += img[rows-1, 0, rows, cols] - img[0, 0, 1, cols];
		imgBound[rows-1, 0, rows, cols] += img[0, 0, 1, cols] - img[rows-1, 0, rows, cols];
		// Generate smooth component from Poisson Eq with boundary condition
		image imgD := exprsize( cols, rows, 2*cos( 2*Pi()*(icol-cx)/cols ) + 2*cos( 2*Pi()*(irow-cy)/rows ) - 4 );
		ComplexImage imgS_FFT := imgBound.RealFFT()/imgD;
		imgS_FFT.SetPixel(cx, cy, complex(0, 0) ); 	// enforce zero mean
		// calculate FFT of periodic component
		image imgP_FFT := img.RealFFT();
		imgP_FFT -= imgS_FFT;
		imgP_FFT.SetName( "Mosian FFT of " + img.GetName() );
		
		return imgP_FFT;
	};

	void FFTonSrcImg(object self, image img, number scale, number position)	{
		// the main scirpt is written by BmyGuest
		// renfong modified.
		number sx, sy
		img.GetSize(sx, sy)
		image mfft := self.MosianFFT(img)
		
		// Adding fft onto parent, it will be 0/0 aligned
		imageDisplay parentDisp = img.ImageGetImageDisplay(0)
		imageDisplay childDisp = mfft.NewImageDisplay("best")
		parentDisp.ComponentAddChildAtEnd(childDisp)
		
		// Scale and position componets on their parents.
		number offsetX, offsetY
		number sep=0.01
		if(position==1) {offsetX=sep*sx; offsetY=sep*sy;};	//top left
		if(position==2) {offsetX=(1-scale-sep)*sx; offsetY=sep*sy;};	//top right
		if(position==3) {offsetX=sep*sx; offsetY=(1-scale-sep)*sy;};	//bottom lef
		if(position==4) {offsetX=(1-scale-sep)*sx; offsetY=(1-scale-sep)*sy;};	//bottom right
		result(offsetX+"-"+offsetY+"\n")
		childDisp.ComponentTransformCoordinates(offsetX,offsetY,scale,scale)
	};
	
	void btn1Response(object self)	{
		number scale = tgScale.DLGGetValue()
		if (scale>1) scale=0.5
		number position = tgPos.DLGGetValue()
		image scr:=GetFrontImage()
		
		if(OptionDown())	{
			// failed
			// need to modify to imagedocument
			while(src.ImageIsValid()){
				self.FFTonSrcImg(scr,scale,position)
				src:=FindNextImage(src)
			};
		}
		else self.FFTonSrcImg(scr,scale,position)
	};
	
	void MakeUI(object self)	{
		TagGroup tgBox
		TagGroup box = DLGCreateBox("FFT on Image", tgBox)
		box.DLGExternalPadding(5,5)
		box.DLGInternalPadding(25,10)
		box.DLGAddElement(DLGCreateRealField("Scale : ", tgScale,0.4,8,3))
		
		tgPos = DLGCreateRadioList(1)
		tgPos.DLGAddRadioItem("Top left",1)
		tgPos.DLGAddRadioItem("Top right",2)
		tgPos.DLGAddRadioItem("Bottom left",3)
		tgPos.DLGAddRadioItem("Bottom right",4)
		box.DLGAddElement(tgPos)
		
		TagGroup MainUI = DLGCreateDialog("FFT on Imgs")
		MainUI.DLGAddElement(box)
		TagGroup Btn = DLGCreatePushButton("Go","btn1Response").DLGFill("X")
		MainUI.DLGAddElement(Btn)
		
		self.init(MainUI).Display("FFT on Imgs v."+ver.format("%.1f"))
		
	};
};

{
		alloc(FFTonImgsUI).MakeUI()
};