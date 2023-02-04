
  program

  include('BaseODBC.inc'),once
  !include('odbcTypes.inc'),once

   map
     main()
     execSimpleQuery()
     execSimpleQueryWith()
   end

odbcWorker &BaseODBC

serverName   string('dennis-ltsag\srv_3_1_13')
databaseName string('phd_Chey')

q queue
id long
s  string(110)
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

execSimpleQuery procedure()

retv sqlReturn,auto

  code

  odbcWorker.clearQuery()

  odbcWorker.primeQuery('select c.casecaseId, c.label from cases.cases c order by c.casecaseid;')
  odbcWorker.addColumn(q.id)
  odbcWorker.addColumn(q.s)

  retv = odbcWorker.connect()
  if (retv = Sql_Success) 
    odbcWorker.execQuery(q)
  end
  
  odbcWorker.Disconnect()

  return
! ------------------------------------------------------------------

execSimpleQueryWith procedure()

retv sqlReturn,auto

beginValue long(1)
endValue   long(12)

  code

  odbcWorker.clearQuery()

  odbcWorker.primeQuery('select c.caseCaseId, c.label from cases.cases c where ((c.caseCaseId >= ?) and (c.caseCaseId <= ?)) order by c.caseCaseId;')
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

