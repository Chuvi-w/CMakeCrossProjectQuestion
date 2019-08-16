
OUTPUT_ARCH("mips:isa32")
TARGET("elf32-littlemips")
OUTPUT_FORMAT (elf32-littlemips)
/*
INPUT ( DeviceLib\DeviceLib.a )
*/
ENTRY ( _start )



SECTIONS{ 
	.text 0x80008000 : 
	{
      		*(.text) *(.rodata)
                *(.reginfo)
      		_etext = ALIGN(0x200);
		. = ALIGN(0x200);
    	} 

    	.data_copy :  
    	{ 
		_data_copy = .;
    	}

  	.data  0x81000000:  AT ( _data_copy )  
    	{
      		_data = .;
      		*(.data) 
		* ( .lit8 )
		* ( .lit4 )
		*(.sdata) 
      		_edata = .;
    	}

  	.sbss  ALIGN(0x200) :    { 
		_sbss = .;
		*( .sbss ) 
		*( .scommon ) 
  	}
	_gp = ALIGN(0x200);
  	.bss  :  {
	  *( .bss )
		*( COMMON )
		_ebss = .;
  	}
  	.stack ALIGN(0x200)      :  {
	  _stack = .;
  	}
	_stack_size = 4k ;
	_estack = _stack + _stack_size ;
}

