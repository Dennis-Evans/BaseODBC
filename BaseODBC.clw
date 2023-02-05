
  member()

  include('BaseODBC.inc'),once

  include('odbcTypes.inc'),once
  include('odbcConnStrCl.inc'),once
  include('odbcConn.inc'),once
  include('odbcCl.inc'),once
  include('odbcColumnsCl.inc'),once
  include('odbcParamsCl.inc'),once

!region set up clean up

BaseODBC.construct procedure()

  code

  self.columnsAllocated = false
  self.parametersAllocated = false

  self.connStr &= new(MSConnStrClType)
  self.conn &= new(ODBCConnectionClType)
  self.odbc &= new(odbcClType)

  return
! end constructor ---------------------------------------------------

! ----------------------------------------------------
! calls kill to dispose the objects
! ----------------------------------------------------
BaseODBC.destruct procedure() !virtual

  code

  self.kill();

  return
! end destructor ---------------------------------------------------

! ------------------------------------------------------------
! init's the various objects and assigns the connection string
! object and the connection object
! ------------------------------------------------------------
BaseODBC.init procedure(string srvName, string dbName)

retv byte(level:Benign)

  code

  self.connStr.init(srvName, dbName)
  self.connStr.setTrustedConn(true)

  self.conn.init(self.connStr)
  self.odbc.init(self.conn)

  return retv
! end init ---------------------------------------------------------

! ------------------------------------------------------------
! typical clean up, disposes the various objects
! ------------------------------------------------------------
BaseODBC.kill procedure()

  code

  dispose(self.connStr)
  dispose(self.conn)
  dispose(self.odbc)

  dispose(self.cols)
  dispose(self.params)

  self.columnsAllocated = false
  self.parametersAllocated = false

  return
! end kill ----------------------------------------------------------

!endregion set up clean up

!region connect disconnect

! ------------------------------------------------------------
! connects to the database
! check the return value when calling, the connection may fail
! ------------------------------------------------------------
BaseODBC.connect procedure() !sqlReturn

retv sqlReturn,auto

   code

  retV = self.conn.connect()

   return retv
! end connect -------------------------------------------------

! ------------------------------------------------------------
! disconnects from  the database
! the return value can be check, but if the disconnect
! fails things have gone south
! ------------------------------------------------------------
BaseODBC.disconnect procedure() !sqlReturn,proc

retv sqlReturn,auto

   code

   retv = self.conn.disconnect()

   return retv
! end disconnect ----------------------------------------------

!endregion connect disconnect

!region query

! ------------------------------------------------------------
! executes the query that was set up and fills the queue
! input with the values from the result set
! ------------------------------------------------------------
BaseODBC.execQuery procedure(*queue que)

retv sqlReturn,auto

  code

  ! checks to see if any parameters were added, if not then
  ! call execQuery/4
  if (self.queryHasParameters() = false)
    retv = self.odbc.execQuery(self.sqlCode, self.cols, que)
  else
    retv = self.odbc.execQuery(self.sqlCode, self.cols, self.params, que)
  end

  return retv
! end execQuery ------------------------------------------------------

! ------------------------------------------------------------
! executes the query that was set up and fills the group
! input with the values from the result set
! this result set will contain a single row
! ------------------------------------------------------------
BaseODBC.execQuery procedure(*group g)

retv sqlReturn,auto

   code

  ! checks to see if any parameters were added, if not then
  ! call execQuery/4
  if (self.queryHasParameters() = false)
    retv = self.odbc.execQuery(self.sqlCode, self.cols, g)
  else
    retv = self.odbc.execQuery(self.sqlCode, self.cols, self.params, g)
  end

   return retv
! end execQuery ------------------------------------------------------

!!!<summary>
!!! clears the columns, parameters and the sql statement in the dynamic string.
!!! Note: Call this before setting up a query.  if not called
!!! the columns and parameters from the previous query
!!! may still be in the list
!!!</summary>
BaseODBC.clearQuery procedure() !virtual

  code

  self.clearColumns()
  self.clearParameters()

  if (~Self.sqlCode &= null)
    self.sqlCode.Kill()
  end

  return;
! end clearQuery ---------------------------------------

! ------------------------------------------------------------
! primes the dynamic string with the sql statement input
! ------------------------------------------------------------
BaseODBC.primeQuery procedure(*IDynStr query) !virtual

   code

   self.primeQuery(query.str())

   return
! end primeQuery ---------------------------------------

! ------------------------------------------------------------
! primes the dynamic string with the sql statement input
! ------------------------------------------------------------
BaseODBC.primeQuery procedure(string  query) !virtual

  code

   if (self.sqlCode &= nuLL)
     self.sqlCode &= newDynStr()
   end

   self.sqlCode.kill()
   self.sqlCode.cat(query)

  return
! end primeQuery ---------------------------------------

! ------------------------------------------------------
! checks for parameters on the query
! if none then return false
! if one or more parameters return true
! ------------------------------------------------------
BaseODBC.queryHasParameters procedure() !,bool,private

retv bool,auto

  code

  if ((self.params &= null) or (self.params.HasParameters() = false))
    retv = false
  else
    retv = true
  end

  return retv
! end queryHasParameters --------------------------------

!endregion query

!region columns

! ------------------------------------------------------------
! adds a string column to the query
! ------------------------------------------------------------
BaseODBC.AddColumn procedure(*string colPtr) !,sqlReturn,proc

retv sqlReturn,auto

  code

  if (self.columnsAllocated = false)
    self.allocateColumns()
  end
  retv = self.cols.addColumn(colPtr)

  return retv
! end AddColumn ----------------------------------------------------

! ------------------------------------------------------------
! adds an integer column to the query
! ------------------------------------------------------------
BaseODBC.AddColumn procedure(*long colPtr) !,sqlReturn,proc

retv sqlReturn,auto

  code

  if (self.columnsAllocated = false)
    self.allocateColumns()
  end
  retv = self.cols.addColumn(colPtr)

  return retv
! end AddColumn ----------------------------------------------------

! ------------------------------------------------------------
! the remaining add column functions do the same work
! as the long and string over loads, just for the specific
! data type
! ------------------------------------------------------------
BaseODBC.AddColumn procedure(*real colPtr) !sqlReturn,proc

retv sqlReturn,auto

  code

  if (self.columnsAllocated = false)
    self.allocateColumns()
  end
  retv = self.cols.addColumn(colPtr)

  return retv
! end AddColumn ----------------------------------------------------

BaseODBC.AddColumn procedure(*TIMESTAMP_STRUCT colPtr) !sqlReturn,proc

retv sqlReturn,auto

  code

  if (self.columnsAllocated = false)
    self.allocateColumns()
  end
  retv = self.cols.addColumn(colPtr)

  return retv
! end AddColumn ----------------------------------------------------

! ------------------------------------------------------------
! clears the columns queue
! ------------------------------------------------------------
BaseODBC.clearColumns procedure() ! protected

  code

  if (~self.cols &= null)
    self.cols.clearQ()
  end

  return
! end clearColumns --------------------------------------------

! ------------------------------------------------------------
! allocates the columns class if not crated and sets the flag
! ------------------------------------------------------------
BaseODBC.allocateColumns procedure() ! private

  code

  if (self.cols &= null)
    self.cols &= new(columnsClass)
  end
  self.columnsAllocated = true

  return
! end allocateColumns ---------------------------------------

!endregion columns

!region parameters

! ------------------------------------------------------------
! clears the parameters
! ------------------------------------------------------------
BaseODBC.clearParameters procedure() ! protected

  code

  if (~self.params &= null)
    self.params.clearQ()
  end

  return
! clearParameters ----------------------------------------------

! ------------------------------------------------------------
! adds an input integer parameter
! ------------------------------------------------------------
BaseODBC.AddInParameter  procedure(*long colPtr) !sqlReturn,proc

retv sqlReturn,auto

  code

  if (self.parametersAllocated = false)
    self.AllocateParameters()
  end
  retv = self.params.addInParameter(colPtr)

  return retv
! end addParameter ------------------------------------------------

! adds the parameters for the specific type
BaseODBC.AddInParameter procedure(*cstring colPtr) !sqlReturn,proc

retv sqlReturn,auto

  code

  if (self.parametersAllocated = false)
    self.AllocateParameters()
  end
  retv = self.params.addInParameter(colPtr)

  return retv
! end addParameter ------------------------------------------------

BaseODBC.AddInParameter procedure(*real colPtr) !sqlReturn,proc

retv sqlReturn,auto

  code

  if (self.parametersAllocated = false)
    self.AllocateParameters()
  end
  retv = self.params.addInParameter(colPtr)

  return retv
! end addParameter ------------------------------------------------

BaseODBC.AddInParameter procedure(*TIMESTAMP_STRUCT colPtr) !sqlReturn,proc

retv sqlReturn,auto

  code

  if (self.parametersAllocated = false)
    self.AllocateParameters()
  end
  retv = self.params.addInParameter(colPtr)

  return retv
! end addParameter ------------------------------------------------

! ------------------------------------------------------------
! allocates the parameters class if not created and sets the flag
! ------------------------------------------------------------
BaseODBC.AllocateParameters procedure()

  code

  if (self.params &= null)
    self.params &= new(ParametersClass)
  end
  self.parametersAllocated = true

  return
! end AllocateParameters -------------------------------------------

!endregion parameters
