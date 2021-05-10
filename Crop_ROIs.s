Image src := GetFrontImage()
number sx, sy, sz
src.Get3DSize(sx,sy,sz)

ImageDisplay disp = src.ImageGetImageDisplay(0)
number nroi = disp.ImageDisplayCountROIs()
for(number i=0; i<nroi; i++){
	roi c_roi = disp.ImageDisplayGetROI(i)
	//c_roi.ROISetLabel("Extract "+(i+1))
	c_roi.ROISetVolatile(0)
	
	number t, l, b, r 
	c_roi.ROIGetRectangle( t, l, b, r )
	number X1
	image cropped := src.slice3(l,t,0,0,(r-l),1,1,(b-t),1,2,sz,1).ImageClone()
	cropped.ShowImage()

	cropped.SetName(src.GetName()+"-Extract "+(i+1))
};
