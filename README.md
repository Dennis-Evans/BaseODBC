# BaseODBC

The BaseODBC object is a helper class, wrapper class what ever label you want to use.  The class contains references to the various objects from the ODBC classes.  This has the benefit of making the ODBC objects simpler to use.  

the DbDemoWin directory contains a small, simple example using the class.  There is a .sln file, a .cwproj file, a .clw file and a .lib file for the driver. 

The lib file was created using ODBC 13.  Use libmaker.exe to create a .lib file for what ever version of the driver you are using.  
If using SQL Sever Native Client, any version, leave out the OleDb functions.  Adding them would not cause any harm but they are not used or needed.

Additional data types will be added for the AddColumn and AddParameters.  If needed you can always add the additional types and push the changes back into the repository.

The code will change some as I work with and test the code.  The changes may include some derived classes from the baseODBC or may be some interfaces are added.  As an example there could be an object that handles call to stored procedures and an object that handles the 'select <attributes> from schema.table'  that are in the using applications code.  The differences between those actions are fairly small but the code is a bit different.  Some changes could result from feedback form anyone evaluating or using the code.  

As always, add an issue for questions, errors or recommendations.  Also, just send me a n email.
