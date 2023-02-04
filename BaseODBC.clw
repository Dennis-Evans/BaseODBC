
  member()

  include('BaseODBC.inc'),once

  include('odbcTypes.inc'),once
  include('odbcConnStrCl.inc'),once
  include('odbcConn.inc'),once
  include('odbcCl.inc'),once
  include('odbcColumnsCl.inc'),once
  include('odbcParamsCl.inc'),once


BaseODBC.construct procedure()

  code

  self.columnsAllocated = false
  self.parametersAllocated = false

  self.connStr &= new(MSConnStrClType)
  self.conn &= new(ODBCConnectionClType)
  self.odbc &= new(odbcClType)

  return
! end constructor ---------------------------------------------------

BaseODBC.destruct procedure() !virtual

  code

  self.kill();

  return
! end destructor ---------------------------------------------------

BaseODBC.init procedure(string srvName, string dbName)

  code

  self.connStr.init(srvName, dbName)
  self.connStr.setTrustedConn(true)
  self.conn.init(self.connStr)
  self.odbc.init(self.conn)

  return
! end init ---------------------------------------------------------

BaseODBC.kill procedure()

  code

  dispose(self.connStr)
  dispose(self.conn)
  dispose(self.odbc)

  dispose(self.cols)
  dispose(self.params)

  return
! end kill ----------------------------------------------------------


BaseODBC.execQuery procedure(*queue que)

retv sqlReturn

  code

  if ((self.params &= null) or (self.params.HasParameters() = false))
    retv = self.odbc.execQuery(self.sqlCode, self.cols, que)
  else
    retv = self.odbc.execQuery(self.sqlCode, self.cols, self.params, que)
  end

  return
! end execQuery ------------------------------------------------------

BaseODBC.connect procedure()

   code

   self.conn.connect()

   return

BaseODBC.disconnect procedure()

   code

   self.conn.disconnect()

   return

BaseODBC.clearQuery procedure() !virtual

  code

  self.clearColumns()
  self.clearParameters()

  if (~Self.sqlCode &= null)
    self.sqlCode.Kill()
  end

  return;
! end clearQuery ---------------------------------------

BaseODBC.primeQuery procedure(*IDynStr query)

   code

   self.primeQuery(query.str())

   return

BaseODBC.primeQuery procedure(string  query)

  code

   if (self.sqlCode &= nuLL)
     self.sqlCode &= newDynStr()
   end

   self.sqlCode.kill()
   self.sqlCode.cat(query)

  return

BaseODBC.AddColumn procedure(*string colPtr) !,sqlReturn,proc

  code

  if (self.columnsAllocated = false)
    self.allocateColumns()
  end
  self.cols.addColumn(colPtr)

  return 0
! end AddColumn ----------------------------------------------------

BaseODBC.AddColumn procedure(*long colPtr) !,sqlReturn,proc

  code

  if (self.columnsAllocated = false)
    self.allocateColumns()
  end
  self.cols.addColumn(colPtr)

  return 0
! end AddColumn ----------------------------------------------------

BaseODBC.clearColumns procedure() ! protected

  code

  if (~self.cols &= null)
    self.cols.clearQ()
  end

  return

BaseODBC.allocateColumns procedure() ! private

  code

  if (self.cols &= null)
    self.cols &= new(columnsClass)
  end
  self.columnsAllocated = true

  return

BaseODBC.clearParameters procedure() ! protected

  code

  if (~self.params &= null)
    self.params.clearQ()
  end

  return


BaseODBC.AddInParameter  procedure(*long colPtr) !sqlReturn,proc

  code

  if (self.parametersAllocated = false)
    self.AllocateParameters()
  end
  self.params.addInParameter(colPtr)

  return 0
! end addParameter ------------------------------------------------

BaseODBC.AllocateParameters procedure()

  code

  if (self.params &= null)
    self.params &= new(ParametersClass)
  end
  self.parametersAllocated = true

  return
! end AllocateParameters -------------------------------------------

