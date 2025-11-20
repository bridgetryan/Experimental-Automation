# Flat Field Correction

## Description
These ImageJ macros automate:
1.	Generating a TIF reference image from a uniform fluorescent slide ND2 image, for performing flat field correction
2.	Performing flat field correction on blinded ND2 fluorescent image files using the TIF reference image

## Generate the TIF reference image
This macro automates generating a TIF reference image using an ND2 image file collected from a uniform fluorescent slide (Chroma, 92001). 

Notes on collecting the uniform fluorescent image: 
-	The image dimensions (ex: 1024 X 1024) should match the experimental images
-	The uniform fluorescent slide and imaged colour channel (ex: 488 nm) should match the colour channel to be quantified from the experimental images
-	The image should be collected to maximize the pixel intensity distribution, avoiding black and white saturated pixels
-	The image should be collected at the same time as the experimental images

The macro code is run through ImageJ (Plugins > Macros > Run… > select IJM macro file). The macro expects that the ND2 image should be the only ND2 file in its directory. Using the pop-up window, select the directory containing the ND2 image file. The macro automates the following steps:
1.	Open the nd2 image in ImageJ
2.	Change to 32-bit
3.	Apply a 20-pixel median
4.	Measure the maximum pixel value in the image
5.	Divide every pixel in the image by the maximum pixel value
6.	Save as a TIF image in the same location as the nd2 image

## Perform flat field correction on nd2 images
[Macro_Image-Blinder]: https://github.com/bridgetryan/Experimental-Automation/blob/main/Image%20Blinder/Macro_Image-Blinder.ijm
[Macro_Create-Reference-Image]: 

This macro automates performing flat field correction on one colour channel of multi-channel fluorescence images. It expects ND2 images that are blinded and randomized using the [Image Blinder macro][Macro_Image-Blinder]. All blinded subfolders and the TIF reference image generated using the Create Reference Image macro should be in a common source folder. 

Important note: this macro assumes multi-channel images without z-stacks, and that the channel needing flat field correction is C2. This code will likely need to be edited to accommodate other experimental image contexts.

The macro automates the following steps
1.	Open the first blinded ND2 experimental image file
2.	Open the TIF reference image
3.	Split the ND2 image channels and select channel C2
4.	Divide the C2 channel image by the TIF reference image to perform flat field correction
5.	Save the flat field corrected C2 channel image as a TIF alongside the original ND2 image
6.	Repeat for all blinded images in the source folder
