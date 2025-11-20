function getRoot(){
	if(File.separator == "/"){
		return "/";
	}else{
		return "C:";
	}
}

// Define the folder containing the flat field reference TIF image and blinded subfolders of nd2 images

mainDir = getDirectory("Main Directory");
print("Main directory is: " + mainDir);


//This function can be called to open the flatfield TIF and nd2 file
function openFiles(blindID){
	//the input directories are blinded subfolders in the main directory, containing nd2 images
	inputDir = mainDir + File.separator + blindID;

	//do not perform flat field correction if the blindID is not a directory
	if(!File.isDirectory(inputDir)){
		print("[" + inputDir + "] is not a directory, skipping");
		return false; // no processing needed
	}
	
	//open the flat field TIF file
	list = getFileList(mainDir);
	for (i = 0; i < list.length; i++){
		currentFileName = list[i];
		if (endsWith(currentFileName, ".tif")){
			open(mainDir + File.separator + currentFileName);
		}
	}
		
	//open the first blinded nd2 image file for flat field correction
	list = getFileList(inputDir);

	for (i = 0; i < list.length; i++){
		currentFileName = list[i];
		if (endsWith(currentFileName, ".nd2")){
			//square brackets needed around the file name to prevent spaces in the file name from being interpreted as new arguements
			run("Bio-Formats Importer", "open=[" + inputDir + File.separator + currentFileName + "] autoscale color_mode=Composite display_rois rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");	
		} else if (endsWith(currentFileName, ".tiff")){
			// skip directories that already have been processed. i.e. that already have a flat field corrected TIF image in them
			print(currentFileName + " is being skipped because it has already been processed");
			return false; // no processing needed
		}
	}
	
	
	return true; // needs processing
}


// This function processes nd2 files and saves the the processed image as a TIF file.
function processND2(blindID){
	// The input directory is a combination of
	inputDir = mainDir + File.separator + blindID;

	//The current file name is
	currentFileName = blindID + ".nd2";
	selectWindow(currentFileName);
	print("The current nd2 file is " + currentFileName);
	
	//converts the image to 32-bit and split channels
	run("32-bit");
	run("Split Channels");

	//performs flat field correction on the green channel (C2)
	//IMPORTANT NOTE: assumes that the reference TIF image is called "Reference_FlatField"
	imageCalculator("Divide create stack", "C2-" + currentFileName,"Reference_FlatField.tif");

	//save as a TIFF file
	saveAs("Tiff", inputDir + File.separator + blindID);

	//close all open images
	close("*");
}


// List the contents of the main directory. This should be the flat field reference image and folders that are the blindID name
setBatchMode(true);
blindIDList = getFileList(mainDir);

print("There should be " + blindIDList.length + " files in the main directory");
for(i = 0; i < blindIDList.length; i++){
	//get each blindID from the list
	blindID = replace(blindIDList[i],"/","");
	print(blindID + " selected for processing");
			
	// If the openFiles function is true, the image needs to be processed. This involves collecting AF measurements for RPE and background. If false, move on to the next image.
	needsProcessing = openFiles(blindID);
	if(needsProcessing){
		processND2(blindID);
	}
}

setBatchMode(false);