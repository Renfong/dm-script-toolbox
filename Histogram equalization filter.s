// Histogram equalization filter
//
// Enhance image contrast by re-distribution of gray 
//   level values uniformly.
//
// This script is modified from the matlab version as shown in the below website
// http://angeljohnsy.blogspot.com/2011/04/matlab-code-histogram-equalization.html
//
//
// Renfong 2016/12/6
// windless99@gmail.com


//////////////////////////////////////////////////////////////
// Start processing
//////////////////////////////////////////////////////////////
Image HistEq( image img, number nbins)
{
	number sx, sy
	img.GetSize(sx,sy)

	// Set intensity from 0 to nbins-1
	number ma, mi
	ma=max(img)
	mi=min(img)
	img=round((nbins-1)*(img-mi)/(ma-mi))

	image freq = IntegerImage("",4,0,nbins,1)
	image cum = IntegerImage("",4,0,nbins,1)

	// calculate the histogram (frequency distribution)
	ImageCalculateHistogram(img,freq,0,0,nbins-1)
	/*
	// for loop version
	For (number i=0; i<nbins; i++)
		{
		number Qint = sum(tert(img==i,1,0))
		freq.SetPixel(i,0,Qint)
		}
	*/

	// convert histogram into Cumulative frequency distribution
	number total=0
	For (number i=0 ; i<nbins; i++)
		{
		total=total+freq.GetPixel(i,0)
		cum.SetPixel(i,0,total)
		}

	// Filtered image
	image HE = img*0				// creat a new image with the same size of input image
	For (number i=0; i<nbins; i++)
		{
		image fimg=tert(img==i,1,0)*cum.GetPixel(i,0)
		HE=HE+fimg
		}
	//HE=HE*(ma-mi)/(nbins-1)+mi
	return HE
}

///////////////////////////////////////////////////////////
//Processing
///////////////////////////////////////////////////////////

// Input parameter
image img := GetFrontImage()	// input image
number nbins = 256
image HE_img
HE_img = HistEq( img, nbins)

String str=img.GetName()
HE_img.ImageCopyCalibrationFrom(img)
He_img.SetName(str + "_HE filtered")
HE_img.showimage()