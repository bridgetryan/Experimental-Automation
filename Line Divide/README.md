# Line Divide Macro

## Description
- This macro marks a selected segmented line ROI in ImageJ at specified intervals, starting at the first point defined in the ROI
- The interval unit may be um or pixels, depending on the pixel width specified in the image properties
- The interval length specified in the code is 250, and can be changed

## Example Use
[article link]: https://www.biorxiv.org/content/10.1101/2025.10.25.684461v1
- This macro was used in [the following article][article link]
- The thickness of the outer nuclear layer (ONL) was measured at defined intervals, starting at the optic nerve head (ONH), from retina tissue section images
- Inferior and superior ONL were manually defined as two separate segmented lines, starting at the ONH
- The line divide macro was used to mark both inferior and superior segmented lines at 250 pixel intervals
- These marks were used to manually define and collect ONL thickness measurements at regular intervals