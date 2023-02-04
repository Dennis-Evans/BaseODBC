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
init               procedure(string serverName, string databaseName)
kill               procedure()
! public methods
clearQuery         procedure(),virtual
primeQuery         procedure(*IDynStr query)
primeQuery         procedure(string query)
! add columns for the query
AddColumn          procedure(*long colPtr),sqlReturn,proc
AddColumn          procedure(*string colPtr),sqlReturn,proc
! add parameters for the query
AddInParameter     procedure(*long colPtr),sqlReturn,proc
! opens the connection
connect            procedure()
! closes the connection
disconnect         procedure()
! execute the query and fill the queue input
execQuery          procedure(*queue q)
! protected methods
clearColumns       procedure(),protected
clearParameters    procedure(),protected
! private methods
allocateColumns    procedure(),private
! parameters
AllocateParameters procedure(),private
  end ! class
! ======================================
  _EndOfInclude_