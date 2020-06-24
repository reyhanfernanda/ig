import pymongo

myclient = pymongo.MongoClient("mongodb://localhost:27017/")
mydb = myclient["dataku"]
mycol = mydb["profilku"]

myquery = { "NIM": "175610078" }

mydoc = mycol.find(myquery)

for x in mydoc:
  print(x) 