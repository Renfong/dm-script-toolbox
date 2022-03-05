Image FitCurve1stOrder(Image input, Image fitrange, Image &pars){
	// formula : p0 + p1*x
	// p0 : GetPixel(pars,0,0)
	// p1 : GetPixel(pars,1,0)
	
	// setup fit:
	pars := NewImage("pars", 2, 2)
	Image parsToFit := NewImage("pars to fit", 2, 2)
	pars = 10;          // starting values
	parsToFit = 1;
	Number chiSqr = 1e6
	Number conv_cond = 0.00001
	String formulaStr = "p0 + p1*x"
	Number ok = FitFormula(formulaStr, input, fitrange, pars, parsToFit, chiSqr, conv_cond)

	Image FitResult := PlotFormula(formulaStr, input, pars)
	return FitResult
}

Image FitCurve2ndOrder(Image input, Image fitrange, Image &pars){
	// formula : p0 + p1*x + p2*x**2
	// p0 : GetPixel(pars,0,0)
	// p1 : GetPixel(pars,1,0)
	// p2 : GetPixel(pars,2,0)
	
	// setup fit:
	pars := NewImage("pars", 2, 3)
	Image parsToFit := NewImage("pars to fit", 2, 3)
	pars = 10;          // starting values
	parsToFit = 1;
	Number chiSqr = 1e6
	Number conv_cond = 0.00001
	String formulaStr = "p0 + p1*x + p2*x**2"
	Number ok = FitFormula(formulaStr, input, fitrange, pars, parsToFit, chiSqr, conv_cond)

	Image FitResult := PlotFormula(formulaStr, input, pars)
	return FitResult
}

// create example
Image input := NewImage("test",2,150)
// y = 2x+5
Image eq1 := NewImage("test",2,150)
eq1 = 2*icol + 5
// y = 0.1x^2 - 0.2x + 5
Image eq2 := NewImage("test",2,150)
eq2 = 0.1*icol**2 - 0.2*icol + 5

input[0,0,1,30] = eq1[0,0,1,30]
input[0,30,1,60] = eq2[0,30,1,60]
input[0,60,1,90] = eq1[0,60,1,90]
input[0,90,1,120] = eq2[0,90,1,120]
input[0,120,1,150] = eq1[0,120,1,150]

// add noise
input += (random()-0.5)*sqrt(abs(input))

// fit range 1
Image fitrange, FitResult1, FitResult2, pars
// set fitting range
fitrange := input.ImageClone()
fitrange = 0
fitrange[0,0,1,30] = max(input)
fitrange[0,60,1,90] = max(input)
fitrange[0,120,1,150] = max(input)

FitResult1 := FitCurve1stOrder(input, fitrange, pars)

// fit range 2
fitrange = 0
fitrange[0,30,1,60] = max(input)
fitrange[0,90,1,120] = max(input)

FitResult2 := FitCurve2ndOrder(input, fitrange, pars)


// show stack
Image stack := NewImage("Fitting stack", 2, 150, 3)
stack[icol,0] = input
stack[icol,1] = FitResult1
stack[icol,2] = FitResult2
ImageDocument StackDoc = CreateImageDocument("Fitting result")
ImageDisplay StackDisp = StackDoc.ImageDocumentAddImageDisplay(stack, 3)
StackDisp.ImageDisplaySetSliceLabelByIndex( 0 , "Input data" )
StackDisp.ImageDisplaySetSliceLabelByIndex( 1 , "1st order fitting" )
StackDisp.ImageDisplaySetSliceLabelByIndex( 2 , "2nd order fitting" )
StackDisp.LinePlotImageDisplaySetLegendShown( 1 )
StackDoc.ImageDocumentShow()
