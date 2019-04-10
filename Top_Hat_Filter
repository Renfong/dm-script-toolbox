// Using Top_hat digital filter to detect the  relatively small edges 
//    superimposed on large background signals.
//
// ref: Ultramicroscopy 18 (1985) 185-190 
//      Digital Filters  for Application to Data Analysis in EELS
//      by Nestor J. ZALUZEC

// Parameters:
// win_s: signal window (default:3)
// win_b: background window (default:3)
//  a_s : amplitude of signal
//  a_b : amplitude of background
//
//
//              win_s
//             |-----|
//             |     |
//             |     |  a_s
//             |     |
//   ----|     |     |     |---- 
//   a_b |     |     |     | 
//       |-----|     |-----|
//        win_b


// Renfong 2018/10/11

// Main function
image Top_Hat_Filter(image img, number win_s, number win_b)
{
	// read image
	string fname=img.GetName()
	number sx,sy
	img.getsize(sx,sy)

	// filter
	image img2 := imageclone(img)*0
	
	//the area between signal and background must be equal
	number a_s=1
	number a_b=a_s/(2*win_b/win_s)	

	number i
	for(i=-1*(win_s-1)/2;i<=(win_s-1)/2;i++)
	{
		img2=img2+a_s*img.offset(i,0)
	}

	for(i=0;i<win_b;i++)
	{
		img2=img2-a_b*img.offset(-1*(win_s+1)/2-i,0)
		img2=img2-a_b*img.offset(1*(win_s+1)/2+i,0)
	}
	 
	img2=tert(icol<(win_s-1)/2+win_b,0,img2)

	img2=tert(icol>=(sx-(win_s-1)/2-win_b),0,img2)
	img2.setname("TH-Filter of " + fname)
	img2.showimage()
	img2.ImageCopyCalibrationFrom(img)
	img2.ImageSetIntensityUnitString( "e-" )
	return img2
}

// Main script
image img := GetFrontImage()
number win_s = 3
number win_b = 3

Top_Hat_Filter(img,win_s,win_b)
