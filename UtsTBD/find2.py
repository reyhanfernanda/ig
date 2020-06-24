import pymongo

myclient = pymongo.MongoClient("mongodb://localhost:27017/")
mydb = myclient["dataku"]
mycol = mydb["profilku"]

for x in mycol.find():
  print(x)