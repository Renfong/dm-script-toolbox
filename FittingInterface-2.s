Image FitErfFunc(Image input, Image fitrange, number cen, Image &pars){
	// formula : p0*0.5*(1+erf((x-p2)/(sqrt(2)*p1)))
	// amp    p0 : GetPixel(pars,0,0)
	// sigma  p1 : GetPixel(pars,1,0)
	// center p2 : GetPixel(pars,2,0)
	
	// setup fit:
	pars := NewImage("pars", 2, 3)
	Image parsToFit := NewImage("pars to fit", 2, 3)
	pars = 10;          // starting values
	pars.SetPixel(2,0,cen)
	parsToFit = 1;
	Number chiSqr = 1e6
	Number conv_cond = 0.00001
	String formulaStr = "p0*0.5*(1+erf((x-p2)/(sqrt(2)*p1)))"
	Number ok = FitFormula(formulaStr, input, fitrange, pars, parsToFit, chiSqr, conv_cond)

	Image FitResult := PlotFormula(formulaStr, input, pars)
	return FitResult
}

image img := RealImage("Test", 4, 256, 100)
img = tert(icol>=128 & icol<=256, 1, img)
image smooth := img.ImageClone()
smooth = 0 
number d = 10
for (number i=(-1*d); i<=d; i++) {
	smooth += img[icol+i, irow]
}
smooth /= (2*d+1)
smooth += 0.01*(random()-0.5)/0.5
smooth.ShowImage()

image src := GetFrontImage()
number d0, d1
d0 = src.ImageGetDimensionSize(0)
d1 = src.ImageGetDimensionSize(1)
image fitting := src.ImageClone()
fitting.SetName("Fitted")
number t0=GetHighResTickCount()
for (number i=0; i<d1; i++){
	image input = src.Slice1(0,i,0,0,d0,1)
	image fitrange, fitResult, pars
	fitrange = input.ImageClone()
	fitrange = 1
	fitting.Slice1(0,i,0,0,d0,1) = FitErfFunc(input, fitrange,10,pars)
}
number t1=GetHighResTickCount()
result("elapsed time : "+CalcHighResSecondsBetween(t0,t1)+" s\n")
fitting.ShowImage()