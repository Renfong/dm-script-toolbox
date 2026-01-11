number fraction = 0.9
number slope_threshold = 0.1 
number shift = 2

Image img := GetFrontImage()
ImageDisplay imgDisp = img.ImageGetImageDisplay(0)

number d0
img.ImageGetDimensionSizes(d0)


Image forward_img := img.offset(shift,0)
forward_img.SetName("Forward")
//forward_img.ShowImage()

Image backward_img := img.offset(-shift,0)
backward_img.SetName("Backward")
//backward_img.ShowImage()

Image slopeL = (img - forward_img)/shift
slopeL.SetName("slopeL")
//slopeL.ShowImage()

Image slopeR = (backward_img - img)/shift
slopeR.SetName("slopeR")
//slopeR.ShowImage()


Image range := img.ImageClone()
range = (((abs(slopeL) < slope_threshold ) || (abs(slopeR) < slope_threshold )) && (img > img.max()* fraction) ) * icol
range.ShowImage()

number ch0, ch1
for (number i=0; i<d0; i++){
	number val = range.GetPixel(i,0)
	if (val != 0) {
		ch0 = val
		break
	}
}
ch1 = range.max()+1

ROI cr = NewROI()
cr.ROISetRange(ch0, ch1)
cr.ROISetVolatile(0)
cr.ROISetColor(0.5,1,0.5)
imgDisp.ImageDisplayAddROI(cr)