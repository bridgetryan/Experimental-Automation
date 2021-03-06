#!/usr/bin/env python

import sys
import os
import glob
import re
import string
import random
import shutil
import argparse
import csv
from tempfile import NamedTemporaryFile

def appendColumnToData(data, label, column):
    # check if there is a difference in row counts
    rowDiff = len(column) - len(data)

    # if the existing data has too few rows, expand it
    if rowDiff > 0:
        # create a blank row template
        blankRow = {}
        if len(data) > 0:
            blankRow = {key: '' for key in data[0]}
        blankRow[label] = ''

        # add blank rows to extend row count so the CSV is long enough
        for i in range(rowDiff):
            data.append(blankRow.copy())
        
    # at this point, we have at least enough rows, we can copy in our column
    for (i, v) in enumerate(column):
        data[i][label] = v

def appendToRegionFile(directory, region, blindId, measurements):
    data = []

    # read in existing data, if there is any
    regionFileName = os.path.join(directory, '%s_measurements.csv' % region)
    if os.path.exists(regionFileName):
        with open(regionFileName, 'r') as csv_file:
            reader = csv.DictReader(csv_file, delimiter=',')
            for row in reader:
                data.append(row)
    
    # add our column of data
    appendColumnToData(data, blindId, measurements)

    # overwrite collation file
    tempfile = NamedTemporaryFile(mode='w', delete=False)
    fields = data[0].keys()
    writer = csv.DictWriter(tempfile, fieldnames=fields)
    writer.writeheader()
    writer.writerows(data)
    shutil.move(tempfile.name, regionFileName)


def readMeasurements(file):
    results = []
    with open(file) as csv_file:
        reader = csv.DictReader(csv_file, delimiter=',')
        for row in reader:
            results.append(row['Mean'])
    
    return results
        

def collate(input_dir):
    path = os.path.join(input_dir,"*_measurements.csv")
    for measurementsFile in glob.glob(path):
        m = re.match(r".*?(?P<region>\w+)_(?P<blindId>\w+)_measurements.csv$", measurementsFile)
        if m != None:
            region = m.groupdict()['region']
            blindId = m.groupdict()['blindId']
            measurements = readMeasurements(measurementsFile)
            appendToRegionFile(input_dir, region, blindId, measurements)

parser = argparse.ArgumentParser(description='Assembles single cell measurements')
parser.add_argument('input_dir', type=str, help='The path to a directory of cell measurement result files')

args = parser.parse_args()

collate(args.input_dir)