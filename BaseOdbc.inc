!ABCIncludeFile

  OMIT('_EndOfInclude_',_BaseODBPresent_)
_BaseODBPresent_   EQUATE(1)

  include('odbcTypes.inc'),once
  include('odbcConnStrCl.inc'),once
  include('odbcConn.inc'),once
  include('odbcCl.inc'),once
  include('odbcColumnsCl.inc'),once
  include('odbcParamsCl.inc'),once


BaseODBC        class,type,module('BaseODBC.clw'),link('BaseODBC.clw',_ABCLinkMode_),dll(_ABCDllMode_)
! flag to indicate the columns object has been allocated
columnsAllocated   bool,private
! flag to indicate the parameters object has been allocated
parametersAllocated bool,private
! columns instance for the query
cols               &columnsClass,private
! parameters instance for this object
params             &ParametersClass,private
! IDynstr instance used for the query
! holds the sql statement
sqlCode            &IDynStr,private
! ---------------------------------------------
! the instance of the odbc object for use
odbc               &odbcClType
! connection instance for the data access
conn               &ODBCConnectionClType
! connection string instance
connStr            &MSConnStrClType
! =========================================================
construct          procedure()
destruct           procedure(),virtual

! ------------------------------------------------------------
! init's the various objects and assigns the connection string
! object and the connection object
! ------------------------------------------------------------
init               procedure(string serverName, string databaseName),byte,proc

! ------------------------------------------------------------
! typical clean up, disposes the various objects
! ------------------------------------------------------------
kill               procedure()
! ------------------------------------------------------------
! connects to the database
! check the return value when calling, the connection may fail
! ------------------------------------------------------------
connect            procedure(),sqlReturn

! ------------------------------------------------------------
! disconnects from  the database
! the return value can be check, but if the disconnect
! fails things have gone south
! ------------------------------------------------------------
disconnect         procedure(),sqlReturn,proc

! ------------------------------------------------------------
! executes the query that was set up and fills the queue
! input with the values from the result set
! Note:  this will execute a query with or without parameters
! there is seldom a valid reason to call a query without parameters
! even if a dummy or place holder is used
! ------------------------------------------------------------
execQuery          procedure(*queue q)

! ------------------------------------------------------------
! clears the columns, parameters and the sql statement in the
! dynamic string.
!
! Note: Call this before setting up a query.  if not called
! the columns and parameters from the previous query
! may still be in the list
! ------------------------------------------------------------
clearQuery         procedure(),virtual

! ------------------------------------------------------------
! primes the dynamic string with the sql statement input
! ------------------------------------------------------------
primeQuery         procedure(*IDynStr query),virtual

! ------------------------------------------------------------
! primes the dynamic string with the sql statement input
! ------------------------------------------------------------
primeQuery         procedure(string query) !virtual

! ------------------------------------------------------------
! adds a string column to the query
! ------------------------------------------------------------
AddColumn          procedure(*long colPtr),sqlReturn,proc

! ------------------------------------------------------------
! adds an integer  column to the query
! ------------------------------------------------------------
AddColumn          procedure(*string colPtr),sqlReturn,proc

! ------------------------------------------------------------
! clears the columns queue
! ------------------------------------------------------------
clearColumns       procedure(),protected

! ------------------------------------------------------------
! allocates the columns class if not crated and sets the flag
! ------------------------------------------------------------
allocateColumns    procedure(),private

! ------------------------------------------------------------
! adds an input integer parameter
! ------------------------------------------------------------
AddInParameter     procedure(*long colPtr),sqlReturn,proc

! ------------------------------------------------------------
! clears the parameters
! ------------------------------------------------------------
clearParameters    procedure(),protected

! ------------------------------------------------------------
! allocates the parameters class if not created and sets the flag
! ------------------------------------------------------------
AllocateParameters procedure(),private

  end ! class
! ======================================
  _EndOfInclude_