image NormRGB(image src){
	image dst := src.ImageClone()
	dst -= min(dst)
	dst /= max(dst)
	dst *= 255
	
	return dst
}
image img1, img2, img3
string title = "Create RGB stack"
string prompt = "Please select three images."
if ( !GetThreeLabeledImagesWithPrompt( prompt, title, "R : ", img1, "G : ", img2, "B : ", img3 ) )
Throw( "User pressed cancel." )

number d10, d11, d20, d21, d30, d31
img1.ImageGetDimensionSizes(d10, d11)
img2.ImageGetDimensionSizes(d20, d21)
img3.ImageGetDimensionSizes(d30, d31)
if (!((d10==d20)*(d20==d30))*((d11==d21)*(d21==d31)))
Throw( "Dimensions are not matched." )

rgbimage myImage := RGBImage( "RGB Stack", 4, d10, d11 )
myImage = rgb( NormRGB(img1), NormRGB(img2), NormRGB(img3))
ShowImage( myImage )