# about

The script accepts a single argument: the path to a directory of cell measurement files.

When executed, it will:

1. Find all files that end with the name `<region>_<blindId>_measurements.csv` in the specified directory
2. Read all the data in a column called `Mean`
3. Copy that column data into a file called `<region>.csv` in the same directory
  - if the region file doesn't exist, it will be created
  - if the region file does exist, the new column gets added/updated

# how to run

Run `python ./single-cell-measurements.py <INPUT_DIR>`, replacing `<INPUT_DIR>` with the directory of your data.


For example, you can run it on the included test data like this:

`python ./single-cell-measurements.py ./testdata`