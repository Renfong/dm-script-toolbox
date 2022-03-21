Image miniSort(Image src){
	number d0 = src.ImageGetDimensionSize(0)
	number d1 = src.ImageGetDimensionSize(1)
	
	Image sorted := src.ImageClone()
	Image dummy := src.ImageClone()
	number mxVal = max(dummy)
	
	for (number y=0; y<d1; y++){
		for (number x=0; x<d0; x++){
			number px, py
			sorted.SetPixel(x,y,min(dummy,px,py))
			dummy.SetPixel(px,py,mxVal)
		}
	}
	
	return sorted
}


Image test := NewImage("Test",2,64,64)
test = GaussianRandom()
Image sorted := minisort(test)
sorted.ShowImage()