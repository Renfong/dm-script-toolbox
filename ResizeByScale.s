Image ResizeByScale(Image src, number newScale){
	// ref:
	// https://stackoverflow.com/questions/47703685/how-to-resize-an-image-by-dm-scripting
	
	number d0, d1, scale
	src.ImageGetDimensionSizes(d0, d1)
	if (d1 != 1) Throw("For 1 dimension image only.")
	scale = src.ImageGetDimensionScale(0)
	
	number f = Scale/newscale
	Image dst := src.ImageClone()
	
	ImageResize( dst, 2, d0*f, d1)
	dst = warp(src, icol/f, irow)
	dst.ImageSetDimensionScale(0, newScale)
	dst.ImageSetDimensionUnitString(0, src.ImageGetDimensionUnitString(0))
	
	return dst
}

image src := GetFrontImage()
ResizeByScale(src, 0.01).ShowImage()