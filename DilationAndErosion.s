// simple dilation and erosion filter
//
// Renfong @ TSMC
// 2021/09/01

image src := GetFrontImage()
number win = 1
number sx, sy
src.GetSize(sx, sy)
image stack = RealImage("offset_stack",4,sx,sy,(2*win+1)**2)

number count=0
for (number i= -1*win; i<= win; i++){
	for (number j= -1*win; j<= win; j++){
		result(count+"\n")
		stack.slice2(0,0,count,0,sx,1,1,sy,1) = src.offset(i,j)
		count += 1
	};
};

image projz = project(stack,2)
image dilation = (projz>0)
dilation.SetName("dilation")
dilation.ShowImage()

image erosion = (projz>=(2*win+1)**2)
erosion.SetName("erosion")
erosion.ShowImage()

