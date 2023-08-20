//Image src := GetFrontImage()
Image src := D
number d0, d1
src.ImageGetDimensionSizes(d0, d1)
number scale = src.ImageGetDimensionScale(0)
string unit = src.ImageGetDimensionUnitString(0)
ImageDisplay srcDisp = src.ImageGetImageDisplay(0)
ROI srcROI = srcDisp.ImageDisplayGetROI(0)
number tp, lf, bm, rt
srcROI.ROIGetRectangle(tp, lf, bm, rt)

// Get the edge feature
number delta = 0.1
Image edge := src.ImageClone()
edge = src[icol-delta, irow] - src[icol+delta, irow]
edge.SetName("edge")
edge.ShowImage()
ImageDisplay edgeDisp = edge.ImageGetImageDisplay(0)

// Crop from ROI
Image crop := edge[tp, lf, bm, rt].ImageClone()
number cd0, cd1
crop.ImageGetDimensionSizes(cd0, cd1)

// Get edge coordinate
Image ptX := RealImage("X",4,cd1)
ptX.ImageSetDimensionScale(0,scale)
ptX.ImageSetDimensionUnitString(0,unit)
Image ptY := RealImage("Y",4,cd1)
ptY.ImageSetDimensionScale(0,scale)
ptY.ImageSetDimensionUnitString(0,unit)
// TagGroup ptList = NewTagList()
for (number i=0; i<cd1; i++){
	Image profile := crop.slice1(0,i,0,0,cd0,1).ImageClone()
	number px, py
	profile.max(px,py)
	px += lf
	py = i+tp
	
	// datatype I : store coordinate in images
	ptX.SetPixel(i,0,px)
	ptY.SetPixel(i,0,py)
	
	/*
	// datatype II : store coordinate in Taggroup
	TagGroup ptCoord=NewTagGroup()
	number idX, idY
	idX = ptCoord.TagGroupCreateNewLabeledTag( "X" )
	ptCoord.TagGroupSetIndexedTagAsLong( idX, px )
	idY = ptCoord.TagGroupCreateNewLabeledTag( "Y" )
	ptCoord.TagGroupSetIndexedTagAsLong( idY, py )
	ptList.TagGroupInsertTagAsTagGroup( infinity(), ptCoord )
	*/
}
/*
ptX.ShowImage()
ptY.ShowImage()
ptList.TagGroupOpenBrowserWindow( 0 )
*/

// mark the edge
void ClearOvalComponent(Image src){
	ImageDisplay srcDisp = src.ImageGetImageDisplay(0)
	number nComp = srcDisp.ComponentCountChildren()
	number OvalType = 6
	for( number i=nComp-1; i>=0; i-- )
	{
		Component comp = srcDisp.ComponentGetChild( i )
		if (comp.ComponentGetType() == OvalType){
			comp.ComponentRemoveFromParent()
		}
	}
}

void EdgeMark(Image src, Image ptX, Image ptY){
	number dx = ptX.ImageGetDimensionSize(0)
	number dy = ptY.ImageGetDimensionSize(0)
	if( dx != dy) Throw("The ptX and ptY dimension must be equal!")
	
	ImageDisplay srcDisp = src.ImageGetImageDisplay(0)
	number mark_r = 1
	number pos_fix = 0.5
	for (number i; i<dx; i++){
		number px = ptX.GetPixel(i,0) + pos_fix
		number py = ptY.GetPixel(i,0) + pos_fix
		Component ovalAnno = NewOvalAnnotation( py-mark_r, px-mark_r, py+mark_r, px+mark_r)
		ovalAnno.ComponentSetForegroundColor( 0.84, 0.70, 0.33 )
		ovalAnno.ComponentSetDrawingMode(2)
		ovalAnno.ComponentSetFillMode(1)
		srcDisp.ComponentAddChildAtEnd(ovalAnno)
	}
}

//ClearOvalComponent(src)
//EdgeMark(src, ptX, ptY)

//=====================================================
// main function
//=====================================================
// Add normal vector
// input parameters
number win = 2		//nm
number Ystep = 2	//nm
number Y0 = 1		//nm
if (Y0*2>win){
	result("=================\n")
	result("Initial at "+Y0+" "+unit+" is out of range,")
	Y0 = trunc(win/2)
	result(" set new initial at "+Y0+" "+unit+".\n")
}

// convert to pixel
number pwin = round(win/scale)
number pYstep = round(Ystep/scale)
number pY0 = round(Y0/scale)
number nstep = trunc((d1-pY0)/pYstep)
result("******************************\n")
result(" window  : "+win+" "+unit+" ("+pwin+"pixels )\n")
result("  step   : "+Ystep+" "+unit+" ("+pYstep+"pixels )\n")
result(" initial : "+Y0+" "+unit+" ("+pY0+"pixel )\n")
result(" Total steps : "+nstep+"\n")
result("******************************\n")

// make a test
number setStep = 40		//nm
number psetStep = round(setStep/scale)
number px = ptX.GetPixel(psetStep,0)
number py = ptY.GetPixel(psetStep,0)
result("position : "+setStep+" "+unit+"\n")
result("(px,py)=("+px+","+py+")\n")

number range0 = psetStep-trunc(pwin/2)
number range1 = range0+pwin

Image LineX = ptY.Slice1(range0,0,0,0,pwin,1).ImageClone()
Image LineY = ptX.Slice1(range0,0,0,0,pwin,1).ImageClone()

number ComputeNormalLineSlope(Image LineX, Image LineY){
	number xmean = LineX.mean()
	number ymean = LineY.mean()
	number m = ((LineX-xmean)*(LineY-ymean)).sum() / ((LineX-xmean)**2).sum()
	m*=-1
	
	return m
}

number m = ComputeNormalLineSlope(LineX, LineY)
number angle = atan(m)*180/pi()
result("m = "+m+"\n")
result("angle = "+angle+"\n")