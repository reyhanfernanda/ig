import redis

client = redis.Redis()

client.hset('users:123', 'NIM', '175610078')
client.hset('users:123', 'Nama', 'Reyhan Fernanda')
client.hset('users:123', 'Alamat', 'Wonosobo')
client.hset('users:123', 'No WA', '089647017887')
client.hset('users:123', 'IPK', '3,77')