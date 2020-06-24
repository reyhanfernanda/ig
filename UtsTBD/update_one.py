import pymongo

myclient = pymongo.MongoClient("mongodb://localhost:27017/")
mydb = myclient["dataku"]
mycol = mydb["profilku"]

myquery = { "IPK": "3,49" }
newvalues = { "$set": { "IPK": "3,77" } }

mycol.update_one(myquery, newvalues)

for x in mycol.find():
  print(x) 