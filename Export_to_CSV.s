// Export all slice profiles into csv file
// ver: 1.0
//
// Ref:
// DM-Script Database - Will Bowman - Export_Line_Profile_As_Tabbed_Text
// https://www.felmi-zfe.at/dm_script/export-profiles-as-tabbed-text
//
// Dave Mitchell's DigitalMicrograph Scripting Website
// http://www.dmscripting.com/batch_export_spectra_as_tabbed_text.html
// 
// 
// Renfong
// 2019/06/04


// Main function
void ExportSlicesToCSV(image profile, String folder_name)
{
	String image_name = GetName( profile ) 
	String file_name = image_name + ".csv" 
	file_name=folder_name+file_name

	Number scale, origin, x_size, y_size
	String units,int_unit
	ImageDisplay profiles_image_display = profile.ImageGetImageDisplay( 0 )
	Number slice_count

	profile.ImageGetDimensionCalibration( 0, origin, scale, units, 1 )
	GetSize( profile, x_size, y_size )
	int_unit=profile.ImageGetIntensityUnitString()

	slice_count = profiles_image_display.ImageDisplayCountSlices()
	result(" --> "+slice_count+" slices..\n")

	// File I/O initialization
	Number output_file_ID = CreateFileForWriting( file_name )
	WriteFile(output_file_ID, " ,"+int_unit+"\n")
	WriteFile(output_file_ID, units + ",")

	// save all value to the image(out_table)
	Image out_table=RealImage("output_table",4,slice_count+1,x_size)
	out_table=0
	out_table[0,0,x_size,1]=(irow-origin)*scale
	//out_table.showimage()

	number i, j
	for (i=0; i<slice_count; i++)
	{
		Object silceid = profiles_image_display.ImageDisplayGetSliceIDByIndex( i )
		Image current_profile := profile{i}
		String current_label=profiles_image_display.ImageDisplayGetSliceLabelById( silceid )
		// write colume name
		WriteFile(output_file_ID, current_label + ",")
		out_table[0,i+1,x_size,i+2]=current_profile[irow,icolumn]
	}
	WriteFile(output_file_ID, "\n")
	
	// write values
	for (j=0; j<x_size; j++)
	{
		for (i=0; i<slice_count+1; i++)
		{
			WriteFile(output_file_ID, GetPixel(out_table,i,j)+",")
		}
		WriteFile(output_file_ID, "\n")
	}

	CloseFile( output_file_ID ) //close output file (end cpu process)
	result("    Done...\n")
	}

// Main script
number ndoc, imgdocid, i,sx, sy
ImageDocument imgdoc
Image front
String name, path, folder_name

ndoc=CountImageDocuments()
if (ndoc<1)
{
	ShowAlert("Ensure a 1D profile or spectra is front-most.",2)
	exit(0)
}
else result("\n\n"+ndoc+" documents are detected.\n")

if(!SaveAsDialog("Select output folder..","Do not change!!!",path))exit(0)
folder_name=PathExtractDirectory(path,0)

result("strat to convert...\n")
for (i=0 ; i<ndoc; i++)
{
	imgdoc=GetImageDocument(i)
	imgdocid=imgdoc.ImageDocumentGetID()
	ImageDocumentShow(imgdoc)
	front:=GetFrontImage()
	front.GetSize(sx,sy)
	name=front.GetName()
	if (sy==1)
	{
		result("  Converting file : "+name)
		ExportSlicesToCSV(front, folder_name)
	}
	else result("  "+name+" is not a 1D data. It does not to be converted....\n")
}
result("All finished...\n")
