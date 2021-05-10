image src := GetFrontImage()
number sx, sy, sz
src.Get3DSize(sx,sy,sz)

ImageDisplay disp = src.ImageGetImageDisplay(0)
number nroi = 3
number sep=round(min(sx,sy)/12)
number rx = 20
number ry = 8
for(number i=0; i<nroi ; i++){
	roi c_roi = NewROI()
	number rx0 = 10 + sep*(nroi-i)
	number ry0 = 10 + sep*(nroi-i)
	c_roi.ROISetRectangle(ry0, rx0, ry0+ry, rx0+rx)
	c_roi.ROISetLabel("Extract "+(nroi-i))
	disp.ImageDisplayAddROI( c_roi )
};
