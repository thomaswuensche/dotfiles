import csv
import re

with open('imperial_lager.csv') as f:
    reader = csv.reader(f, delimiter=';')
    for row in reader:
        # print(row)
        phone = row[5]
        phone = phone.replace("Telefon 0", "+49", 1)
        phone = phone.replace("/", "")
        phone = phone.replace(" ", "")
        phone = phone.replace("-", "")
        print(phone)
        row[5] = phone

        name = row[1]
        city = row[4]
        name = name + ' ' + city
        print(name)
        row[1] = name

        with open('imperial_lager_new.csv', 'a') as i:
            writer = csv.writer(i, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)
            writer.writerow(row)
