

#define CP0_CompareRg       $11
#define CP0_StatusRg        $12
#define CP0_CauseRg         $13  
#define CP0_ConfigRg        $16
#define CSCON0_addr  0xB82F1000
#define k0	$26	
#define k1	$27


	.extern	_data
	.extern	_esdata
	.extern	_sdata
	.extern	_sbss
	.extern	_ebss
	.extern	_gp


	.text
	.set    noreorder
	.set    noat
	.set volatile
    .align  2
    .globl  _start;
	.ent	_start;
_start:
  ## init CP0 registers
  li  k0, 0x10400000
  mtc0  k0, CP0_StatusRg
  nop
  mtc0  $0, CP0_CauseRg
  nop

  mtc0  $0, CP0_CompareRg
  nop
  mfc0  k0, CP0_ConfigRg
  ori   k0, 0x01
  mtc0  k0, CP0_ConfigRg
  nop

  li k1, CSCON0_addr
  li k0, 0x001700ff     # 

  sw k0,0(k1)
  nop

   	# /*   Start   */
    la   $9,main_c
	jal  $9
    nop

.end	_start

