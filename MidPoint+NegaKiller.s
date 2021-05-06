// Apply mid-point filter to all slices of the most front image
//   and remove negative point of each slices.
// Renfong 2017/11/15

// sub-function 1 : Midpoint filter to the line
image MidPointFilter(image img, number window)
{
	// Parameter check
	number sx,sy
	GetSize(img,sx,sy)
	
	if (!remainder(window,2))
	{
		result("Window must be odd number. \n")
		exit(0)
	}
	
	// Set range and name
	number hw=(window-1)/2
	image im2=img
	im2.ImageCopyCalibrationFrom(img)
	
	// caculate the midpoint value to the line
	number i
	for (i=hw; i<sx-hw; i++)
	{
		number vmax=max(img[0,i-hw,1,i+hw+1])
		number vmin=min(img[0,i-hw,1,i+hw+1])
		im2.SetPixel(i,0,(vmax+vmin)/2)
	}
	// remove point below 0
	im2=(im2>0)*im2
	return im2
}

// Main program
number window = 3
image front := getfrontimage()
image img
image temp
number sx, sy
getsize(front,sx,sy)
if(sy==1)
{
	string imgname=getname(front)
	imagedisplay profdisp=front.imagegetimagedisplay(0)
	number noslices=profdisp.imagedisplaycountslices()
		
	for(number j=0; j<noslices; j++)
	{
		front{j}=MidPointFilter(front{j}, window)
	}

	front.setname(imgname+"-MPF")
}
else
{
	showalert("Please select 1D profile or spectrum.",0)
	exit(0)
}
	
