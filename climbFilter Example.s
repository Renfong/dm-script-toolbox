Image ApplyClimbFilter(Image src){
	Image dst := src.ImageClone()
	number d0 = src.ImageGetDimensionSize(0)

	for (number i=0; i<d0; i++){
		Image dummy := src.ImageClone()
		dummy = src[icol-i,irow]
		// Image dummy := img.offset(-1*i,0)
		dst = dummy>dst ? dummy : dst
	}

	return dst
}

Image GenerateCurve(){
	Image img := RealImage("Curve",4,512)

	img = 5*exp(-1*(icol-120)**2/(2*pi()*12**2))
	//img += 10/(1+exp(-1*(icol-180)/20))
	img += 10*exp(-1*(icol-180)**2/(2*pi()*12**2))
	img += 0.25*(random())
	result("done\n")
	return img
}

Image src := GenerateCurve()
src.ShowImage()
ImageDisplay srcDisp = src.ImageGetImageDisplay(0)
Object sid = srcDisp.ImageDisplayGetSliceIdByIndex(0)
srcDisp.ImageDisplaySetSliceLabelByID(sid,"Curve")
Image filtered := ApplyClimbFilter(src)
srcDisp.ImageDisplayAddImage(filtered,"ClimbFilter")
srcDisp.LinePlotImageDisplaySetLegendShown(1)