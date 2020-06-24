import pymongo

myclient = pymongo.MongoClient("mongodb://localhost:27017/")
mydb = myclient["databaseku"]
mycol = mydb["mahasiswaku"]

myresult = mycol.find().limit(2)

#print the result:
for x in myresult:
  print(x)