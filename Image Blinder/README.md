# File Blinding and Randomization Macro 

## Description 

This ImageJ macro currently works to blind and randomize n2d or tif images, simultaneously creating a csv file to enable post-analysis unblinding. Note: the macro code can easily be updated to include additional file types. All files to be blinded and randomized should be deposited into a single folder. The macro code is run through ImageJ (Plugins > Macros > Run… > select IJM macro file). Using the pop-up windows, select the source folder containing files to be blinded and the desired file type (i.e. file extension). 

The macro will automate the following steps: 

- Create a new folder in the source folder called “Blinded Images”, which will serve as a destination folder 

- Duplicate the first image file 

  - Note: this is preformed to maintain the original files unaltered 

- Rename the duplicated image file with an 8-character random alpha numeric string  

- Save the duplicated renamed image into the destination folder, organized into a new folder also named with the blind ID  

  - Note: this is performed because we’ve found this organization to be helpful for automating downstream image processing steps, such as creating and collecting measurements from ROIs 

- Input the original file name and blinded ID into a new row of a table 

- Repeat with the remaining images in the source folder 

- Save the table in the destination folder as a csv called Blind-key 