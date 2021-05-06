// Batched crop ROI in the same region
// 
// 2017/04/20
// 2019/05/14 fix the missing scale information
// Renfong


// Get ROI position
image front
ImageDisplay disp
ROI c_roi

front.GetFrontImage()
disp = front.ImageGetImageDisplay(0)


//Get ROI information

c_roi=disp.ImageDisplayGetROI(0)
number top, bottom, left, right
c_roi.ROIGetRectangle(top, left, bottom, right)
result("top="+top+" left="+left+" bottom="+bottom+" right="+right+"\n")

// batched process
While(front.ImageIsValid())
{
	image crop
	crop:=front[top, left, bottom, right]
	crop.setname(front.getname()+"_crop")
	crop.showimage()
	front:=FindNextImage(front)
}