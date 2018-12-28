import csv
import re

with open('vdkl_change_city_zip.csv') as f:
    reader = csv.reader(f)
    for row in reader:
        loc = row[3]
        # print(loc)

        zip_pattern = re.compile(r'\d{4,}')
        zip = ''
        for match in re.findall(zip_pattern, loc):
            zip = match
        # print(zip)

        city_pattern = re.compile(r'(?<=\d{4} ).+')
        city = ''
        for match in re.findall(city_pattern, loc):
            city = match
        # print(city)

        row[1] = zip
        row[2] = city
        print(row)

        with open('vdkl_loc_import.csv', 'a') as i:
            writer = csv.writer(i, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)
            writer.writerow(row[:3])
