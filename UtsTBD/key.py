import redis

client = redis.Redis()
client.set('user:123', 'Reyhan Fernanda')
user = client.get('user:123')

print user