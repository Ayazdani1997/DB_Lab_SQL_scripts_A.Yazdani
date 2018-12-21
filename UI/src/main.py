import pymssql as db

conn = db.connect(server='localhost',
                  user='SA',
                  password='SalamAhmadhossein1376',
                  database='ClanDB'
                  )
cursor = conn.cursor()
cursor.execute( 'select * from HavingResource' )
row = cursor.fetchone()
while row:
    print( str( row[ 0 ] ) + " " + str( row[ 1 ] ) + " " + str( row[ 2 ] ) )
    row = cursor.fetchone()
