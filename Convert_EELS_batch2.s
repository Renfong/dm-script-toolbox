// Short version of convert_EELS
//
// 2017/4/20
// Renfong

// Sub-function
// convert data into EELS-SI
void Convert_EELS(image img)
{
	TagGroup metaDataTG = newTagGroup()
	metaDataTG.TagGroupSetTagAsString( "Format", "Spectrum image" )
	metaDataTG.TagGroupSetTagAsString( "Signal", "EELS" )

	img.ImageGetTagGroup().TagGroupSetTagAsTagGroup( "Meta Data", metaDataTG )
}

image front
number sx, sy
front.GetFrontImage()
front.GetSize(sx,sy)

While(front.ImageIsValid())
{
	If(sy>1)
	{
		front.Convert_EELS()
		result(front.GetName()+" OK \n" )
	}
	else
	{
		result(front.GetName()+" is not a 2D image. \n" )
	}
	
	front:=FindNextImage(front)
	front.GetSize(sx,sy)
}