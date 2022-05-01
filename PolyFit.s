Image PolyFit(Image input, Image fitRange, number order, Image &pars){
	if (order<1) order=1
	
	// input setups
	pars := NewImage("pars", 2, order+1)
	Image parsToFit := NewImage("pars to fit", 2, order+1)
	pars = 1
	parsToFit = 1
	Number chiSqr = 1e6
	Number conv_cond = 0.00001
	String formulaStr = "p0"
	for (number i=1; i<order+1; i++){
		formulaStr += ("+p"+(i)+"*x**"+(i))
	}
	result("Fitting formula : "+formulaStr+"\n")
	
	Number ok = FitFormula(formulaStr, input, fitRange, pars, parsToFit, chiSqr, conv_cond)
	Image fitResult := PlotFormula(formulaStr, input, pars)
	
	return fitResult
}

void FittingStack(Image input, Image fitResult, String label){
	number d0
	input.ImageGetDimensionSizes(d0)
	Image stack := NewImage(label, 2, d0, 2)
	stack[icol,0] = input
	stack[icol,1] = fitResult
	ImageDocument StackDoc = CreateImageDocument(label)
	ImageDisplay StackDisp = StackDoc.ImageDocumentAddImageDisplay(stack, 3)
	object sID
	sID = StackDisp.ImageDisplayGetSliceIDByIndex( 0 )
	StackDisp.ImageDisplaySetSliceLabelByID( sID , "Input data" )
	sID = StackDisp.ImageDisplayGetSliceIDByIndex( 1 )
	StackDisp.ImageDisplaySetSliceLabelByID( sID , "fitting" )
	StackDisp.LinePlotImageDisplaySetLegendShown( 1 )
	StackDoc.ImageDocumentShow()
}

//example
Image img := NewImage("1st order",2,256)
img = 10 - 0.2*icol -0.63*icol**2 + 0.037*icol**3

Image fitRange := img.ImageClone()
fitRange = 1
for(number i=1;i<=5;i++){
	Image pars
	Image fitResult := PolyFit(img, fitRange, i, pars)
	string label = "Fitting formula : "+pars.GetPixel(0,0).format("%.3f")
	for(number j=1;j<=i; j++){
		label += "+"+pars.GetPixel(j,0).format("%.3f")+"*x^"+j
	}
	FittingStack(img, fitResult, label)
}

