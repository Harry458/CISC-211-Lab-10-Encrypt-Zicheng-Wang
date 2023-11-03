/*** asmEncrypt.s   ***/

#include <xc.h>

# Declare the following to be in data memory 
.data  

# Define the globals so that the C code can access them
# (in this lab we return the pointer, so strictly speaking,
# doesn't really need to be defined as global)
# .global cipherText
.type cipherText,%gnu_unique_object

.align
# space allocated for cipherText: 200 bytes, prefilled with 0x2A */
cipherText: .space 200,0x2A  
 
# Tell the assembler that what follows is in instruction memory    
.text
.align

# Tell the assembler to allow both 16b and 32b extended Thumb instructions
.syntax unified

    
/********************************************************************
function name: asmEncrypt
function description:
     pointerToCipherText = asmEncrypt ( ptrToInputText , key )
     
where:
     input:
     ptrToInputText: location of first character in null-terminated
                     input string. Per calling convention, passed in via r0.
     key:            shift value (K). Range 0-25. Passed in via r1.
     
     output:
     pointerToCipherText: mem location (address) of first character of
                          encrypted text. Returned in r0
     
     function description: asmEncrypt reads each character of an input
                           string, uses a shifted alphabet to encrypt it,
                           and stores the new character value in memory
                           location beginning at "cipherText". After copying
                           a character to cipherText, a pointer is incremented 
                           so that the next letter is stored in the bext byte.
                           Only encrypt characters in the range [a-zA-Z].
                           Any other characters should just be copied as-is
                           without modifications
                           Stop processing the input string when a NULL (0)
                           byte is reached. Make sure to add the NULL at the
                           end of the cipherText string.
     
     notes:
        The return value will always be the mem location defined by
        the label "cipherText".
     
     
********************************************************************/    
.global asmEncrypt
.type asmEncrypt,%function
asmEncrypt:   

    # save the caller's registers, as required by the ARM calling convention
    push {r4-r11,LR}
    
    /* YOUR asmEncrypt CODE BELOW THIS LINE! VVVVVVVVVVVVVVVVVVVVV  */
    
   LDR r4, =cipherText   /* Load the address of the "cipherText" into register r4 */
do:		       /* Loop*/
    LDRB r5, [r0], 1   /* Load a byte from the memory address pointed to by r0(first char) into r5, and increment r0 by 1(check the next char)*/
    CMP r5, 0          /* Compare the value in r5(char) with 0 */
    BEQ done           /* Branch to the "done" label if r5(char) is equal to 0 */
    CMP r5, 64         /* Compare the value in r5(char) with 64 */
    BGT in_range_C     /* Branch to "in_range_C" if r5(char) is greater than 64 */
outside_C:	       /* Braanc back if is outside of Uppercase aciss table*/
    CMP r5, 96         /* Compare the value in r5(char) with 96 */
    BGT in_range_L     /* Branch to "in_range_L" if r5(char) is greater than 96 */
outside_L:	       /* Braanc back if is outside of Lowercase aciss table*/
continus:
    STRB r5, [r4], 1   /* Store the value in r5 to the memory address pointed to by r4, and increment r4 by 1 */
    B do               /* Unconditional branch back to the "do" label */

in_range_C:
    CMP r5, 90         /* Compare the value in r5(char) with 90 */
    BGT outside_C      /* Branch to "outside_C" if r5(char) is greater than 90 */
    ADD r5, r5, r1     /* Add the value in r1(key value) to r5(char) */
    CMP r5, 90         /* Compare the new value in r5(char) with 90 */
    BGT overflow       /* Branch to "overflow" if the new value is greater than 90 */
    B continus         /* Unconditional branch to "continus" to proceed with the loop */

in_range_L:
    CMP r5, 122        /* Compare the value in r5(char) with 122 */
    BGT outside_L      /* Branch to "outside_L" if r5(char) is greater than 122 */
    ADD r5, r5, r1     /* Add the value in r1(key value) to r5(char) */
    CMP r5, 122        /* Compare the new value in r5(char) with 122 */
    BGT overflow       /* Branch to "overflow" if the new value is greater than 122 */
    B continus         /* Unconditional branch to "continus" to proceed with the loop */

overflow:
    SUB r5, r5, 26     /* Subtract 26 from r5(char) make it not overflow*/
    B continus         /* Unconditional branch to "continus" to proceed with the loop */

done:
    STRB r5, [r4], 1   /* Store the final value in r5(char " ") to address of the "cipherText", and increment address by 1 */
    LDR r0, =cipherText /* Reload the address of "cipherText" into r0 */

	
	
    
    
    
    
    
    
    
    /* YOUR asmEncrypt CODE ABOVE THIS LINE! ^^^^^^^^^^^^^^^^^^^^^  */

    # restore the caller's registers, as required by the ARM calling convention
    pop {r4-r11,LR}

    mov pc, lr	 /* asmEncrypt return to caller */
   

/**********************************************************************/   
.end  /* The assembler will not process anything after this directive!!! */
           




