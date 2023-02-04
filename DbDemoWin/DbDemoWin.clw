
  program

  ! ====================================================================
  ! simple example using the baseODBC object
  !
  ! the sln, CwProj and clw file are in the repo
  !
  ! currently only Windows Auth. is used, SQL Auth. will be added
  !
  ! set the server and database names in the variables
  !
  ! enter a query in the functions,
  ! ====================================================================

  include('BaseODBC.inc'),once

   map
     main()
     execSimpleQuery()
     execSimpleQueryWith()
   end

! instance to use for the example
odbcWorker &BaseODBC

! set the server name and database names here
serverName   string('<your server name>')
databaseName string('<your database name')

! example queue
q  queue
id   long
s    string(80)
  end

  code

  main()

  return
! end program ========================================================

main procedure()

MyWindow WINDOW('Demo'),AT(,,385,126),CENTER,GRAY,FONT('MS Sans Serif',8,,FONT:regular)
    BUTTON('Exec Query No Parameters'),AT(20,68,117,14),USE(?ExecNoParams),LEFT
    BUTTON('&Done'),AT(202,94,50,14),USE(?CancelButton),LEFT
    BUTTON('Exec Query With Parameters'),AT(20,94,117,14),USE(?ExecWithParams),LEFT
  END

  code

  odbcWorker &= new(BaseODBC)
  odbcWorker.init(serverName, databaseName)

  open(MyWindow)
  accept
    case field()
    of ?ExecWithParams
      case event()
        of event:accepted
          execSimpleQueryWith()
          message('number of rows from result set ' & records(q), 'Rows')
          free(q)
      end
    of ?ExecNoParams
       case event()
       of  event:Accepted
         execSimpleQuery()
         message('number of rows from result set ' & records(q), 'Rows')
         free(q)
       end
    of ?CancelButton
       case event()
       of event:Accepted
         post(event:CloseWindow)
       end
    end
  end ! accept loop

  return
! end Main ===============================================================

! =========================================================
! execute a query without any  parameters, bad practice.
! =========================================================
execSimpleQuery procedure()

retv sqlReturn,auto

  code

  odbcWorker.clearQuery()

  odbcWorker.primeQuery('<query with out parameters>')
  odbcWorker.addColumn(q.id)
  odbcWorker.addColumn(q.s)

  retv = odbcWorker.connect()
  if (retv = Sql_Success)
    odbcWorker.execQuery(q)
  end

  odbcWorker.Disconnect()

  return
! ------------------------------------------------------------------

! =========================================================
! execute a query with one or more parameters.
! =========================================================
execSimpleQueryWith procedure()

retv sqlReturn,auto

beginValue long(1)
endValue   long(12)

  code

  odbcWorker.clearQuery()

  odbcWorker.primeQuery('<query with out parameters>')
  odbcWorker.addColumn(q.id)
  odbcWorker.addColumn(q.s)
  odbcWorker.AddInParameter(beginValue)
  odbcWorker.AddInParameter(endValue)

  retv = odbcWorker.connect()
  if (retv = Sql_Success)
    odbcWorker.execQuery(q)
  end

  odbcWorker.Disconnect()

  return
! ------------------------------------------------------------------

