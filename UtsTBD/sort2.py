import pymongo

myclient = pymongo.MongoClient("mongodb://localhost:27017/")
mydb = myclient["databaseku"]
mycol = mydb["mahasiswaku"]

mydoc = mycol.find().sort("nama",-1)

for x in mydoc:
  print(x) 