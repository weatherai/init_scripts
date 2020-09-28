use admin
db.createUser({user:"admin", pwd:"PASSWORD HERE", roles:[{role:"root", db:"admin"}]})
exit