//mark a segmented line ROI at 250 unit intervals with dots, starting at the first point in the line
//the interval unit may be um or pixels, depending on the image properties pixel width
//the interval length can be changed
interval = 250;
run("Fit Spline");
run("Interpolate", "interval=1 smooth");

getSelectionCoordinates(xp, yp);
run("Add Selection...","stroke=green width=3");
List.setMeasurements();
total = List.getValue("Length");

steps = (total/interval);
xm=newArray(steps+1);
ym=newArray(steps+1);
for (i=0;i<xm.length;i++) {
	xm[i]=xp[i*xp.length/steps];
	ym[i]=yp[i*xp.length/steps];
}

makeSelection("Point", xm, ym);
run("Point Tool...", "type=Dot color=Red size=[Large] counter=0");
run("Add Selection...","");