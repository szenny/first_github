#include "base.h"

extern void Hello();    /* Assembly Code for printing "hello ARM world!" */

int main (void)
{
	
  sendstr("Hello Keil\n");
  Hello();	/* commnets are added for test */

  _sys_exit(0);
}
