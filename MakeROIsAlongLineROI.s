// drafting 2022/09/05
// Renfong

number GetLineROIAngle( ROI lineROI ) {
	number sx, sy, ex, ey
	lineROI.ROIGetLine( sx, sy, ex, ey )
	// Note the -1 because DM defined positive y as DOWN in images
	number angle_rad = -1 * atan( (ey - sy) / (ex - sx) )
	//number angle_deg = angle_rad * 180/Pi()
	
	return angle_rad
}

number GetLineROILen( ROI lineROI){
	number sx, sy, ex, ey
	lineROI.ROIGetLine( sx, sy, ex, ey )
	number length = sqrt((ex-sx)**2 + (ey-sy)**2)
	
	return length
}

void CreateROIsAlongLineROI(Image src, ROI lineROI, number RectROISize, number step){
	ImageDisplay srcDisp = src.ImageGetImageDisplay(0)
	number scale = src.ImageGetDimensionScale(0)
	number LineLen = GetLineROILen(lineROI)*scale
	number nR = trunc(LineLen/step)
	result("  Line length : "+LineLen+"\n")
	result("  # of ROI : "+nR+"\n")
	
	number ang = GetLineROIAngle(lineROI)
	result("  Angle : "+ang.format("%.2f")+" radians.\n")
}

// setting
number step = 1		// nm
number ROISize = 2 	// nm

// main script
Image src := GetFrontImage()
ImageDisplay srcDisp = src.ImageGetImageDisplay(0)
number scale = src.ImageGetDimensionScale(0)

number nr = srcDisp.ImageDisplayCountROIs()
result(nr+" ROIs are found.\n")

for (number i=nr-1; i>=0; i--){
	ROI cr = srcDisp.ImageDisplayGetROI(i)
	result("ROI : "+i+"\n")
	result("  IsSelected : "+srcDisp.ImageDisplayIsROISelected(cr)+"\n")
	result("  IsLine : "+cr.ROIIsLine()+"\n")
	if ( srcDisp.ImageDisplayIsROISelected(cr) * cr.ROIIsLine()){
		CreateROIsAlongLineROI(src,cr,ROISize,step)
		
		
	}
	
}