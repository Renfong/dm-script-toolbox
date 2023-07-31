Image src := GetFrontImage()
ImageDisplay srcDisp = src.ImageGetImageDisplay(0)
ImageDocument srcDoc = src.ImageGetOrCreateImageDocument()

number ncomp = srcDisp.ComponentCountChildren()

result("=======================\n")
result(src.GetName()+"\n")
result("ncomp : "+ncomp+"\n")
result("=======================\n")
number kLINEPROFILEMARKER = 12
number kSTARTPOINT = 1
number kENDPOINT = 2 
number kWIDTHCONTROL = 16

TagGroup tgComp = NewTagList()
for (number i=0; i<ncomp; i++){
	component marker = srcDisp.ComponentGetChild( i )
	TagGroup tgInfo = NewTagGroup()
	number compType = marker.ComponentGetType()
	if (compType==kLINEPROFILEMARKER){
		number markerID = marker.ComponentGetID()
		number x1, y1, x2, y2, width, dummy
		marker.ComponentGetControlPoint( kSTARTPOINT, x1, y1 )
		marker.ComponentGetControlPoint( kENDPOINT, x2, y2 )
		marker.ComponentGetControlPoint( kWIDTHCONTROL, width, dummy )
		number angle_deg = -1 * atan( (y2 - y1) / (x2 - x1) )* 180/Pi()
		result(" # "+i+" type : "+compType+"\n")
		result("    - ID : "+markerID+"\n")
		result("    - start point : ("+x1+","+y1+")\n")
		result("    -  end  point : ("+x2+","+y2+")\n")
		result("    - width : "+width+"\n")
		result("    - angle : "+angle_deg+"\n")
		
		tgInfo.TagGroupSetTagAsNumber("ID",markerID)
		tgInfo.TagGroupSetTagAsFloatPoint("starting point",x1,y1)
		tgInfo.TagGroupSetTagAsFloatPoint("end point",x2,y2)
		tgInfo.TagGroupSetTagAsFloat("width",width)
		tgInfo.TagGroupSetTagAsFloat("angle",angle_deg)
		
		tgComp.TagGroupInsertTagAsTagGroup( Infinity(), tgInfo)
	}
}
result("=======================\n\n")

//tgComp.TagGroupOpenBrowserWindow(0)
number ntag = tgComp.TagGroupCountTags()
string report = "sn\tAngle(degree)\n"
for(number i=0; i<ntag; i++){
	TagGroup tgInfo
	tgComp.TagGroupGetIndexedTagAsTagGroup(i,tgInfo)
	number markerID
	tgInfo.TagGroupGetTagAsNumber("ID",markerID)
	component marker = srcDoc.ImageDocumentGetComponentByID(markerID)
	result(" # "+i+" \n")
	result("    - ID : "+markerID+"\n")
	number x1, y1, x2, y2, width, dummy
	marker.ComponentGetControlPoint( kSTARTPOINT, x1, y1 )
	marker.ComponentGetControlPoint( kENDPOINT, x2, y2 )
	marker.ComponentGetControlPoint( kWIDTHCONTROL, width, dummy )
	number angle_deg = -1 * atan( (y2 - y1) / (x2 - x1) )* 180/Pi()
	
	result("    - start point : ("+x1+","+y1+")\n")
	result("    -  end  point : ("+x2+","+y2+")\n")
	result("    - width : "+width+"\n")
	result("    - angle : "+angle_deg+"\n")
	
	report += "#"+i+"\t"+angle_deg+"\n"
	string tag = "#"+i+" : "+angle_deg.format("%.2f")
	
	// add anno
	Component text = NewTextAnnotation( 0.5*(x1+x2), 0.5*(y1+y2), tag, 10)
	text.ComponentSetForegroundColor( 1, 0 , 0 )
	text.ComponentSetDrawingMode( 2 )
	srcDisp.ComponentAddChildAtBeginning( text )
	
	Component arrow = NewArrowAnnotation(y1,x1,y2,x2)
	// NewArrowAnnotation( top, left, bottom, right)
	arrow.ComponentSetForegroundColor( 1, 0 , 0 )
	arrow.ComponentSetDrawingMode( 2 )
	srcDisp.ComponentAddChildAtBeginning( arrow )
	
}

result(report)
