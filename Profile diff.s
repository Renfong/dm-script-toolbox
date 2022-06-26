image src := GetFrontImage()
number d0, d1
src.ImageGetDimensionSizes(d0, d1)

result("d0 = "+d0+", d1 = "+d1+"\n")

Image profile := src.Slice1(0,50,0,0,d0,1).ImageClone()

image diff1(Image src){
	Image shift1 = src.ImageClone()
	shift1 = src[icol+1,irow]
	
	Image shift2 = src.ImageClone()
	shift2 = src[icol-1,irow]
	
	Image diff := src.ImageClone()
	diff = 0.5*(shift1 - shift2)
	
	return diff
}

diff1(profile).ShowImage()