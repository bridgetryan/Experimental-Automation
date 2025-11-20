function getRoot(){
	if(File.separator == "/"){
		return "/";
	}else{
		return "C:";
	}
}


// Define the folder containing the uniform fluorescent nd2 image file
mainDir = getDirectory("Main Directory");
print("Main directory is: " + mainDir);

//open the uniform fluorescent nd2 image
//this is located in the main directory
list = getFileList(mainDir);
for (i = 0; i < list.length; i++){
	currentFileName = list[i];
	if (endsWith(currentFileName, ".nd2")){
		//square brackets needed around the file name to prevent spaces in the file name from being interpreted as new arguements
		run("Bio-Formats Importer", "open=[" + mainDir + File.separator + currentFileName + "] color_mode=Composite display_rois rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
		}
	}
	
//convert the image to 32 bit
run("32-bit");

//smooth by applying a median filter with a radius of 20 pixels
run("Median...", "radius=20");

//collect the maximum pixel intensity value from the image
getStatistics(area, mean, min, max, std, histogram);
print("max pixel intensity = " + max);

//divide all pixels in the image by the maximum pixel value
run("Divide...", "value=" + max);

//save the image as a tif in the main directory
saveAs("Tiff", mainDir + File.separator + "Reference_FlatField");