// Do error function fitting with two different parameters
// 
// Renfong
// 2022/03/08

Image FitErfFunc(Image input, Image fitrange, number cen, Image &pars){
	// formula : 0.5*(1+erf((x-p1)/(sqrt(2)*p0)))
	// sigma  p0 : GetPixel(pars,0,0)
	// center p1 : GetPixel(pars,1,0)
	
	// setup fit:
	pars := NewImage("pars", 2, 2)
	Image parsToFit := NewImage("pars to fit", 2, 2)
	pars = 10;          // starting values
	pars.SetPixel(1,0,cen)
	parsToFit = 1;
	Number chiSqr = 1e6
	Number conv_cond = 0.00001
	String formulaStr = "0.5*(1+erf((x-p1)/(sqrt(2)*p0)))"
	Number ok = FitFormula(formulaStr, input, fitrange, pars, parsToFit, chiSqr, conv_cond)

	Image FitResult := PlotFormula(formulaStr, input, pars)
	return FitResult
}

Image AsymmErfFitting(Image src){
	number d0 = src.ImageGetDimensionSize(0)
	number val, px, py
	val = min((src-0.5)**2,px, py)
	result("px = "+px+"\n")

	// divided into 2 sections
	Image left = src.ImageClone()
	Image right = src.ImageClone()

	Image dummy1 := src[0,0,1,px].ImageClone()
	Image dummy2 := src[0,0,1,px].ImageClone()
	dummy2 = 1-dummy2
	dummy1 = dummy2[px-icol, irow]

	Image dummy3 := src[0,px,1,d0].ImageClone()
	Image dummy4 := src[0,px,1,d0].ImageClone()
	dummy4 = 1-dummy4
	dummy3 = dummy4[d0-px-icol, irow]

	if (px>trunc(d0/2)){
		left[0,px,1,d0] = dummy1[0,0,1,d0-px]
		right[0,2*px-d0,1,px]=dummy3
	}
	else {
		left[0,px,1,2*px] = dummy1
		right[0,0,1,px] = dummy3[0,d0-2*px,1,d0-px]
	}

	//tidy up
	dummy1.DeleteImage()
	dummy2.DeleteImage()
	dummy3.DeleteImage()
	dummy4.DeleteImage()

	// fitting
	Image fitrange, pars
	fitrange := input.ImageClone()
	fitrange=1

	Image lfFit := FitErfFunc(left,fitrange,50,pars)
	Image rtFit := FitErfFunc(right,fitrange,50,pars)
	Image fitted = src.ImageClone()
	fitted[0,0,1,px] = lfFit[0,0,1,px]
	fitted[0,px,1,d0] = rtFit[0,px,1,d0]
	
	return fitted
}

// create test image
number cen = 160
number sig1 = 10
number sig2 = 18
result("center is at "+cen+", sig1="+sig1+", sig2="+sig2+"\n")
Image input := NewImage("test",2,250)
Image eq1 = input.ImageClone()
eq1 = 0.5*(1+erf((icol-cen)/(sqrt(2)*sig1)))

Image eq2 = input.ImageClone()
eq2 = 0.5*(1+erf((icol-cen)/(sqrt(2)*sig2)))

input[0,0,1,cen]=eq1[0,0,1,cen]
input[0,cen,1,250]=eq2[0,cen,1,250]
// add noise
input += (random()-0.5)*0.05
input.ShowImage()

// main script
image src := GetFrontImage()
Image fitted := AsymmErfFitting(src)
Image stack := NewImage("Fitting stack", 2, 250, 3)
stack[icol,0] = src
stack[icol,1] = fitted
stack[icol,2] = src - fitted

ImageDocument StackDoc = CreateImageDocument("Fitting result")
ImageDisplay StackDisp = StackDoc.ImageDocumentAddImageDisplay(stack, 3)
StackDisp.ImageDisplaySetSliceLabelByIndex( 0 , "Input data" )
StackDisp.ImageDisplaySetSliceLabelByIndex( 1 , "Asymm-erf fitting" )
StackDisp.ImageDisplaySetSliceLabelByIndex( 2 , "residure" )
StackDisp.LinePlotImageDisplaySetLegendShown( 1 )
StackDoc.ImageDocumentShow()
