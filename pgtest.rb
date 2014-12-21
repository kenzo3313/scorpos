 #!/opt/local/bin/ruby

 require "pg"

 begin
   conn = PG::Connection.open(:dbname => 'pgdbtest')
   q    = "select * from notePC"
   res  = conn.exec(q)
   res.each do |r|
     p r
   end
 rescue PGError => ex
   # PGError process
   print(ex.class," -> ",ex.message)
 rescue => ex
   # Other Error  process
   print(ex.class," -> ",ex.message)
 ensure
   conn.close if conn
 end
