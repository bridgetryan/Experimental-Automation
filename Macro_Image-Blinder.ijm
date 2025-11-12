// Determine the operating system
// This allows the macro to run on Windows and Mac
function getRoot(){
	if(File.separator == "/"){
		return "/";
	}else{
		return "C:";
	}
}

// Create a BlindID that is an 8-character string of alphanumeric characters
function getRandomString(length) {
    // Define the set of characters to choose from
    chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    result = "";
    
    // Loop to pick random characters
    for (i = 0; i < length; i++) {
        index = round(random() * (lengthOf(chars) - 1));
        result = result + substring(chars, index, index + 1);
    }
    return result;
}

// Helper function to get the file extension
function getFileExtension(fileName) {
    dotIndex = lastIndexOf(fileName, ".");
    return substring(fileName, dotIndex);
}


// Core file blinding code

// Choose the source folder containing image files to be blinded
sourceFolderPath = getDirectory("Source Folder");

// Create a destination folder for the blinded images in the Source folder, called Blinded Images
blindedFolderPath = sourceFolderPath + "Blinded Images" + File.separator;
File.makeDirectory(blindedFolderPath);
destinationFolderPath = blindedFolderPath;

// Specify the file type to blind
Dialog.create("What type of file do you want to blind?");
Dialog.addChoice("File type:", newArray(".nd2", ".tif"));   // Add other file extensions, if desired
Dialog.show();
desiredExtension = Dialog.getChoice();

// Loop through each file in the source folder with the desired file extension, creating a blinded copy
fileList = getFileList(sourceFolderPath);  

row = 0;
for (i = 0; i < fileList.length; i++) {
    fileName = fileList[i];
    
    // Check if the item has the desired file extension
    if (endsWith(fileName, desiredExtension)) {
        BlindID = getRandomString(8);           // Generate a unique BlindID 8 characters in length
        ImageName = fileName;                   // Use the original file name as the image name

        // Add BlindID and Image Name to the Results Table
        setResult("BlindID", row, BlindID);
        setResult("Image Name", row, ImageName);

        // Create a subfolder in the destination folder with the BlindID as the folder name
        BlindIDFolderPath = destinationFolderPath + BlindID + File.separator;
        File.makeDirectory(BlindIDFolderPath);

        // Copy the image file to the new BlindID subfolder, keeping the original extension
        originalFilePath = sourceFolderPath + fileName;
        newFilePath = BlindIDFolderPath + BlindID + getFileExtension(fileName);
        File.copy(originalFilePath, newFilePath);

        // Move to the next row in the results table
        row++;
    }
}

// Update and display the Results Table with all entries
updateResults();

// Save the results file
resultsFile = destinationFolderPath + "Blind-key.csv";
print(resultsFile);
selectWindow("Results");
saveAs("Results", resultsFile);