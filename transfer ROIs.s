Image src := GetImageDocument(0).ImageDocumentGetImage(0)
ImageDisplay srcDisp = src.ImageGetImageDisplay(0)
number sscale0 = src.ImageGetDimensionScale(0)
number sscale1 = src.ImageGetDimensionScale(1)
number sd0, sd1, sd2
src.ImageGetDimensionSizes(sd0, sd1, sd2)

// image resize to fit source image
Image tgt := GetImageDocument(1).ImageDocumentGetImage(0)
number tscale0 = tgt.ImageGetDimensionScale(0)
number tscale1 = tgt.ImageGetDimensionScale(1)
number td0, td1, td2
tgt.ImageGetDimensionSizes(td0, td1, td2)

if (sd2 != td2){
	OKDialog("z dimension is not matching, finish the process")
	exit(0)
}

number f0 = tscale0/sscale0
number f1 = tscale1/sscale1

Image dst := tgt.ImageClone()
if (sd3>1) {
	ImageResize(dst, 3, td0*f0, td1*f1, td2)
}

else {
	ImageResize(dst_rs, 2, dd0 * f0, dd1 * f1)
}
for (number z=0; z<td2; z++){
	image zimg := tgt.slice2(0,0,z,0,td0,1,1,td1,1).imageClone()
	dst_rs.slice2(0,0,z,0,td0*f0,1,1,td1*f1,1) = warp(zimg, icol/f0, irow/f1)
}
dst.ShowImage()
ImageDisplay dstDisp = dst.ImageGetImageDisplay(0)
dst.SetName(tgt.GetName()+"-resized")
number dd0, dd1, dd2
dst.ImageGetDimensionSizes(dd0, dd1, dd2)

number nr = srcDisp.ImageDisplayGetROIs()
for (number i=0; i<nr; i++){
	ROI cr = srcDisp.ImageDisplayGetROI(i)
	cr.ROIGetLabel((i+1).format("%i"))
	cr.ROISetVolatile(0)
	number t,l,b,r
	cr.ROIGetRectangle(t,l,b,r)
	
	ROI tr = NewROI()
	if (b>dd1-1){
		number length = b-t
		b=dd1,
		t = b-length
	}
	if (r>dd0-1){
		number width = r-l
		r = dd0
		l = r-width
	}
	tr.ROISetRectangle(t,l,b,r)
	tr.ROIGetLabel((i+1).format("%i"))
	tr.ROISetVolatile(0)
	dstDisp.ImageDisplayAddROI(tr)
}
