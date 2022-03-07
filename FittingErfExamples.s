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

// create test image
Image input := NewImage("test",2,150)
Image eq1 = input.ImageClone()
eq1 = 0.5*(1+erf((icol-52)/(sqrt(2)*3)))

Image eq2 = input.ImageClone()
eq2 = 1 - 0.5*(1+erf((icol-103)/(sqrt(2)*6)))

input[0,0,1,75]=eq1[0,0,1,75]
input[0,75,1,150]=eq2[0,75,1,150]
// add noise
input += (random()-0.5)*0.1

Image fitrange, pars
fitrange := input.ImageClone()

// fit range1
fitrange = tert(icol<75, max(input), 0)
Image FitResult1 := FitErfFunc(input, fitrange,50, pars)

// fit range2
fitrange = tert(icol>75, max(input), 0)
Image FitResult2 := FitErfFunc(1-input, fitrange,100, pars)
FitResult2 = 1-FitResult2

Image stack := NewImage("Fitting stack", 2, 150, 3)
stack[icol,0] = input
stack[icol,1] = FitResult1
stack[icol,2] = FitResult2
ImageDocument StackDoc = CreateImageDocument("Fitting result")
ImageDisplay StackDisp = StackDoc.ImageDocumentAddImageDisplay(stack, 3)
StackDisp.ImageDisplaySetSliceLabelByIndex( 0 , "Input data" )
StackDisp.ImageDisplaySetSliceLabelByIndex( 1 , "erf fitting" )
StackDisp.ImageDisplaySetSliceLabelByIndex( 2 , "erfc fitting" )
StackDisp.LinePlotImageDisplaySetLegendShown( 1 )
StackDoc.ImageDocumentShow()
