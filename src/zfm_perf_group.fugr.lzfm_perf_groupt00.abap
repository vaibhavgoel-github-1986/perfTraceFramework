*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZDT_PERF_STEPS..................................*
DATA:  BEGIN OF STATUS_ZDT_PERF_STEPS                .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZDT_PERF_STEPS                .
CONTROLS: TCTRL_ZDT_PERF_STEPS
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZDT_PERF_STEPS                .
TABLES: ZDT_PERF_STEPS                 .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
