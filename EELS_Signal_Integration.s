// to integrate the EELS signal
image src := GetFrontImage()

if (src.ImageGetNumDimensions() < 3 ) {
	result("dimension : " + src.ImageGetNumDimensions() + ", ")
	result("Not a 3D image, exit the process...")
	exit(0)
};

number sx, sy, sz
src.Get3DSize(sx, sy, sz)
result("sz : " + sz + "\n")
if (sz==1) exit(0)

number Eorignal, Estep
Eorignal = src.ImageGetDimensionOrigin(2)
Estep = src.ImageGetDimensionScale(2)


// comput the EELS background and then extract the signal
number bEs = 1500	// unit: eV
number bEe = 1800	// unit: eV
image signal := EELSSubtractPowerLawBackground(src, bEs, bEe)


// Integral the EELS signal
// set parameter
number edge = 1850		// unit:eV
number Eintegal = 200	// unit: eV

// Get the Energy axis
image axis = RealImage("axis",4,sz,1)
axis = icol*Estep + Eorignal

// find the edge channel
axis -= edge
number qval, Echannelx,Echannely
qval = min(abs(axis),Echannelx,Echannely)
result("qval = " + qval +"\n")
result("Echannelx = " + Echannelx +"\n")
result("Echannely = " + Echannely +"\n")

//Slice3(data3D,X1,Y1,Z1,dim1,length1,stepsize1,dim2,length2,stepsize2,dim3,length3,stepsize3)
image SignalInt := signal.slice3(0,0,Echannelx,0,sx,1,1,sy,1,2,round(Eintegal/Estep),1).ImageClone()
SignalInt.SetName("Signal SI")
//SignalInt.ShowImage()

image SignalProj = Project(SignalInt,2)
SignalProj.SetName("Signal")
SignalProj.ShowImage()
