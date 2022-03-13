// create +/-g mask
// ref:
// C:\ProgramData\Gatan\Sample Scripts\Pretty Examples\Crystal.s
// https://stackoverflow.com/questions/64313050/adaptive-fourier-filter/64316300#64316300


// Create a crystalline image
realimage img := RealImage( "crystalline Image 2D", 4, 256, 256 )
number  spacingX = 20, spacingY = 35
number  background = 200, contrast = 0.1, SNR=1
img = background*(1 + contrast*( sin(2*pi()*icol/SpacingX) \
				  *sin(2*pi()*irow/spacingY) + Random()/(SNR*65536))) 
img.ShowImage()
 
// Transform to Fourier Space
compleximage img_FFT := FFT(img)
 
// Create "Mask" or Filter in Fourier Space
// This is where all the "adaptive" things have to happen to create
// the correct mask. The below is just a dummy
image mask := RealImage("Mask",4, 256,256 )

number gx, gy, gr
gx = 14
gy = 6
gr = 5

mask =  SQRT((icol-trunc(iwidth/2)-gx)**2+(irow-trunc(iheight/2)-gy)**2) < gr ? 1 : mask
mask =  SQRT((icol-trunc(iwidth/2)+gx)**2+(irow-trunc(iheight/2)+gy)**2) < gr ? 1 : mask
mask = iradius<gr ? 1 : mask
mask.ShowImage()


// Apply mask
img_FFT *= mask 
img_FFT.SetName( "Masked FFT" )
img_FFT.ShowImage()
 
// Transform back
image img_filter := modulus(iFFT(img_FFT))
img_filter.SetName( img.GetName() + " Filtered" )
img_filter.ShowImage()
