import pymongo

myclient = pymongo.MongoClient("mongodb://localhost:27017/")
mydb = myclient["dataku"]
mycol = mydb["profilku"]

myquery = { "NIM": "175610078" }

mycol.delete_one(myquery)

for x in mycol.find():
  print(x)