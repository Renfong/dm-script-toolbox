// Lattice enhanced filter
// Reference : Ondrej L. Krivanek et. al., Nature 464, 571-574
//
//	Version 3
//	The filter enhance the lattice feature without removing background.
//	Set the weight factor in the background and high frequency region  = 1
//	And the weight factor of the enhanced feature  = 3.5
//	
//	The first window will show the radial average of the FFT of the image
//	enhanced feature (look for the peak) then key the value into the window
//
// 2021/03/17
// Renfong
// windless@gmail.com



// sub-function1 : radial average
// This script is retrived and  modified from 
// http://www.gatan.com/sites/default/files/Scripts/Rotational%20Average.s


image Rotational_Average(image img)	{
	// Define neccessary parameters and constants
	number xscale, yscale, xsize, ysize
	number centerx, centery, halfMinor
	number scale = img.ImageGetDimensionScale(0)
	string unit = img.ImageGetDimensionUnitString(0)

	// Likewise, declare intermediate images
	image rotational_average, dst, line_projection

	// If the source image is complex, take the modulus						
	if ( img.ImageIsDataTypeComplex( ))
		img := modulus(img)

	// Get the dimension sizes, and determine half the smallest dimension 
	img.Get2dSize( xsize, ysize )
	halfMinor = min( xsize, ysize )/2

	// Find the centre of the image
	centerx = xsize / 2
	centery = ysize / 2

	// Convert the image to polar co-ordinates...
	dst := RealImage( "dst", 4, halfMinor, xsize )
	dst = warp( img, icol*sin(irow*2*pi()/xsize) + \
			centerx, icol*cos(irow*2*pi()/xsize) + centery )

	// and create a line projection using the icol intrinsic variable, 
	// normalising with the sampling density
	line_projection := RealImage( "line projection", 4, halfMinor, 1 )
	line_projection = 0
	line_projection[icol,0] += dst
	line_projection /= xsize
	line_projection.ImageCopyCalibrationFrom(img)
	return line_projection
};

// sub-function2 : Gaussian blur
// http://www.dmscripting.com/files/Gaussian_Blur.s
image GaussianBlur(image sourceimg, number standarddev)	{
	if(standarddev<=0) return sourceimg

	number xsize, ysize
	getsize(sourceimg, xsize, ysize)

	// Create the gaussian kernel using the same dimensions as the expanded image
	image kernelimg:=realimage("",4,xsize,ysize)
	kernelimg=1/(2*pi()*standarddev**2)*exp(-1*(iradius**2/(2*standarddev**2)))


	// Carry out the convolution in Fourier space
	compleximage fftkernelimg:=realFFT(kernelimg)
	compleximage FFTSource:=realfft(sourceimg)
	compleximage FFTProduct:=FFTSource*fftkernelimg.modulus().sqrt()
	realimage invFFT:=realIFFT(FFTProduct)
	invFFT=(invFFT-min(invFFT))/(max(invFFT)-min(invFFT))
	invFFT=(max(sourceimg)-min(sourceimg))*invFFT+min(sourceimg)
	return invFFT
};


// Main function
image LatticeEnhancedFilter(image img)	{
	// LatticeEnhancedFilter(image img, number mu, number f0)
	// img : input image
	
	// Determine the enhanced component
	image fft_img=RealFFT(img)
	number dp_sx, dp_sy
	fft_img.GetSize(dp_sx,dp_sy)
	image LP1

	//  Display the DP radial average
	if(dp_sx>1024)
	{
		LP1=Rotational_Average(fft_img)[0,0,1,round(dp_sx/4)]
	}
	else
	{
		LP1=Rotational_Average(fft_img)
	}

	LP1[0,0,1,8]=0
	LP1.setname("radial average of DP")
	LP1.showimage()

	// parameter input
	number f0, mu
	GetNumber("Select enhanced center",30,mu)
	f0=10
	result("mu="+mu+", f0="+f0+"\n")
	LP1.DeleteImage()
	// Set parameters
	number sig=sqrt((mu-f0)**2/2.50553)
	number sx, sy
	getsize(img,sx,sy)
	
	// Creat mask
	///////////////////////////////////////////////////////////////
	image filimg := img*0
	filimg=(1/(sqrt(2*pi()*sig**2)))*exp(-0.5*((iradius-mu)/sig)**2)
	
	// Set background region weight=1
	number v0=(1/(sqrt(2*pi()*sig**2)))*exp(-0.5*((f0-mu)/sig)**2)
	filimg=tert(iradius<f0,v0,filimg)
	filimg=tert(iradius>(2*mu-f0),v0,filimg)
	filimg=filimg/v0
	
	// smooth by Gaussian blur
	image filimg2=GaussianBlur(filimg,f0/2)
	filimg2=filimg2/filimg2.GetPixel(sx/2,sy/2)
	filimg2.SetName("Mask")
	image LP_filimg2=Rotational_Average(filimg2)
	LP_filimg2.SetName("Mask Rotational Profile")
	// LP_filimg2.showimage()

	// Apply mask
	image fft_mask_img = RealFFT(img)*filimg2
	image mask_img := img.ImageClone()
	mask_img = RealIFFT(fft_mask_img)
	
	// copy calibration info
	string str = img.GetName()
	mask_img.setname(str+"Lattice-Enhanced-FilterV2")
	
	return mask_img
};

// main script
{
	image img := GetFrontImage()
	image filtered := LatticeEnhancedFilter(img)
	filtered.showimage()
}
