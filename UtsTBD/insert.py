import pymongo

myclient = pymongo.MongoClient('mongodb://localhost:27017/')
mydb = myclient['dataku']
mycol = mydb["profilku"]

mydict = {"NIM":"175610078", "nama": "Reyhan Fernanda", "alamat": "Wonosobo","No WA":"089647017887","IPK":"3,49" }

x = mycol.insert_one(mydict)

print(x)