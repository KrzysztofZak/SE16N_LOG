"! BAL exception
class ZCX_SE16N_LOG_ERROR definition
  public
  inheriting from CX_DYNAMIC_CHECK
  create public .

public section.

  interfaces IF_T100_MESSAGE .

  data MV_ATTR1 type SYST_MSGV read-only .
  data MV_ATTR2 type SYST_MSGV read-only .
  data MV_ATTR3 type SYST_MSGV read-only .
  data MV_ATTR4 type SYST_MSGV read-only .

      "! @parameter iv_msgid | Message id
      "! @parameter iv_msgno | Message number
      "! @parameter iv_msgv1 | Message variable 1
      "! @parameter iv_msgv2 | Message variable 2
      "! @parameter iv_msgv3 | Message variable 3
      "! @parameter iv_msgv4 | Message variable 4
  methods CONSTRUCTOR
    importing
      !TEXTID like IF_T100_MESSAGE=>T100KEY optional
      !PREVIOUS like PREVIOUS optional
      !MV_ATTR1 type SYST_MSGV optional
      !MV_ATTR2 type SYST_MSGV optional
      !MV_ATTR3 type SYST_MSGV optional
      !MV_ATTR4 type SYST_MSGV optional .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCX_SE16N_LOG_ERROR IMPLEMENTATION.


  method CONSTRUCTOR.
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
PREVIOUS = PREVIOUS
.
me->MV_ATTR1 = MV_ATTR1 .
me->MV_ATTR2 = MV_ATTR2 .
me->MV_ATTR3 = MV_ATTR3 .
me->MV_ATTR4 = MV_ATTR4 .
clear me->textid.
if textid is initial.
  IF_T100_MESSAGE~T100KEY = IF_T100_MESSAGE=>DEFAULT_TEXTID.
else.
  IF_T100_MESSAGE~T100KEY = TEXTID.
endif.
  endmethod.
ENDCLASS.
