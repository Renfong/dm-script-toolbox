// Merge sort in dm-script
//
// Renfong
// 2022/03/20

Image merge(Image left, Image right){
	number dl = left.ImageGetDimensionSize(0)
	number dr = right.ImageGetDimensionSize(0)
	
	image sorted := NewImage("Sorted",2,dl+dr)
	number idl = 0
	number idr = 0
	for (number i=0; i<(dl+dr); i++){
		if (left.GetPixel(idl,0) < right.GetPixel(idr,0)){
			sorted[0,i,1,i+1] = left[0,idl,1,idl+1]
			idl += 1
			if (idl == dl){
				sorted[0,i+1,1,(dl+dr)] = right[0,idr,1,dr]
				break
			}
		}
		else {
			sorted[0,i,1,i+1] = right[0,idr,1,idr+1]
			idr += 1
			if (idr == dr){
				sorted[0,i+1,1,(dl+dr)] = left[0,idl,1,dl]
				break
			}
		}
	}
	
	return sorted
}

Image MergeSort(Image arr){
	number d0 = arr.ImageGetDimensionSize(0)
	if (d0==1) {
		return arr
	}
	else{
		number mid = ceil(d0/2)
		Image left := NewImage("left",2,mid)
		left = arr[0,0,1,mid]
		left = MergeSort(left)
		Image right := NewImage("right",2,d0-mid)
		right = arr[0,mid,1,d0] 
		right = MergeSort(right)
		
		Image sorted := arr.ImageClone()
		sorted = merge(left, right)
		
		return sorted
	}
}

number d0=1000
Image test := NewImage("test",2,d0)
test = random()

Image sorted := MergeSort(test)

Image stack := NewImage("Comparison",2,d0,2)
stack[icol,0] = test
stack[icol,1] = sorted
ImageDocument linePlotDoc = CreateImageDocument("Test Sorting")
ImageDisplay linePlotDsp = linePlotDoc.ImageDocumentAddImageDisplay(stack, 3)
linePlotDoc.ImageDocumentShow()
