exec sp_configure 'audit queue size',5000
go


/* production config

Parameter Name    Default      Memory Used  Config Value  Run Value     Unit    Type
----------------  -----------  -----------  ------------  ------------  ------  -------  
audit queue size          100            4          5000          5000  number  dynamic

*/