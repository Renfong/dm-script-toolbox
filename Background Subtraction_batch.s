/*------------------------------------------------------------------------

Hit ctrl-enter to execute.

Description:
	
	Digital Micrograph Script BKS.s
	Version 1.1
	
	Subtract Slowly-Varying Background from an Image
	This removes slowly varing background from an image
	by successive reduction and bilinear interpolation scaling
	Original Version 25-Mar-94  by J. R. Minter (Eastman Kodak)
	based upon suggestions by M. Leber (Gatan)
	
	Revision History
	Updated to test for image size & remove (-) pixels	26-Mar-94 JRM
	Simplified and annotated by Paul Thomas March 2001

--------------------------------------------------------------------------*/
/*------------------------------
2020/02/27
Batched version
modified from the 
  C:\ProgramData\Gatan\Sample Scripts\Useful Examples\Background Subtraction.s

Renfong
ver 1.0
 */


/* 	This method calulates the slowly-varying background and subtracts it
	It is passed the source image, and returns the filtered image */

image Remove_Background( image source_img)
{
	// Ensure image is 2d and, get the size of the source image
	if ( source_img.ImageGetNumDimensions() != 2)
		Throw("Select a 2d image for this operation")
	number sizeX, sizeY
	Get2dSize(source_img, sizeX, sizeY)

	// Make a copy of the image and reduce it to about 8 x 8
	image reduced_img = RealImage("Reduced", 4, sizeX, sizeY)
	reduced_img = source_img
	while ( reduced_img.ImageGetDimensionSize(0) >= 16 \
			&& reduced_img.ImageGetDimensionSize(1) >= 16 )
	{
		Reduce(Reduced_Img)
	}
	
	// Rescale the reduced image to make a background
	// Note warp uses bilinear interpolation to rescale
	number sizeXr, sizeYr
	Get2DSize(Reduced_img, sizeXr, sizeYr)
	number Xfactor = (sizeX-1)/(sizeXr-1)
	number Yfactor = (sizeY-1)/(sizeYr-1)
	image Bkg_img = RealImage("Background", 4, sizeX, sizeY)
	Bkg_img = Warp(Reduced_Img, icol/Xfactor, irow/Yfactor)
	
	// Subtract the background image from the source image, 
	image out_img := RealImage("Background_removed", 4, sizeX, sizeY)
	out_img = source_img - Bkg_img

	// Add an offset to restore the original image average
	// and hence remove any -ve pixels created 
	out_img += average(source_img) - average(out_img) 
	
	return out_img 
}

// Example of use; call the method with all opened image
image source_img
source_img.GetFrontImage()

While(source_img.ImageIsValid())
{
	image out_img
	string out_title = source_img.GetName() + " (low freq. bkgnd. removed)" 
	out_img = Remove_Background(source_img)
	out_img.SetName(out_title)
	out_img.ImageCopyCalibrationFrom( source_img )
	out_img.ShowImage()
	source_img := FindNextImage(source_img)
}