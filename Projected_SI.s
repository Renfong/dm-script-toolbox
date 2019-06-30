// Projected SI to the x axis (sum up all y-axis spectrum)
// Using the built-in function slice2
//
// V1.0
// 2019/5/21 Renfong

image front:=GetFrontImage()
number sx,sy,sz
front.Get3dSize(sx,sy,sz)

image projx
projx:=slice2(front,0,0,0,2,sz,1,0,sx,1).Imageclone()

for (number i=1; i<sy; i++)
{
	projx+=slice2(front,0,i,0,2,sz,1,0,sx,1)
}
projx.SetName(front.GetName()+"-proj_X")
projx.showimage()