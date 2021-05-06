// Apply Negative_killer filter to all slices of the most front image
//   and remove negative point of each slices.
// Modify from MidPointFilter_batch.s
//
// Renfong 2018/06/22

// sub-function 1 : NegativeKiller filter to the line
image NegativeKiller(image img)
{
	// Parameter check
	number sx,sy
	GetSize(img,sx,sy)

	// Set range and name
	image im2=img
	im2=(img>0)*img
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
		front{j}=NegativeKiller(front{j})
	}

	front.setname(imgname)
}
else
{
	showalert("Please select 1D profile or spectrum.",0)
	exit(0)
}
	
