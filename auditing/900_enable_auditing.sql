--enable auditing. Do so only when you're sure everything is setup correctly

exec sp_configure "auditing",1
go