import pymongo

myclient = pymongo.MongoClient("mongodb://localhost:27017/")
mydb = myclient["databaseku"]
mycol = mydb["mahasiswaku"]

x = mycol.find_one()

print(x)